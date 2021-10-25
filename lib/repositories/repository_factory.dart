import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flashcards/cubits/sync_cubit.dart';
import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:flashcards/models/cached_sync_ids.dart';
import 'package:flashcards/models/progress.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/stats.dart';
import 'package:flashcards/models/sync_data.dart';
import 'package:flashcards/repositories/remote_repository.dart';

import 'local_repository.dart';

class ReposityFactory {
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

  Future<List<Progress>> getProgress() async {
    return _local.getProgress();
  }

  Future<List<Stats>> getStats() async {
    return _local.getStats();
  }

  Future<List<Cart>> getCardsByIds(List<String> ids) async {
    return _local.getCardsByIds(ids);
  }

  Future<void> submitScore(Score score) async {
    final statsId = await _local.submitScoreWithProgress(score);
    var cachedLocalIds = const CachedSyncIds();

    if (_isOnline) {
      await _remote.submitScore(score);
    } else {
      cachedLocalIds = CachedSyncIds(
        progress: score.cards.map((e) => e.id).toList(),
        statistics: [statsId.toString()],
      );
    }

    _sync?.save(CachedSyncDates(
      statistics: score.startTime,
      progress: score.startTime,
      localUpdatedIds: cachedLocalIds,
    ));
  }

  void hookSync(SyncCubit sync) {
    _sync = sync;
  }

  Future<SyncData> getLatestUpdates(CachedSyncDates dates) async {
    if (!_isOnline) return SyncData(cards: [], progress: [], statistics: []);

    return _remote.getLatestUpdates(dates);
  }

  Future<void> dispatchUpdatesToLocal(SyncData updates) {
    return _local.dispatchUpdates(updates);
  }

  dispose() {
    _local.dispose();
    // todo dispose the connectivity listener
  }
}
