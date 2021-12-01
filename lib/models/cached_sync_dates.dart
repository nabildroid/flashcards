import 'cached_sync_ids.dart';

class CachedSyncDates {
  final DateTime? flashcards;
  final DateTime? progress;
  final DateTime? special;
  final DateTime? statistics;
  final DateTime? context;
  final DateTime? deleted;
  final CachedSyncIds localUpdatedIds;

  CachedSyncDates({
    this.flashcards,
    this.progress,
    this.special,
    this.statistics,
    this.context,
    this.deleted,
    this.localUpdatedIds = const CachedSyncIds(),
  });

  Map<String, dynamic> getDatesAsJson() {
    return {
      "cards": flashcards?.toIso8601String(),
      "progress": progress?.toIso8601String(),
      "special": special?.toIso8601String(),
      "statistics": statistics?.toIso8601String(),
      "deleted": deleted?.toIso8601String(),
      "context": context?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() {
    final json = getDatesAsJson();
    json.putIfAbsent(
      "localUpdatedIds",
      () => localUpdatedIds.toJson(),
    );

    return json;
  }

  CachedSyncDates merge(CachedSyncDates newCach, {bool resetIds = false}) {
    return CachedSyncDates(
      flashcards: newCach.flashcards ?? flashcards,
      context: newCach.context ?? context,
      progress: newCach.progress ?? progress,
      deleted: newCach.deleted ?? deleted,
      statistics: newCach.statistics ?? statistics,
      special: newCach.special ?? special,
      localUpdatedIds: resetIds
          ? const CachedSyncIds()
          : localUpdatedIds.merge(newCach.localUpdatedIds),
    );
  }

  factory CachedSyncDates.fromJson(Map json) {
    return CachedSyncDates(
      flashcards: json["cards"] != null ? DateTime.parse(json["cards"]) : null,
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
