import 'dart:math';

import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/memorization.dart';

extension MemorizationStateQuality on MemorizationState {
  int quality() {
    if (this == MemorizationState.easy) {
      return 5;
    } else if (this == MemorizationState.good) {
      return 3;
    } else {
      return 5;
    }
  }
}

class SM2Output {
  final int interval;
  final double ease;
  final int repetitions;

  SM2Output({
    required this.interval,
    required this.ease,
    required this.repetitions,
  });
}

class Scheduler {
  List<Cart> cards = [];

  Scheduler();

  void init(List<Cart> cards) {
    this.cards = cards;
  }

  Future<List<Cart>> selected() async {
    await Future.delayed(Duration(milliseconds: 3));

    return this.cards;
  }

  SM2Output _sm2({
    required MemorizationState feedback,
    required double prevEase,
    required int prevInterval,
    required int prevRepetitions,
    int dueInterval = 0,
  }) {
    final quality = feedback.quality();
    var interval = 0;
    var ease = 0.0;
    var repetitions = prevRepetitions;

    if (quality >= 3) {
      if (prevRepetitions == 0) {
        interval = 1;
      } else if (prevRepetitions == 1) {
        interval = 6;
      } else {
        interval = (prevEase * prevInterval).round();
      }

      repetitions++;
      ease = prevEase + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    } else {
      repetitions = 0;
      interval = 1;
      ease = max(1.3, prevEase);
    }

    return SM2Output(
      ease: ease,
      interval: interval,
      repetitions: repetitions,
    );
  }
}
