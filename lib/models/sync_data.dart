import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/progress.dart';
import 'package:flashcards/models/stats.dart';

class SyncData {
  final List<Cart> cards;
  final List<Progress> progress;
  final DateTime? special;
  final List<Stats> statistics;
  final DateTime? context;
  final DateTime? deleted;

  SyncData({
    required this.cards,
    required this.progress,
    required this.statistics,
    this.special,
    this.context,
    this.deleted,
  });

  factory SyncData.fromJson(Map json) {
    return SyncData(
      cards: (json["cards"] as List<dynamic>)
          .map((j) => Cart.fromJson(j))
          .toList(),
      progress: (json["progress"] as List<dynamic>)
          .map((j) => Progress.fromJson(j))
          .toList(),
      statistics: (json["statistics"] as List<dynamic>)
          .map((j) => Stats.fromJson(j))
          .toList(),
    );
  }

  CachedSyncDates dates() {
    return CachedSyncDates(
      cards: cards.isEmpty
          ? null
          : cards.fold(DateTime(199), (p, element) {
              return p!.compareTo(element.updated) > 0 ? p : element.updated;
            }),
      progress: progress.isEmpty
          ? null
          : progress.fold(DateTime(199), (p, element) {
              return p!.compareTo(element.updated) > 0 ? p : element.updated;
            }),
      statistics: statistics.isEmpty
          ? null
          : statistics.fold(DateTime(199), (p, element) {
              return p!.compareTo(element.date) > 0 ? p : element.date;
            }),
    );
  }
}
