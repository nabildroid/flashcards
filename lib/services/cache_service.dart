import 'dart:convert';

import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const key = "cached_sync_dates";

  static late SharedPreferences _instance;

  CacheService();

  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  save(CachedSyncDates dates) async {
    final toStore = (await get()).merge(dates).toFullJson();
    await _instance.setString(key, jsonEncode(toStore));
  }

  Future<CachedSyncDates> get() async {
    final stored = _instance.getString(key) ?? "{}";
    return CachedSyncDates.fromJson(jsonDecode(stored));
  }
}
