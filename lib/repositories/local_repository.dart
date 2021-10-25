import 'package:flashcards/models/progress.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/stats.dart';
import 'package:flashcards/models/sync_data.dart';
import 'package:flashcards/services/database.dart';

class LocalRepository {
  final Database _db;
  LocalRepository(this._db);

  Future<List<Stats>> getStatsByIds(List<int> ids) async {
    return _db.getStats(ids);
  }

  Future<List<Stats>> getStats() async {
    return _db.getStats();
  }

  Future<int> submitScoreWithProgress(Score score) async {
    for (var cart in score.cards) {
      await _db.addProgress(
        cart.id,
        Progress(
          cart.id,
          updated: score.startTime, // the same as the serve
          ease: cart.progress.ease,
          interval: cart.progress.interval,
          repetitions: cart.progress.repetitions,
        ),
      );
    }

    final stats = score.stats();
    return _db.addStats(stats);
  }

  Future<List<Cart>> getCardsByIds(List<String> ids) async {
    return _db.getCards(ids);
  }

  Future<List<Progress>> getProgress() async {
    return _db.getProgress();
  }

  Future<List<Progress>> getProgressByIds(List<String> ids) async {
    return _db.getProgress(ids);
  }

  Future<void> dispatchUpdates(SyncData updates) async {
    for (var cart in updates.cards) {
      await _db.addCard(cart.id, cart);
    }

    for (var progress in updates.progress) {
      await _db.addProgress(progress.id, progress);
    }

    for (var stats in updates.statistics) {
      await _db.addStats(stats);
    }
  }

  dispose() {
    _db.dispose();
  }
}
