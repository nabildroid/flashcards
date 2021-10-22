import 'package:flashcards/entities.dart/stats.dart';
import 'package:flashcards/models/progress.dart';
import 'package:flashcards/models/stats.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/cart.dart';
import 'package:flashcards/repositories/provider.dart';
import 'package:flashcards/services/database.dart';

class LocalRepository extends Provider {
  final Database _db;
  // final Database _db;
  LocalRepository(this._db);

  @override
  Future<List<StatsEntity>> getStats() async {
    return _db.getStats();
  }

  @override
  Future<void> submitScore(Score score) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateSpecialCard(String id, bool boosted) {
    // TODO: implement updateSpecialCard
    throw UnimplementedError();
  }

  @override
  Future<List<Cart>> getCardsByIds(List<String> ids) {
    _db.getCardsByIds(ids);
    throw UnimplementedError();
  }

  @override
  Future<List<Progress>> getProgress() {
    _db.getProgress();
    throw UnimplementedError();
  }

  @override
  dispose() {
    _db.dispose();
  }
}
