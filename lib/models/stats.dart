import 'package:flashcards/entities.dart/stats.dart';
import 'package:hive/hive.dart';

import 'memorization.dart';

class Stats extends StatsEntity {
  @override
  final DateTime date;

  @override
  final Map<MemorizationState, int> states;

  Stats({
    required this.date,
    required this.states,
  }) : super(
          date,
          states,
        );

  Stats.generate(this.date, this.states) : super(date, states);

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
