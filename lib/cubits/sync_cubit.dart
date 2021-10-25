import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:flashcards/repositories/repository_factory.dart';
import 'package:flashcards/services/cache_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SyncState {
  syncing,
  synced,
  init,
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
    try {
      emit(SyncState.syncing);
      final dates = await _cache.get();
      final updates = await _provider.getLatestUpdates(dates);
      await _provider.dispatchUpdatesToLocal(updates);
      save(updates.dates());
      emit(SyncState.synced);
    } catch (e) {
      print("Error");
      emit(SyncState.init);
    }
  }

  save(CachedSyncDates dates) async {
    await _cache.save(dates);
  }
}
