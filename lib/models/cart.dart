import 'package:hive/hive.dart';

part 'cart.g.dart';

@HiveType(typeId: 1)
class Cart {
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

  Cart({
    required this.id,
    required this.updated,
    required this.term,
    required this.definition,
    required this.tags,
  });

  factory Cart.fromJson(Map json) {
    return Cart(
      id: json["id"],
      updated: DateTime.parse(json["updated"]),
      definition: json["definition"],
      tags: json["tags"].cast<String>(),
      term: json["term"],
    );
  }
}
