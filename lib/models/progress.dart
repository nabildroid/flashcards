import 'package:flashcards/entities.dart/progress.dart';
import 'package:hive/hive.dart';

part 'progress.g.dart';

@HiveType(typeId: 3)
class Progress extends ProgressEntity {
  @HiveField(0)
  final String id;
  @HiveField(4)
  final DateTime updated;

  @override
  @HiveField(1)
  final int interval;
  @override
  @HiveField(2)
  final double ease;
  @override
  @HiveField(3)
  final int repetitions;

  Progress(
    this.id, {
    required this.updated,
    required this.ease,
    required this.interval,
    required this.repetitions,
  }) : super(ease: ease, interval: interval, repetitions: repetitions);

  factory Progress.fromJson(Map json) {
    return Progress(
      json["flashcardId"],
      updated: DateTime.parse(json["updated"]),
      ease: double.parse(json["ease"].toString()),
      interval: json["interval"],
      repetitions: json["repetitions"],
    );
  }
}
