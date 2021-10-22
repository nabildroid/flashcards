import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flashcards/cubits/sync_cubit.dart';
import 'package:flashcards/entities.dart/stats.dart';
import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:flashcards/models/stats.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/sync_data.dart';
import 'package:flashcards/repositories/remote_repository.dart';

import 'local_repository.dart';
import 'provider.dart';

class ReposityFactory extends Provider {
  late Future<bool> isOnline;
  final RemoteRepository _remote;
  final LocalRepository _local;
  SyncCubit? _sync;

  ReposityFactory(this._remote, this._local) {
    isOnline = Connectivity().checkConnectivity().then((value) {
      return value != ConnectivityResult.none;
    });

    // todo add connectivity listener;
  }

  @override
  Future<List<Cart>> getCards() async {
    await isOnline;
    // TODO: implement getCards
    throw UnimplementedError();
  }

  @override
  Future<List<StatsEntity>> getStats() async {
    return _local.getStats();
  }

  @override
  Future<void> submitScore(Score score) async {
    await isOnline;
  }

  @override
  Future<SyncData> getLatestUpdates(CachedSyncDates dates) async {
    return _remote.getLatestUpdates(dates);
  }

  @override
  Future<void> updateSpecialCard(String id, bool boosted) async {
    print(await isOnline);
  }

  void hookSync(SyncCubit sync) {
    _sync = sync;
  }

  @override
  dispose() {
    _local.dispose();
  }
}
