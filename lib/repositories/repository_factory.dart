import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flashcards/cubits/sync_cubit.dart';
import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:flashcards/models/cached_sync_ids.dart';
import 'package:flashcards/models/progress.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/models/stats.dart';
import 'package:flashcards/models/sync_data.dart';
import 'package:flashcards/repositories/remote_repository.dart';

import 'local_repository.dart';

class ReposityFactory {
  static late bool _isOnline;
  final RemoteRepository _remote;
  final LocalRepository _local;
  SyncCubit? _sync;
  static const forceOffline = false;

  ReposityFactory(this._remote, this._local);

  static Future<void> init() async {
    await Connectivity().checkConnectivity().then((value) {
      _isOnline = value != ConnectivityResult.none && !forceOffline;
    });

    // todo listener might work immediatly the first time
    // todo dispose the connection
    Connectivity().onConnectivityChanged.listen((value) {
      _isOnline = value != ConnectivityResult.none && !forceOffline;
    });
  }

  Future<List<Progress>> getProgress() async {
    return _local.getProgress();
  }

  Future<List<Stats>> getStats() async {
    return _local.getStats();
  }

  Future<List<Flashcard>> getFlashcardByIds(List<String> ids) async {
    return _local.getFlashcardsByIds(ids);
  }

  // todo i think its been called twice
  Future<void> submitScore(Score score) async {
    final statsId = await _local.submitScoreWithProgress(score);
    var cachedLocalIds = const CachedSyncIds();

    if (_isOnline) {
      await _remote.submitScore(score);
    } else {
      cachedLocalIds = CachedSyncIds(
        progress: score.flashcards.map((e) => e.id).toList(),
        statistics: [statsId.toString()],
      );
    }

    _sync?.save(
      CachedSyncDates(
        statistics: score.startTime,
        progress: score.startTime,
        localUpdatedIds: cachedLocalIds,
      ),
      merge: true,
    );
  }

  void hookSync(SyncCubit sync) {
    _sync = sync;
  }

  Future<SyncData> getLatestUpdates(CachedSyncDates dates) async {
    if (!_isOnline) {
      return SyncData(flashcards: [], progress: [], statistics: []);
    }

    return _remote.getLatestUpdates(dates);
  }

  Future<SyncData> getFromIds(CachedSyncIds ids) async {
    if (!_isOnline) {
      // todo should we return all the data anyway,
      // or return it only when there is connection
      // because when offline, this data is totaly useless
      return SyncData(flashcards: [], progress: [], statistics: []);
    }
    return SyncData(
      flashcards: ids.flashcards != null && ids.flashcards!.isNotEmpty
          ? await _local.getFlashcardsByIds(ids.flashcards!)
          : [],
      progress: ids.progress != null && ids.progress!.isNotEmpty
          ? await _local.getProgressByIds(ids.progress!)
          : [],
      statistics: ids.statistics != null && ids.statistics!.isNotEmpty
          ? await _local.getStatsByIds(
              // converting ids from string to number
              ids.statistics!.map((id) => int.parse(id)).toList(),
            )
          : [],
    );
  }

  Future<void> dispatchUpdatesToLocal(SyncData updates) {
    return _local.dispatchUpdates(updates);
  }

  Future<bool> dispatchUpdatesToServer(SyncData updates) async {
    if (_isOnline && !updates.isEmpty) {
      await _remote.dispatchUpdates(updates);
      return true;
    }
    return false;
  }

  dispose() {
    _local.dispose();
    // todo dispose the connectivity listener
  }
}
