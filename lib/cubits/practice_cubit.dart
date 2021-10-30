import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flashcards/core/scheduler.dart';
import 'package:flashcards/core/utils.dart';
import 'package:flashcards/models/memorization.dart';
import 'package:flashcards/models/practice_flashcard.dart';
import 'package:flashcards/models/progress.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/repositories/repository_factory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum PracticeStatus {
  loading,
  paused,
  practicing,
  finished,
  saving,
  init,
}

enum PracticeMode {
  learning,
}

class PracticeState extends Equatable {
  final List<PracticeFlashcard> toPractice;
  final List<FlashcardMemorization> reviewed;

  final DateTime startTime;
  final int index;
  final int total;
  final String learningTime;

  final PracticeStatus status;

  const PracticeState({
    required this.toPractice,
    required this.reviewed,
    required this.startTime,
    required this.status,
    required this.learningTime,
  })  : index = reviewed.length,
        total = toPractice.length;

  factory PracticeState.init() => PracticeState(
        reviewed: const [],
        toPractice: const [],
        startTime: DateTime.now(),
        status: PracticeStatus.init,
        learningTime: "00:00",
      );

  copyWith({
    List<FlashcardMemorization>? reviewed,
    List<PracticeFlashcard>? toPractice,
    PracticeStatus? status,
    String? learningTime,
  }) {
    return PracticeState(
      toPractice: toPractice ?? this.toPractice,
      reviewed: reviewed ?? this.reviewed,
      startTime: toPractice != null ? DateTime.now() : startTime,
      status: status ?? this.status,
      learningTime: learningTime ?? this.learningTime,
    );
  }

  @override
  List<Object?> get props =>
      [toPractice, reviewed, startTime, index, total, status, learningTime];
}

class PracticeCubit extends Cubit<PracticeState> {
  final ReposityFactory _repository;
  final _scheduler = Scheduler();

  PracticeCubit(this._repository) : super(PracticeState.init());

  void addFeedback(MemorizationState feedback) async {
    if (state.status != PracticeStatus.practicing) return;

    final practice = state.toPractice[state.index];
    final memorized = FlashcardMemorization(
      id: practice.flashcard.id,
      state: feedback,
      time: DateTime.now(),
      progress: _scheduler.sm2(feedback: feedback, prev: practice.progress),
    );

    emit(state.copyWith(reviewed: [...state.reviewed, memorized]));

    if (state.index == state.toPractice.length) {
      emit(state.copyWith(status: PracticeStatus.saving));
      await _submit();
    } else {
      _pausePracticingForMoment();
    }
  }

  Future<void> _submit() async {
    final score = getScore();
    await _repository.submitScore(score);
    finish();
  }

  void finish() {
    emit(state.copyWith(status: PracticeStatus.finished));
  }

  Score getScore() {
    return Score(
      flashcards: state.reviewed,
      startTime: state.startTime,
      endTime: DateTime.now(),
    );
  }

  void fetch(PracticeMode mode) async {
    emit(PracticeState.init());
    emit(state.copyWith(status: PracticeStatus.loading));

    final selected = await _fetchPracticeCards(10, mode);

    selected.shuffle();

    emit(PracticeState.init().copyWith(
      toPractice: selected,
    ));

    _pausePracticingForMoment();
    _startTimer();
  }

  Future<List<PracticeFlashcard>> _fetchPracticeCards(
    int limit,
    PracticeMode mode,
  ) async {
    final prevProgress = await _repository.getProgress();
    _scheduler.init(prevProgress);

    List<Progress> chosen = [];
    if (mode == PracticeMode.learning) {
      chosen = await _scheduler.selected();
    }

    final List<PracticeFlashcard> selected = [];

    for (var item in chosen) {
      final query = await _repository.getFlashcardByIds([item.id]);
      if (query.isNotEmpty) {
        selected.add(PracticeFlashcard(
          query[0],
          item,
        ));
      }

      if (selected.length >= limit) {
        break;
      }
    }

    return selected;
  }

  void _pausePracticingForMoment() async {
    emit(state.copyWith(status: PracticeStatus.paused));

    final duration = _pausingTimeBasedOnPrevSession();
    await Future.delayed(duration);

    emit(state.copyWith(status: PracticeStatus.practicing));
  }

  Duration _pausingTimeBasedOnPrevSession() {
    // BUG pause time should depend on previous card difficulty
    int s = 0;
    return Duration(seconds: s);
  }

  Future<bool> toggleBoosted(bool boosted) async {
    // BUG implement this!
    return boosted;
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final isSessionFinished = state.status == PracticeStatus.finished ||
          state.status == PracticeStatus.saving;

      if (isSessionFinished) {
        return timer.cancel();
      }

      emit(state.copyWith(
        learningTime: minutesHoursFrom(state.startTime),
      ));
    });
  }
}
