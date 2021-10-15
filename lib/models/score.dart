import 'memorization.dart';

class Score {
  final List<CardMemorization> cards;
  final DateTime startTime;
  final DateTime endTime;

  Score({
    required this.cards,
    required this.startTime,
    required this.endTime,
  });

  Map toJson() {
    return {
      "cards": cards
          .map((e) => ({
                "id": e.id,
                "time": e.time.toIso8601String(),
                "state": e.state.index,
                "progress": {
                  "interval": e.progress.interval,
                  "ease": e.progress.ease,
                  "repetitions": e.progress.repetitions,
                }
              }))
          .toList(),
      "startTime": startTime.toIso8601String(),
      "startEnd": endTime.toIso8601String(),
    };
  }
}
