import 'package:equatable/equatable.dart';
import 'package:flashcards/core/utils.dart';
import 'package:flashcards/entities.dart/stats.dart';
import 'package:flashcards/models/memorization.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/stats.dart';
import 'package:flashcards/repositories/provider.dart';
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
  final List<StatsEntity> daysStats;
  final List<StatsEntity> allStats;

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
    List<StatsEntity>? daysStats,
    List<StatsEntity>? allStats,
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
  final Provider _provider;
  StatisticsCubit(this._provider) : super(StatisticsState.init()) {
    print("created!");
  }

  void fetch() async {
    final stats = await _provider.getStats();

    _emitStats(stats);
  }

  _emitStats(List<StatsEntity> stats) {
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
    final newTodayStats = score.cards.fold<StatsEntity>(
      StatsEntity(DateTime.now(), {}),
      (previousValue, element) {
        previousValue.states.putIfAbsent(element.state, () => 0);
        previousValue.states.update(element.state, (value) => value + 1);

        return previousValue;
      },
    );

    try {
      final prevTodayStats = state.allStats.firstWhere((element) =>
          dateInDays(element.date) == dateInDays(newTodayStats.date));

      // final uniqueKeys = Set()
      //   ..addAll([...prevTodayStats.states.keys, ...newTodayStats.states.keys]);

      final mergedTodayStats = StatsEntity(newTodayStats.date, {});

      prevTodayStats.states.forEach((key, value) {
        mergedTodayStats.states.putIfAbsent(key, () => 0);
        mergedTodayStats.states.update(key, (v) => v + value);
      });

      newTodayStats.states.forEach((key, value) {
        mergedTodayStats.states.putIfAbsent(key, () => 0);
        mergedTodayStats.states.update(key, (v) => v + value);
      });

      _emitStats([
        ...state.allStats.where((element) =>
            dateInDays(element.date) != dateInDays(mergedTodayStats.date)),
        mergedTodayStats,
      ]);
    } catch (e) {
      _emitStats([...state.allStats, newTodayStats]);
    }
  }
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
  return longestChain;
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
          return runningChain;
        }
      }
    }
  }

  return 1;
}

List<StatsEntity> getLastStatsDays(List<StatsEntity> stats, int n) {
  final lastNDays = List.generate(
    n,
    (index) => DateTime.now().subtract(Duration(days: index)),
  );

  return lastNDays.map((day) {
    try {
      return stats
          .firstWhere((element) => dateInDays(element.date) == dateInDays(day));
    } catch (e) {
      return StatsEntity(day, {});
    }
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
