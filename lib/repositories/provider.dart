import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/progress.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/stats.dart';
import 'package:flashcards/models/sync_data.dart';

abstract class Provider {
  Future<List<Progress>> getProgress() async => [];
  Future<List<Cart>> getCardsByIds(List<String> ids) async => [];

  Future<List<Stats>> getStats() async => [];

  Future<void> submitScore(Score score);

  Future<void> updateSpecialCard(String id, bool boosted);

  Future<SyncData> getLatestUpdates(CachedSyncDates dates) {
    return Future.value(
      SyncData(cards: [], progress: [], statistics: []),
    );
  }

  dispose() {}
}
