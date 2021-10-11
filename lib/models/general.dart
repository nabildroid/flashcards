enum MemorizationState {
  good,
  forget,
  easy,
}

class Set {
  final String id;
  final String title;
  final String description;

  Set({
    required this.id,
    required this.title,
    required this.description,
  });
}

class Cart {
  final String id;
  final String term;
  final String definition;
  final List<String> tags;
  final List<Memorization> history;

  Cart({
    required this.id,
    required this.term,
    required this.definition,
    required this.tags,
    required this.history,
  });
}

class Stats {
  final List<DateTime> days;
  final List<double> memorizations;

  Stats({
    required this.days,
    required this.memorizations,
  });
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

  CardMemorization({
    required this.id,
    required MemorizationState state,
    required DateTime time,
  }) : super(state: state, time: time);
}

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
