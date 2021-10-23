import 'package:flashcards/entities.dart/progress.dart';
import 'package:flashcards/entities.dart/stats.dart';
import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/memorization.dart';
import 'package:flashcards/models/progress.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _Tables {
  final Box<Cart> cards;
  final Box<Progress> progress;
  final Box<StatsEntity> stats;

  _Tables({
    required this.cards,
    required this.progress,
    required this.stats,
  });
}

class Database {
  static late _Tables _tables;
  Database();

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(CartAdapter());
    Hive.registerAdapter(ProgressAdapter());
    Hive.registerAdapter(StatsEntityAdapter());
    Hive.registerAdapter(MemorizationStateAdapter());

    _tables = _Tables(
      cards: await Hive.openBox("cards"),
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
      final items = keys.map((key) => _tables.progress.get(key));
      return items.where((element) => element != null) as List<Progress>;
    }
  }

  deleteProgress(String key) {
    _tables.progress.delete(key);
  }

  setProgress(String key, Progress progress) {
    addProgress(key, progress);
  }

  addProgress(String key, Progress progress) {
    _tables.progress.put(key, progress);
  }

  // stats
  setStats() {
    UnimplementedError("you can't update a stats !");
  }

  addStats(StatsEntity stats) {
    _tables.stats.add(stats);
  }

  List<StatsEntity> getStats([List<String> keys = const []]) {
    if (keys.isEmpty) {
      return _tables.stats.values.toList();
    } else {
      final items = keys.map((key) => _tables.stats.get(key));
      return items.where((element) => element != null) as List<StatsEntity>;
    }
  }

  deleteStats(String key) {
    _tables.stats.delete(key);
  }

  // card
  List<Cart> getCards([List<String> keys = const []]) {
    if (keys.isEmpty) {
      return _tables.cards.values.toList();
    } else {
      final items = keys.map((key) => _tables.cards.get(key)).toList();
      items.removeWhere((element) => element == null);
      return items.map((e) => e!).toList();
    }
  }

  deleteCard(String key) {
    _tables.stats.delete(key);
  }

  setCard(String key, Cart cart) {
    return addCard(key, cart);
  }

  addCard(String key, Cart cart) {
    _tables.cards.put(key, cart);
  }

  dispose() {
    Hive.close();
  }
}
