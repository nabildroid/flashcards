import 'package:flashcards/models/memorization.dart';
import 'package:hive/hive.dart';

part 'stats.g.dart';

@HiveType(typeId: 4)
class Stats {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final Map<MemorizationState, int> states;

  Stats(this.date, this.states);

  Stats mergeWith(Stats merge) {
    final result = Stats(merge.date, {});

    states.forEach((key, value) {
      result.states.putIfAbsent(key, () => 0);
      result.states.update(key, (v) => v + value);
    });

    merge.states.forEach((key, value) {
      result.states.putIfAbsent(key, () => 0);
      result.states.update(key, (v) => v + value);
    });

    return result;
  }

  Stats.generate(this.date, this.states);

  factory Stats.fromJson(Map json) {
    final jsonStats = json["states"] as Map<String, dynamic>;
    final Map<MemorizationState, int> stats = {};

    jsonStats.forEach((key, val) {
      stats.putIfAbsent(MemorizationState.values[int.parse(key)], () => val);
    });
    return Stats(DateTime.parse(json["updated"]), stats);
  }

  Map toJson() {
    final jsonStats = {};

    states.forEach((key, value) {
      jsonStats.putIfAbsent(key.index.toString(), () => value);
    });

    return {
      "states": jsonStats,
      "updated": date.toIso8601String(),
    };
  }
}
