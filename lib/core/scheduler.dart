import 'package:flashcards/models/general.dart';

class Scheduler {
  List<Cart> cards = [];

  Scheduler();

  void init(List<Cart> cards) {
    this.cards = cards;
  }

  Future<List<Cart>> selected() async {
    await Future.delayed(Duration(milliseconds: 3));

    return this.cards;
  }
}
