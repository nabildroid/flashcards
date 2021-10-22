import 'package:flashcards/entities.dart/progress.dart';

class Progress extends ProgressEntity {
  final String id;
  Progress(
    this.id, {
    required double ease,
    required int interval,
    required int repetitions,
  }) : super(ease: ease, interval: interval, repetitions: repetitions);

  factory Progress.fromJson(Map json) {
    return Progress(
      json["flashcardId"],
      ease: double.parse(json["ease"].toString()),
      interval: json["interval"],
      repetitions: json["repetitions"],
    );
  }
}
