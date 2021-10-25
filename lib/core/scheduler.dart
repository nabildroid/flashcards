import 'dart:math';

import 'package:flashcards/core/utils.dart';
import 'package:flashcards/entities/progress.dart';
import 'package:flashcards/models/memorization.dart';
import 'package:flashcards/models/progress.dart';

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

class Vote {
  final double score;
  final Progress progress;

  Vote(this.progress, this.score);
}

class Scheduler {
  List<Progress> progress = [];

  Scheduler();

  void init(List<Progress> progress) {
    this.progress = progress;
  }

  Future<List<Progress>> selected(int limit) async {
    await Future.value();
    final election = this.election();
    election.sort((a, b) => (a.score - b.score).toInt());

    return election
        .sublist(0, min(election.length, limit))
        .map((e) => e.progress)
        .toList();
  }

  List<Vote> election() {
    return progress.map((p) => Vote(p, computeScore(p))).toList();
  }

  double computeScore(Progress progress, {bool boost = false}) {
    double total = 0.0;
    total += progress.repetitions / (progress.ease * 10);
    final interval = progress.interval + dateInDays(progress.updated);
    total += interval - dateInDays(DateTime.now());

    if (progress.repetitions < 2) {
      total -= 10;
    }

    if (boost) {
      total -= total / 2;
    }

    return total;
  }

  ProgressEntity sm2({
    required MemorizationState feedback,
    required ProgressEntity prev,
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

    return ProgressEntity(
      ease: ease,
      interval: interval,
      repetitions: repetitions,
    );
  }
}
