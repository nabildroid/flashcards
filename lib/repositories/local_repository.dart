import 'package:flashcards/models/stats.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/cart.dart';
import 'package:flashcards/repositories/provider.dart';

class LocalRepository extends Provider {
  static const dbName = "flashcards.db";

  // final Database _db;
  LocalRepository();

  @override
  Future<List<Cart>> getCards() {
    // TODO: implement getCards
    throw UnimplementedError();
  }

  @override
  Future<List<Stats>> getStats() {
    // TODO: implement getStats
    throw UnimplementedError();
  }

  @override
  Future<void> submitScore(Score score) {
    // TODO: implement submitScore
    throw UnimplementedError();
  }

  @override
  Future<void> updateSpecialCard(String id, bool boosted) {
    // TODO: implement updateSpecialCard
    throw UnimplementedError();
  }
}
