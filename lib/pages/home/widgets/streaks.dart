import 'package:flashcards/cubits/statistics_cubit.dart';
import 'package:flashcards/pages/home/widgets/statistic_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Streaks extends StatelessWidget {
  const Streaks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Streak",
          style: Theme.of(context).textTheme.caption?.copyWith(
                color: Colors.black45,
              ),
        ),
        StatisticCard([
          BlocBuilder<StatisticsCubit, StatisticsState>(
            buildWhen: (p, n) => p.last7DaysStreak != n.last7DaysStreak,
            builder: (context, state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: state.last7DaysStreak
                  .map(
                    (day) => Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: day.completed
                            ? Colors.indigoAccent
                            : Colors.transparent,
                        border: Border.all(
                          width: 3,
                          color: Colors.black26,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          day.day,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: day.completed
                                ? Colors.indigo.shade50
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: BlocBuilder<StatisticsCubit, StatisticsState>(
                    buildWhen: (p, n) => p.currentChain != n.currentChain,
                    builder: (context, state) {
                      return StreakCard(
                        title: "Current Streak",
                        unit: "days",
                        value: state.currentChain,
                      );
                    }),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: BlocBuilder<StatisticsCubit, StatisticsState>(
                    buildWhen: (p, n) => p.longestChain != n.longestChain,
                    builder: (context, state) {
                      return StreakCard(
                        title: "Best Streak",
                        unit: "days in row",
                        value: state.longestChain,
                      );
                    }),
              ),
            ],
          )
        ]),
      ],
    );
  }
}

class StreakCard extends StatelessWidget {
  final String title;
  final int value;
  final String unit;
  const StreakCard({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$value",
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
