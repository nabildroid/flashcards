import 'package:equatable/equatable.dart';
import 'package:flashcards/core/utils.dart';
import 'package:flashcards/models/score.dart';
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
  final List<ChainDay> last5Days;
  final List<DateTime> days;

  StatisticsState({
    required this.days,
  })  : currentChain = computeCurrentChain(days),
        longestChain = computeLongestChain(days),
        last5Days = computeLast5Days(days);

  static StatisticsState init() {
    print("initng");
    return StatisticsState(days: []);
  }

  StatisticsState copyWith({List<DateTime>? days}) {
    return StatisticsState(
      days: days ?? this.days,
    );
  }

  @override
  List<Object?> get props => [longestChain, currentChain, last5Days];
}

class StatisticsCubit extends Cubit<StatisticsState> {
  final Provider _provider;
  StatisticsCubit(this._provider) : super(StatisticsState.init()) {
    print("created!");
  }

  void fetch() async {
    print("fetching");
    final stats = await _provider.getStats();
    final days = uniqueDates(stats.days);
    emit(state.copyWith(days: days));
  }

  void addScore(Score score) {
    emit(state.copyWith(days: [...state.days, DateTime.now()]));
  }
}

int computeLongestChain(List<DateTime> days) {
  days.sort();
  int runningChain = 0;
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

List<ChainDay> computeLast5Days(List<DateTime> days) {
  final last5Days = [
    DateTime.now().subtract(Duration(days: 0)),
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now().subtract(Duration(days: 2)),
    DateTime.now().subtract(Duration(days: 3)),
    DateTime.now().subtract(Duration(days: 4)),
  ];

  return last5Days
      .map((date) => ChainDay(
            "day", // todo implement this!
            days.any((day) => dateInDays(date) == dateInDays(day)),
          ))
      .toList();
}
