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

  CardMemorization({
    required this.id,
    required MemorizationState state,
    required DateTime time,
  }) : super(state: state, time: time);
}
