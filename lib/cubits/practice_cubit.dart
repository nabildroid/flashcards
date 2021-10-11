import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flashcards/core/scheduler.dart';
import 'package:flashcards/models/general.dart';
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

class PracticeState extends Equatable {
  final List<Cart> learningCards;
  final List<CardMemorization> learned;

  final DateTime startTime;
  final int index;
  final int total;
  final String learningTime;

  final PracticeStatus status;

  PracticeState({
    required this.learningCards,
    required this.learned,
    required this.startTime,
    required this.status,
    required this.learningTime,
  })  : index = learned.length,
        total = learningCards.length;

  factory PracticeState.init() => PracticeState(
        learned: [],
        learningCards: [],
        startTime: DateTime.now(),
        status: PracticeStatus.init,
        learningTime: "00:00",
      );

  copyWith({
    List<CardMemorization>? learned,
    List<Cart>? learningCards,
    PracticeStatus? status,
    String? learningTime,
  }) {
    return PracticeState(
      learningCards: learningCards ?? this.learningCards,
      learned: learned ?? this.learned,
      startTime: learningCards != null ? DateTime.now() : startTime,
      status: status ?? this.status,
      learningTime: learningTime ?? this.learningTime,
    );
  }

  @override
  List<Object?> get props =>
      [learningCards, learned, startTime, index, total, status, learningTime];
}

class PracticeCubit extends Cubit<PracticeState> {
  final Provider _repository;
  final _scheduler = Scheduler();

  PracticeCubit(this._repository) : super(PracticeState.init());

  void addFeedback(MemorizationState feedback) async {
    final card = state.learningCards[state.index];
    final memorized = CardMemorization(
      id: card.id,
      state: feedback,
      time: DateTime.now(),
    );

    emit(state.copyWith(learned: [...state.learned, memorized]));
    if (state.index == state.learningCards.length) {
      return emit(state.copyWith(status: PracticeStatus.saving));
    }

    _resumeLearning();
  }

  Future<void> _submit() async {
    await _repository.submitScore(Score(
      cards: state.learned,
      startTime: state.startTime,
      endTime: DateTime.now(),
    ));
    emit(state.copyWith(status: PracticeStatus.finished));
  }

  @override
  void onChange(Change<PracticeState> change) async {
    if (change.nextState.status == PracticeStatus.saving) {
      await _submit();
    }

    super.onChange(change);
  }

  void fetch() async {
    emit(state.copyWith(status: PracticeStatus.loading));
    final cards = await _repository.getCards("");
    _scheduler.init(cards);

    final selected = await _scheduler.selected();
    emit(state.copyWith(
      learningCards: selected,
    ));

    _resumeLearning();
    _startTimer();
  }

  void _resumeLearning() {
    emit(state.copyWith(status: PracticeStatus.paused));

    Future.delayed(const Duration(seconds: 1)).then((_) {
      if (state.status == PracticeStatus.paused) {
        emit(state.copyWith(
          status: PracticeStatus.practicing,
        ));
      }
    });
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
