import 'dart:convert';

import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheSync {
  static const key = "cached_sync_dates";

  static late SharedPreferences _instance;

  CacheSync();

  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  save(CachedSyncDates dates) async {
    final toStore = (await get()).merge(dates).toJson();

    // todo merge the new one with the old one
    await (await _instance).setString(key, jsonEncode(toStore));
  }

  Future<CachedSyncDates> get() async {
    final stored = (await _instance).getString(key) ?? "{}";
    return CachedSyncDates.fromJson(jsonDecode(stored));
  }
}
