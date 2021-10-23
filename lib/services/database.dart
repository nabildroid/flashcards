import 'package:flashcards/entities.dart/stats.dart';
import 'package:flashcards/models/cart.dart';
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
    _tables = _Tables(
      cards: await Hive.openBox("cards"),
      progress: await Hive.openBox("progress"),
      stats: await Hive.openBox("stats"),
    );
  }
  // todo add CRUD for each table. because this is a general database service

  // progress
  List<Progress> getProgress([List<String> keys = const []]) {
    return _tables.progress.values.toList();
  }

  deleteProgress() {}
  setProgress(Progress progress) {}

  addProgress() {}

  // stats
  setStats() {}
  addStats(StatsEntity stats) {
    _tables.stats.add(stats);
  }

  List<StatsEntity> getStats([List<String> keys = const []]) {
    return _tables.stats.values.toList();
  }

  deleteStats() {}

  // card
  getCards(List<String> keys) {}
  deleteCard() {}
  setCard() {}
  addCard() {}
  List<Cart> getCardsByIds(List<String> ids) {
    final carts = ids.map((id) => _tables.cards.get(id));
    return carts.where((element) => element != null) as List<Cart>;
  }

  dispose() {
    Hive.close();
  }
}
