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
  static late bool _isOnline;
  final RemoteRepository _remote;
  final LocalRepository _local;
  SyncCubit? _sync;

  ReposityFactory(this._remote, this._local);

  static Future<void> init() async {
    await Connectivity().checkConnectivity().then((value) {
      _isOnline = value != ConnectivityResult.none;
    });

    // todo listener might work immediatly the first time
    // todo dispose the connection
    Connectivity().onConnectivityChanged.listen((value) {
      _isOnline = value != ConnectivityResult.none;
    });
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
