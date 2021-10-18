import 'package:flashcards/models/memorization.dart';

class Stats {
  final DateTime date;
  final Map<MemorizationState, int> states;

  Stats(this.date, this.states);

  factory Stats.fromJson(Map json) {
    final jsonStats = json["states"] as Map<String, dynamic>;
    final Map<MemorizationState, int> stats = {};

    jsonStats.forEach((key, val) {
      stats.putIfAbsent(MemorizationState.values[int.parse(key)], () => val);
    });
    return Stats(
      DateTime.parse(json["date"]),
      stats,
    );
  }
}
