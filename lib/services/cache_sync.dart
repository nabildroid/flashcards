import 'dart:convert';

import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheSync {
  static const key = "cached_sync_dates";

  late final SharedPreferences _instance;

  CacheSync() {
    SharedPreferences.getInstance().then((db) => _instance = db);
  }

  save(CachedSyncDates dates) async {
    final toStore = get().merge(dates).toJson();

    // todo merge the new one with the old one
    await _instance.setString(key, jsonEncode(toStore));
  }

  CachedSyncDates get() {
    final stored = _instance.getString(key) ?? "{}";
    return CachedSyncDates.fromJson(jsonDecode(stored));
  }
}
