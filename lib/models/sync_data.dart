import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/models/progress.dart';
import 'package:flashcards/models/stats.dart';

class SyncData {
  final List<Flashcard> flashcards;
  final List<Progress> progress;
  final DateTime? special;
  final List<Stats> statistics;
  final DateTime? context;
  final DateTime? deleted;

  SyncData({
    required this.flashcards,
    required this.progress,
    required this.statistics,
    this.special,
    this.context,
    this.deleted,
  });

  bool get isEmpty {
    return flashcards.isEmpty && progress.isEmpty && statistics.isEmpty;
  }

  factory SyncData.fromJson(Map json) {
    return SyncData(
      flashcards: (json["cards"] as List<dynamic>)
          .map((j) => Flashcard.fromJson(j))
          .toList(),
      progress: (json["progress"] as List<dynamic>)
          .map((j) => Progress.fromJson(j))
          .toList(),
      statistics: (json["statistics"] as List<dynamic>)
          .map((j) => Stats.fromJson(j))
          .toList(),
    );
  }

  Map toJson() {
    return {
      "cards": flashcards.map((f) => f.toJson()).toList(),
      "progress": progress.map((f) => f.toJson()).toList(),
      "statistics": statistics.map((f) => f.toJson()).toList(),
    };
  }

  CachedSyncDates dates() {
    return CachedSyncDates(
      flashcards: flashcards.isEmpty
          ? null
          : flashcards.fold(DateTime(199), (p, element) {
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
