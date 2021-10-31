import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flashcards/core/utils.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/stats.dart';
import 'package:flashcards/repositories/repository_factory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChainDay {
  final String day;
  final bool completed;

  ChainDay(this.day, this.completed);
}

class StatisticsState extends Equatable {
  final int longestChain;
  final int currentChain;
  final List<ChainDay> last7DaysStreak;
  final List<Stats> daysStats;
  final List<Stats> allStats;

  StatisticsState({
    required this.longestChain,
    required this.currentChain,
    required this.last7DaysStreak,
    required this.daysStats,
    required this.allStats,
  });

  static StatisticsState init() {
    print("initng");
    return StatisticsState(
      currentChain: 0,
      longestChain: 0,
      last7DaysStreak: [],
      daysStats: [],
      allStats: [],
    );
  }

  StatisticsState copyWith({
    int? longestChain,
    int? currentChain,
    List<ChainDay>? last7DaysStreak,
    List<Stats>? daysStats,
    List<Stats>? allStats,
  }) {
    return StatisticsState(
      currentChain: currentChain ?? this.currentChain,
      daysStats: daysStats ?? this.daysStats,
      last7DaysStreak: last7DaysStreak ?? this.last7DaysStreak,
      longestChain: longestChain ?? this.longestChain,
      allStats: allStats ?? this.allStats,
    );
  }

  @override
  List<Object?> get props =>
      [longestChain, currentChain, last7DaysStreak, daysStats];
}

class StatisticsCubit extends Cubit<StatisticsState> {
  final ReposityFactory _provider;
  StatisticsCubit(this._provider) : super(StatisticsState.init()) {
    print("created!");
  }

  // is been called after the syncing settels
  void fetch() async {
    final stats = await _provider.getStats();
    final uniqueDatesStats = combineStatsDates(stats);
    _emitStats(uniqueDatesStats);
  }

  _emitStats(List<Stats> stats) {
    final days = stats.map((s) => s.date).toList();

    emit(
      state.copyWith(
        allStats: stats,
        currentChain: computeCurrentChain(days),
        last7DaysStreak: computeLast6Days(days),
        longestChain: computeLongestChain(days),
        daysStats: getLastStatsDays(stats, 7),
      ),
    );
  }

  void addScore(Score score) {
    final newTodayStats = score.stats();

    try {
      final prevTodayStats = state.allStats.firstWhere((element) =>
          dateInDays(element.date) == dateInDays(newTodayStats.date));

      final mergedTodayStats = prevTodayStats.mergeWith(newTodayStats);

      state.allStats.removeWhere(
        (element) =>
            dateInDays(element.date) == dateInDays(mergedTodayStats.date),
      );

      _emitStats([...state.allStats, mergedTodayStats]);
    } catch (e) {
      _emitStats([...state.allStats, newTodayStats]);
    }
  }
}

List<Stats> combineStatsDates(List<Stats> stats) {
  Map<int, Stats> combined = {};

  for (var item in stats) {
    final key = dateInDays(item.date);

    if (combined.containsKey(key)) {
      combined.update(key, (value) => value.mergeWith(item));
    }
    combined.putIfAbsent(key, () => item);
  }
  return combined.values.toList();
}

int computeLongestChain(List<DateTime> days) {
  days.sort();
  int runningChain = 1;
  int longestChain = 1;
  if (days.isEmpty) {
    return 0;
  }
  days.reduce((prev, element) {
    if ((dateInDays(prev) - dateInDays(element)).abs() == 1) {
      runningChain++;
    } else {
      longestChain = runningChain > longestChain ? runningChain : longestChain;
      runningChain = 1;
    }
    return element;
  });

  return max(longestChain, runningChain);
}

int computeCurrentChain(List<DateTime> days) {
  days.sort((a, b) => a.compareTo(b) * -1);

  if (days.isNotEmpty) {
    if (dateInDays(days[0]) == dateInDays(DateTime.now())) {
      var runningChain = 1;
      var prev = days[0];

      for (var i = 1; i < days.length; i++) {
        if ((dateInDays(prev) - dateInDays(days[i])).abs() == 1) {
          runningChain++;
          prev = days[i];
        } else {
          break;
        }
      }
      return runningChain;
    }
  }

  return 1;
}

List<Stats> getLastStatsDays(List<Stats> stats, int n) {
  final lastNDays = List.generate(
    n,
    (index) => DateTime.now().subtract(Duration(days: index)),
  );

  return lastNDays.map((day) {
    return stats.firstWhere(
      (element) => dateInDays(element.date) == dateInDays(day),
      orElse: () => Stats(day, {}),
    );
  }).toList();
}

List<ChainDay> computeLast6Days(List<DateTime> days) {
  final last7Days = [
    DateTime.now().subtract(const Duration(days: 5)),
    DateTime.now().subtract(const Duration(days: 4)),
    DateTime.now().subtract(const Duration(days: 3)),
    DateTime.now().subtract(const Duration(days: 2)),
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now().subtract(const Duration(days: 0)),
  ];
  final weekDayString = ["M", "T", "W", "T", "F", "S", "S"];
  return last7Days
      .map((date) => ChainDay(
            weekDayString[date.weekday - 1],
            days.any((day) => dateInDays(date) == dateInDays(day)),
          ))
      .toList();
}
