class ProgressEntity {
  final int interval;
  final double ease;
  final int repetitions;

  ProgressEntity({
    required this.interval,
    required this.ease,
    required this.repetitions,
  });

  ProgressEntity.init()
      : ease = 1.3,
        interval = 1,
        repetitions = 0;
}
