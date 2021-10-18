import 'package:flashcards/pages/home/widgets/statistic_card.dart';
import 'package:flutter/material.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              6,
              (index) => Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: Colors.indigoAccent,
                  border: Border.all(
                    width: 3,
                    color: Colors.black26,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "A",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Colors.indigo.shade50,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: const [
              Expanded(
                child: StreakCard(
                  title: "Current Streak",
                  unit: "days",
                  value: 5,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: StreakCard(
                  title: "Best Streak",
                  unit: "days in row",
                  value: 55,
                ),
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
