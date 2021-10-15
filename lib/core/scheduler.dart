import 'dart:math';

import 'package:flashcards/core/utils.dart';
import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/memorization.dart';

extension MemorizationStateQuality on MemorizationState {
  int quality() {
    if (this == MemorizationState.easy) {
      return 5;
    } else if (this == MemorizationState.good) {
      return 3;
    } else {
      return 1;
    }
  }
}

class SchedulerProgress {
  final int interval;
  final double ease;
  final int repetitions;

  SchedulerProgress({
    required this.interval,
    required this.ease,
    required this.repetitions,
  });

  SchedulerProgress.init()
      : ease = 1.3,
        interval = 1,
        repetitions = 0;
}

class Vote {
  final double score;
  final Cart cart;

  Vote(this.cart, this.score);
}

class Scheduler {
  List<Cart> cards = [];

  Scheduler();

  void init(List<Cart> cards) {
    this.cards = cards;
  }

  Future<List<Cart>> selected(int limit) async {
    await Future.value();
    final election = this.election();
    election.sort((a, b) => (a.score - b.score).toInt());

    return election
        .sublist(0, min(election.length, limit))
        .map((e) => e.cart)
        .toList();
  }

  List<Vote> election() {
    return cards
        .map((card) => Vote(card, computeScore(card.progress)))
        .toList();
  }

  double computeScore(SchedulerProgress progress) {
    double total = 0.0;
    total += progress.repetitions / (progress.ease * 10);
    total += progress.interval - dateInDays(DateTime.now());

    if (progress.repetitions < 2) {
      total -= 10;
    }

    return total;
  }

  SchedulerProgress sm2({
    required MemorizationState feedback,
    required SchedulerProgress prev,
    int dueInterval = 0,
  }) {
    final quality = feedback.quality();
    var interval = 0;
    var ease = 0.0;
    var repetitions = prev.repetitions;

    if (quality >= 3) {
      if (prev.repetitions == 0) {
        interval = 1;
      } else if (prev.repetitions == 1) {
        interval = 6;
      } else {
        interval = (prev.ease * prev.interval).round();
      }

      repetitions++;
      ease = prev.ease + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    } else {
      repetitions = 0;
      interval = 1;
      ease = max(1.3, prev.ease);
    }

    return SchedulerProgress(
      ease: ease,
      interval: interval,
      repetitions: repetitions,
    );
  }
}
