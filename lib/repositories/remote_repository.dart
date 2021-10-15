import 'package:flashcards/core/scheduler.dart';
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
        progress: SchedulerProgress.init(),
      ),
      Cart(
        id: "efefe",
        term: "Card 2",
        definition: "efefzeresfef",
        tags: [],
        progress: SchedulerProgress.init(),
      ),
      Cart(
        id: "dsfs98e",
        term: "Card 3",
        definition: "efesfeffzefze",
        tags: [],
        progress: SchedulerProgress.init(),
      ),
    ]);
  }

  @override
  Future<Stats> getStats() async {
    print("getting stats");
    return Future.value(Stats(days: [
      DateTime.now().subtract(Duration(days: 1)),
      DateTime.now().subtract(Duration(days: 2)),
      DateTime.now().subtract(Duration(days: 6)),
      DateTime.now().subtract(Duration(days: 5)),
      DateTime.now().subtract(Duration(days: 6)),
      DateTime.now().subtract(Duration(days: 10)),
      DateTime.now().subtract(Duration(days: 11)),
    ], memorizations: []));
  }

  @override
  Future<void> submitScore(Score score) async {
    await Future.delayed(Duration(seconds: 5));
  }
}
