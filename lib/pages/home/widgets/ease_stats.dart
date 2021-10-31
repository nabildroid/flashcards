import 'package:flashcards/core/utils.dart';
import 'package:flashcards/cubits/statistics_cubit.dart';
import 'package:flashcards/models/memorization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chart.dart';
import 'statistic_card.dart';

class EaseStats extends StatelessWidget {
  const EaseStats({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ease Statistics",
          style: Theme.of(context).textTheme.caption?.copyWith(
                color: Colors.black45,
              ),
        ),
        StatisticCard([
          Row(
            children: [
              Text("Period",
                  style: Theme.of(context).textTheme.button?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.indigo,
                ),
                onPressed: () {},
                child: Text("Last 7 days"),
              ),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: BlocBuilder<StatisticsCubit, StatisticsState>(
              buildWhen: (p, n) => p.daysStats != n.daysStats,
              builder: (context, state) => Chart(
                colors: [
                  Color(0xFF00A2C6),
                  Color(0xFF41A430),
                  Color(0xFFEF4848),
                ],
                xLabels: state.daysStats.reversed
                    .map((e) => monthDayFromDate(e.date))
                    .toList(),
                data: state.daysStats.reversed
                    .map((e) => [
                          MemorizationState.easy,
                          MemorizationState.good,
                          MemorizationState.forget,
                        ].map((s) {
                          if (e.states.containsKey(s)) {
                            return e.states[s]!.toDouble();
                          } else {
                            return 0.0;
                          }
                        }).toList())
                    .toList(),
              ),
            ),
          ),
          Text(
            "Total flashcards:  10",
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ]),
      ],
    );
  }
}
