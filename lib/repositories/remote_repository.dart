import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/stats.dart';

import 'provider.dart';

class RemoteRepository extends Provider {
  @override
  Future<List<Cart>> getCards(String setId) async {
    await Future.delayed(Duration(seconds: 2));
    return Future.value([
      Cart(
        id: "dsfsdf",
        term: "Card 1",
        definition: "efesfef",
        tags: [],
        history: [],
      ),
      Cart(
        id: "efefe",
        term: "Card 2",
        definition: "efefzeresfef",
        tags: [],
        history: [],
      ),
      Cart(
        id: "dsfs98e",
        term: "Card 3",
        definition: "efesfeffzefze",
        tags: [],
        history: [],
      ),
    ]);
  }

  @override
  Future<Stats> getStats() {
    return Future.value(Stats(days: [], memorizations: []));
  }

  @override
  Future<void> submitScore(Score score) async {
    await Future.delayed(Duration(seconds: 5));
  }
}
