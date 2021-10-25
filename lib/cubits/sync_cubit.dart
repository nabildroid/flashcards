import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/models/progress.dart';
import 'package:flashcards/models/stats.dart';
import 'package:flashcards/models/sync_data.dart';
import 'package:flashcards/repositories/repository_factory.dart';
import 'package:flashcards/services/cache_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SyncState {
  syncing,
  synced,
  init,
}

class _DistributedUpdates<T> {
  final T local;
  final T server;

  _DistributedUpdates({
    required this.local,
    required this.server,
  });
}

class SyncCubit extends Cubit<SyncState> {
  late final ReposityFactory _provider;
  late final CacheService _cache;

  SyncCubit(this._provider, this._cache) : super(SyncState.init) {
    _provider.hookSync(this);
    print("going to sync :)");
    sync();
  }

  void sync() async {
    // try {
    emit(SyncState.syncing);
    final dates = await _cache.get();
    final updatesFromServer = await _provider.getLatestUpdates(dates);
    final cachedUpdate = await _provider.getFromIds(dates.localUpdatedIds);

    final updates = combineUpdates(
      server: updatesFromServer,
      local: cachedUpdate,
    );

    await _provider.dispatchUpdatesToLocal(updates.server);
    final isSynced = await _provider.dispatchUpdatesToServer(updates.server);

    save(dates.merge(
      updatesFromServer.dates(),
      resetIds: isSynced,
    ));

    emit(SyncState.synced);
    // } catch (e) {
    //   print("Error");
    //   emit(SyncState.init);
    // }
  }

  save(CachedSyncDates dates, {bool merge = false}) async {
    if (merge) {
      final prev = await _cache.get();
      await _cache.save(prev.merge(dates));
    } else {
      await _cache.save(dates);
    }
  }

  _DistributedUpdates<SyncData> combineUpdates(
      {required SyncData server, required SyncData local}) {
    final flashcards =
        _mergeFlashcards(server: server.flashcards, local: local.flashcards);

    final progress =
        _mergeProgress(server: server.progress, local: local.progress);

    final stats =
        _mergeStats(server: server.statistics, local: local.statistics);

    return _DistributedUpdates(
      local: SyncData(
        flashcards: flashcards.local,
        progress: progress.local,
        statistics: stats.local,
      ),
      server: SyncData(
        flashcards: flashcards.server,
        progress: progress.server,
        statistics: stats.server,
      ),
    );
  }

  // todo i think its better to move those function into SyncData static function
  _DistributedUpdates<List<Flashcard>> _mergeFlashcards({
    required List<Flashcard> server,
    required List<Flashcard> local,
  }) {
    final s = server.map((e) => e.id).toSet();
    final l = local.map((e) => e.id).toSet();
    final common = s.intersection(l);

    final List<Flashcard> nServer = [];
    final List<Flashcard> nLocal = [];

    for (var id in common) {
      final a = server.firstWhere((e) => e.id == id);

      nLocal.add(a);
      s.removeWhere((e) => e == id);
      l.removeWhere((e) => e == id);
    }

    for (var id in s) {
      nLocal.add(server.firstWhere((e) => e.id == id));
    }
    for (var id in l) {
      nServer.add(local.firstWhere((e) => e.id == id));
    }

    // server first
    return _DistributedUpdates(
      local: nServer,
      server: nLocal,
    );
  }

  _DistributedUpdates<List<Progress>> _mergeProgress({
    required List<Progress> server,
    required List<Progress> local,
  }) {
    final s = server.map((e) => e.id).toSet();
    final l = local.map((e) => e.id).toSet();
    final common = s.intersection(l);

    final List<Progress> nServer = [];
    final List<Progress> nLocal = [];

    for (var id in common) {
      final a = server.firstWhere((e) => e.id == id);
      final b = local.firstWhere((e) => e.id == id);

      nServer.add(a.merge(b));
      nLocal.add(a.merge(b));
      s.removeWhere((e) => e == id);
      l.removeWhere((e) => e == id);
    }

    for (var id in s) {
      nLocal.add(server.firstWhere((e) => e.id == id));
    }
    for (var id in l) {
      nServer.add(local.firstWhere((e) => e.id == id));
    }

    return _DistributedUpdates(local: nLocal, server: nServer);
  }

  _DistributedUpdates<List<Stats>> _mergeStats({
    required List<Stats> server,
    required List<Stats> local,
  }) {
    // concat
    return _DistributedUpdates(local: server, server: local);
  }
}
