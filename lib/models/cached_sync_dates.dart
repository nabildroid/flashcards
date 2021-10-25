import 'cached_sync_ids.dart';

class CachedSyncDates {
  final DateTime? cards;
  final DateTime? progress;
  final DateTime? special;
  final DateTime? statistics;
  final DateTime? context;
  final DateTime? deleted;
  final CachedSyncIds localUpdatedIds;

  CachedSyncDates({
    this.cards,
    this.progress,
    this.special,
    this.statistics,
    this.context,
    this.deleted,
    this.localUpdatedIds = const CachedSyncIds(),
  });

  toJson() {
    return {
      "cards": cards?.toIso8601String(),
      "progress": progress?.toIso8601String(),
      "special": special?.toIso8601String(),
      "statistics": statistics?.toIso8601String(),
      "deleted": deleted?.toIso8601String(),
      "context": context?.toIso8601String(),
      // "localUpdatedIds": localUpdatedIds.toJson(),
    };
  }

  toFullJson() {
    // todo refactor this
    return {
      "cards": cards?.toIso8601String(),
      "progress": progress?.toIso8601String(),
      "special": special?.toIso8601String(),
      "statistics": statistics?.toIso8601String(),
      "deleted": deleted?.toIso8601String(),
      "context": context?.toIso8601String(),
      "localUpdatedIds": localUpdatedIds.toJson(),
    };
  }

  CachedSyncDates merge(CachedSyncDates newCach) {
    return CachedSyncDates(
      cards: newCach.cards ?? cards,
      context: newCach.context ?? context,
      progress: newCach.progress ?? progress,
      deleted: newCach.deleted ?? deleted,
      statistics: newCach.statistics ?? statistics,
      special: newCach.special ?? special,
      localUpdatedIds: localUpdatedIds.merge(newCach.localUpdatedIds),
    );
  }

  factory CachedSyncDates.fromJson(Map json) {
    return CachedSyncDates(
      cards: json["cards"] != null ? DateTime.parse(json["cards"]) : null,
      deleted: json["deleted"] != null ? DateTime.parse(json["deleted"]) : null,
      context: json["context"] != null ? DateTime.parse(json["context"]) : null,
      progress:
          json["progress"] != null ? DateTime.parse(json["progress"]) : null,
      special: json["special"] != null ? DateTime.parse(json["special"]) : null,
      statistics: json["statistics"] != null
          ? DateTime.parse(json["statistics"])
          : null,
      localUpdatedIds: json["localUpdatedIds"] != null
          ? CachedSyncIds.fromJson(json["localUpdatedIds"])
          : const CachedSyncIds(),
    );
  }
}
