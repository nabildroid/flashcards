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
  late _Tables _tables;
  Database() {
    _init();
  }

  _init() async {
    await Hive.initFlutter();
    _tables = _Tables(
      cards: await Hive.openBox("cards"),
      progress: await Hive.openBox("progress"),
      stats: await Hive.openBox("stats"),
    );
  }

  // todo add CRUD for each table. because this is a general database service

  List<Progress> getProgress() {
    return _tables.progress.values.toList();
  }

  setProgress(Progress progress) {}

  addStats(StatsEntity stats) {
    _tables.stats.add(stats);
  }

  List<StatsEntity> getStats() {
    return _tables.stats.values.toList();
  }

  List<Cart> getCardsByIds(List<String> ids) {
    final carts = ids.map((id) => _tables.cards.get(id));
    return carts.where((element) => element != null) as List<Cart>;
  }

  dispose() {
    Hive.close();
  }
}
