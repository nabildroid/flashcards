import 'package:flashcards/models/memorization.dart';

class StatsEntity {
  final DateTime date;
  final Map<MemorizationState, int> states;

  StatsEntity(this.date, this.states);
}
