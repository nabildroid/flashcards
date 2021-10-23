import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flashcards/core/scheduler.dart';
import 'package:flashcards/models/memorization.dart';
import 'package:flashcards/models/practice_cart.dart';
import 'package:flashcards/models/progress.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/repositories/provider.dart';
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
  final List<PracticeCart> toPractice;
  final List<CardMemorization> reviewed;

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
    List<CardMemorization>? reviewed,
    List<PracticeCart>? toPractice,
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
  final Provider _repository;
  final _scheduler = Scheduler();

  PracticeCubit(this._repository) : super(PracticeState.init());

  void addFeedback(MemorizationState feedback) async {
    final practice = state.toPractice[state.index];

    final memorized = CardMemorization(
      id: practice.cart.id,
      state: feedback,
      time: DateTime.now(),
      progress: _scheduler.sm2(feedback: feedback, prev: practice.progress),
    );

    emit(state.copyWith(reviewed: [...state.reviewed, memorized]));
    if (state.index == state.toPractice.length) {
      return emit(state.copyWith(status: PracticeStatus.saving));
    }

    _resumeLearning();
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
      cards: state.reviewed,
      startTime: state.startTime,
      endTime: DateTime.now(),
    );
  }

  @override
  void onChange(Change<PracticeState> change) async {
    if (change.nextState.status == PracticeStatus.saving) {
      await _submit();
    }

    super.onChange(change);
  }

  void fetch(PracticeMode mode) async {
    emit(state.copyWith(status: PracticeStatus.loading));

    final selected = await _fetchPracticeCards(10, mode);

    emit(PracticeState.init().copyWith(
      toPractice: selected,
    ));

    _resumeLearning();
    _startTimer();
  }

  Future<List<PracticeCart>> _fetchPracticeCards(
      int limit, PracticeMode mode) async {
    final prevProgress = await _repository.getProgress();
    _scheduler.init(prevProgress);

    List<Progress> chosen = [];
    if (mode == PracticeMode.learning) {
      chosen = await _scheduler.selected(limit);
    }

    final cartIds = chosen.map((progress) => progress.id).toList();
    final carts = await _repository.getCardsByIds(cartIds);

    final practiceCards = carts
        .map(
          (cart) => PracticeCart(
            cart,
            chosen.firstWhere((e) => e.id == cart.id),
          ),
        )
        .toList();

    return practiceCards;
  }

  void _resumeLearning() {
    emit(state.copyWith(status: PracticeStatus.paused));
    // todo pause time should depend on previous card difficulty
    final time = Duration(seconds: 5);

    Future.delayed(time).then((_) {
      if (state.status == PracticeStatus.paused) {
        emit(state.copyWith(
          status: PracticeStatus.practicing,
        ));
      }
    });
  }

  Future<bool> toggleBoosted(bool boosted) async {
    // todo implement this!
    // if (state.status != PracticeStatus.saving) {
    //   final card = state.toPractice[state.index];
    //   await _repository.updateSpecialCard(card.id, boosted);
    // }
    return boosted;
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.status == PracticeStatus.saving) {
        timer.cancel();
      } else {
        final now = DateTime.now();
        final diff = state.startTime.difference(now).abs();
        const sessionDuration = 60 * 5;
        final seconds = (sessionDuration - diff.inSeconds).abs();
        final s = (seconds < sessionDuration ? seconds : 0) % 60;
        final m = ((seconds < sessionDuration ? seconds : 0) / 60).floor();

        final str = (m > 9 ? m.toString() : "0" + m.toString()) +
            ":" +
            (s > 9 ? s.toString() : "0" + s.toString());

        emit(state.copyWith(learningTime: str));
      }
    });
  }
}
