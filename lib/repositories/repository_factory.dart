import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flashcards/cubits/sync_cubit.dart';
import 'package:flashcards/entities.dart/stats.dart';
import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:flashcards/models/progress.dart';
import 'package:flashcards/models/stats.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/sync_data.dart';
import 'package:flashcards/repositories/remote_repository.dart';
import 'package:flashcards/services/cache_sync.dart';

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
  Future<List<Progress>> getProgress() async {
    return _local.getProgress();
  }

  @override
  Future<List<StatsEntity>> getStats() async {
    return _local.getStats();
  }

  @override
  Future<List<Cart>> getCardsByIds(List<String> ids) async {
    return _local.getCardsByIds(ids);
  }

  @override
  Future<void> submitScore(Score score) async {
    _local.submitScore(score);

    if (_isOnline) {
      _remote.submitScore(score);
    }

    _sync?.save(CachedSyncDates(statistics: score.startTime));
  }

  void hookSync(SyncCubit sync) {
    _sync = sync;
  }

  Future<SyncData> getLatestUpdates(CachedSyncDates dates) async {
    if (!_isOnline) return SyncData(cards: [], progress: [], statistics: []);

    return _remote.getLatestUpdates(dates);
  }

  Future<void> dispatchUpdates(SyncData updates) {
    return _local.dispatchUpdates(updates);
  }

  @override
  dispose() {
    _local.dispose();
  }
}
