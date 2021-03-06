import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/models/memorization.dart';
import 'package:flashcards/models/progress.dart';
import 'package:flashcards/models/stats.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _Tables {
  final Box<Flashcard> flashcard;
  final Box<Progress> progress;
  final Box<Stats> stats;

  _Tables({
    required this.flashcard,
    required this.progress,
    required this.stats,
  });
}

class Database {
  static late _Tables _tables;
  Database();

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(FlashcardAdapter());
    Hive.registerAdapter(ProgressAdapter());
    Hive.registerAdapter(StatsAdapter());
    Hive.registerAdapter(MemorizationStateAdapter());

    _tables = _Tables(
      flashcard: await Hive.openBox("cards"),
      progress: await Hive.openBox("progress"),
      stats: await Hive.openBox("stats"),
    );
  }

  static Future<void> resetDatabase() async {
    await Hive.deleteBoxFromDisk("cards");
    await Hive.deleteBoxFromDisk("progress");
    await Hive.deleteBoxFromDisk("stats");
  }

  // progress
  List<Progress> getProgress([List<String> keys = const []]) {
    if (keys.isEmpty) {
      return _tables.progress.values.toList();
    } else {
      final items = keys.map((key) => _tables.progress.get(key)).toList();
      items.removeWhere((element) => element == null);
      return items.map((e) => e!).toList();
    }
  }

  Future<void> deleteProgress(String key) {
    return _tables.progress.delete(key);
  }

  Future<void> setProgress(String key, Progress progress) {
    return addProgress(key, progress);
  }

  Future<void> addProgress(String key, Progress progress) {
    return _tables.progress.put(key, progress);
  }

  // stats
  setStats() {
    UnimplementedError("you can't update a stats !");
  }

  Future<int> addStats(Stats stats) {
    return _tables.stats.add(stats);
  }

  List<Stats> getStats([List<int> keys = const []]) {
    if (keys.isEmpty) {
      return _tables.stats.values.toList();
    } else {
      final items = keys.map((key) => _tables.stats.getAt(key)).toList();
      items.removeWhere((element) => element == null);
      return items.map((e) => e!).toList();
    }
  }

  deleteStats(String key) {
    _tables.stats.delete(key);
  }

  // card
  List<Flashcard> getFlashcards([List<String> keys = const []]) {
    if (keys.isEmpty) {
      return _tables.flashcard.values.toList();
    } else {
      final items = keys.map((key) => _tables.flashcard.get(key)).toList();
      items.removeWhere((element) => element == null);
      return items.map((e) => e!).toList();
    }
  }

  Future<void> deleteCard(String key) {
    return _tables.flashcard.delete(key);
  }

  Future<void> setCard(String key, Flashcard flashcard) {
    return addCard(key, flashcard);
  }

  Future<void> addCard(String key, Flashcard flashcard) {
    return _tables.flashcard.put(key, flashcard);
  }

  Future<void> dispose() {
    return Hive.close();
  }
}
