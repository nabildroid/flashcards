import 'package:flashcards/entities.dart/stats.dart';

import 'memorization.dart';

class Stats extends StatsEntity {
  Stats({
    required DateTime date,
    required Map<MemorizationState, int> states,
  }) : super(
          date,
          states,
        );

  Stats.generate(DateTime date, Map<MemorizationState, int> states)
      : super(date, states);

  factory Stats.fromJson(Map json) {
    final jsonStats = json["states"] as Map<String, dynamic>;
    final Map<MemorizationState, int> stats = {};

    jsonStats.forEach((key, val) {
      stats.putIfAbsent(
          MemorizationState.values[int.parse(key) - 1], () => val);
    });
    return Stats(
      date: DateTime.parse(json["updated"]),
      states: stats,
    );
  }
}
