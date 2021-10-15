import 'package:flashcards/core/scheduler.dart';

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

  factory Cart.fromJson(Map json) {
    return Cart(
      id: json["id"],
      definition: json["definition"],
      progress: SchedulerProgress(
        ease: json["progress"]["ease"],
        interval: json["progress"]["interval"],
        repetitions: json["progress"]["repetitions"],
      ),
      tags: json["tags"].cast<String>(),
      term: json["term"],
    );
  }
}
