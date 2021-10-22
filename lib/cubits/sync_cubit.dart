import 'package:flashcards/repositories/repository_factory.dart';
import 'package:flashcards/services/cache_sync.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SyncState {
  syncing,
  synced,
  init,
}

class SyncCubit extends Cubit<SyncState> {
  late final ReposityFactory _provider;
  late final CacheSync _cache;

  SyncCubit(this._provider, this._cache) : super(SyncState.init) {
    sync();

    _provider.hookSync(this);
  }

  void sync() async {
    try {
      emit(SyncState.syncing);
      await Future.delayed(Duration(seconds: 2));
      final dates = _cache.get();
      print(dates);
      await _provider.getLatestUpdates(dates);
      emit(SyncState.synced);
    } catch (e) {
      emit(SyncState.init);
    }
  }
}
