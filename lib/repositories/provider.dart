import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/stats.dart';

abstract class Provider {
  Future<List<Cart>> getCards();

  Future<List<Stats>> getStats();

  Future<void> submitScore(Score score);

  Future<void> updateSpecialCard(String id, bool boosted);

  Future<dynamic> getLatestUpdates(CachedSyncDates dates) {
    return Future.value([]);
  }


  dispose() {}
}
