import 'package:flashcards/entities/progress.dart';
import 'package:hive/hive.dart';

part 'memorization.g.dart';

@HiveType(typeId: 2)
enum MemorizationState {
  @HiveField(0)
  good,
  @HiveField(1)
  forget,
  @HiveField(2)
  easy,
}

class Memorization {
  final MemorizationState state;
  final DateTime time;

  Memorization({
    required this.state,
    required this.time,
  });
}

class CardMemorization extends Memorization {
  final String id;
  final ProgressEntity progress;
  CardMemorization({
    required this.id,
    required this.progress,
    required MemorizationState state,
    required DateTime time,
  }) : super(state: state, time: time);
}
