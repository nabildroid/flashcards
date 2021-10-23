import 'package:flashcards/models/memorization.dart';
import 'package:hive/hive.dart';

part 'stats.g.dart';

@HiveType(typeId: 4)
class StatsEntity {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final Map<MemorizationState, int> states;

  StatsEntity(this.date, this.states);

  StatsEntity mergeWith(StatsEntity merge) {
    final result = StatsEntity(merge.date, {});

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
}
