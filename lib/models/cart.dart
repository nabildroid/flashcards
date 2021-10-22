class Cart {
  final String id;
  final String term;
  final String definition;
  final List<String> tags;

  Cart({
    required this.id,
    required this.term,
    required this.definition,
    required this.tags,
  });

  factory Cart.fromJson(Map json) {
    return Cart(
      id: json["id"],
      definition: json["definition"],
      tags: json["tags"].cast<String>(),
      term: json["term"],
    );
  }
}
