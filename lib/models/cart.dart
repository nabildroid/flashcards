import 'package:flashcards/core/scheduler.dart';

import 'memorization.dart';

class Cart {
  final String id;
  final String term;
  final String definition;
  final List<String> tags;
  final SchedulerProgress progress;

  Cart({
    required this.id,
    required this.term,
    required this.definition,
    required this.tags,
    required this.progress,
  });
}
