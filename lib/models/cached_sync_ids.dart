import 'package:flashcards/core/utils.dart';

class CachedSyncIds {
  final List<String>? cards;
  final List<String>? progress;
  final List<String>? special;
  final List<String>? statistics;
  final List<String>? context;

  const CachedSyncIds({
    this.cards,
    this.progress,
    this.special,
    this.statistics,
    this.context,
  });

  factory CachedSyncIds.fromJson(Map json) {
    return CachedSyncIds(
      cards: json["cards"].cast<String>(),
      progress: json["progress"].cast<String>(),
      special: json["special"].cast<String>(),
      statistics: json["statistics"].cast<String>(),
      context: json["context"].cast<String>(),
    );
  }

  merge(CachedSyncIds merge) {
    return CachedSyncIds(
      cards: mergeUniquely(cards ?? [], merge.cards ?? []),
      progress: mergeUniquely(progress ?? [], merge.progress ?? []),
      special: mergeUniquely(special ?? [], merge.special ?? []),
      statistics: mergeUniquely(statistics ?? [], merge.statistics ?? []),
      context: mergeUniquely(context ?? [], merge.context ?? []),
    );
  }

  toJson() {
    return {
      "cards": cards,
      "progress": progress,
      "special": special,
      "statistics": statistics,
      "context": context,
    };
  }

  bool get isEmpty {
    return [
      ...cards ?? [],
      ...progress ?? [],
      ...special ?? [],
      ...statistics ?? [],
      ...context ?? [],
    ].isEmpty;
  }
}
