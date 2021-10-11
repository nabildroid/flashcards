import 'memorization.dart';

class Cart {
  final String id;
  final String term;
  final String definition;
  final List<String> tags;
  final List<Memorization> history;

  Cart({
    required this.id,
    required this.term,
    required this.definition,
    required this.tags,
    required this.history,
  });
}
