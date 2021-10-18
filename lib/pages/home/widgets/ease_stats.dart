import 'package:flutter/material.dart';

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
            child: Chart(
              colors: [
                Colors.green.shade300,
                Colors.green.shade500,
                Colors.green.shade800
              ],
              xLabels: [
                "13 oct",
                "14 oct",
                "15 oct",
                "13 oct",
                "14 oct",
                "15 oct",
              ],
              data: [
                [2, 5, 3],
                [6, 2, 6],
                [6, 2, 6],
                [6, 2, 6],
                [6, 2, 6],
                [8, 1, 1],
              ],
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
