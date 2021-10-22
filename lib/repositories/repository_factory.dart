import 'package:flashcards/cubits/sync_cubit.dart';
import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:flashcards/repositories/remote_repository.dart';

import 'provider.dart';

class ReposityFactory extends Provider {
  SyncCubit? _sync;
  @override
  Future<List<Cart>> getCards() async {
    throw UnimplementedError();
  }

  @override
  Future<List<Stats>> getStats() async {
    await isOnline;

    // TODO: implement getStats
    throw UnimplementedError();
  }

  @override
  Future<void> submitScore(Score score) async {
    // TODO: implement submitScore
    throw UnimplementedError();
  }

  @override
  Future<dynamic> getLatestUpdates(CachedSyncDates dates) async {
  }

  @override
  Future<void> updateSpecialCard(String id, bool boosted) async {
  }

  void hookSync(SyncCubit sync) {
    _sync = sync;
  }
}
