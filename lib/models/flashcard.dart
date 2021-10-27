import 'package:hive/hive.dart';

part 'flashcard.g.dart';

@HiveType(typeId: 1)
class Flashcard {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String term;

  @HiveField(2)
  final String definition;

  @HiveField(3)
  final List<String> tags;

  @HiveField(4)
  final DateTime updated;

  Flashcard({
    required this.id,
    required this.updated,
    required this.term,
    required this.definition,
    required this.tags,
  });

  factory Flashcard.fromJson(Map json) {
    return Flashcard(
      id: json["id"],
      updated: DateTime.parse(json["updated"]),
      definition: json["definition"],
      tags: json["tags"].cast<String>(),
      term: json["term"],
    );
  }

  Map toJson() {
    return {
      "id": id,
      "updated": updated.toIso8601String(),
      "definition": definition,
      "tags": tags,
      "term": term,
    };
  }
}
