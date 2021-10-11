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
}
