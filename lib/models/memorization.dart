import 'package:flashcards/entities.dart/progress.dart';

enum MemorizationState {
  good,
  forget,
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
