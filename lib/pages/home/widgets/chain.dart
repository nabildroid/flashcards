import 'package:flashcards/cubits/statistics_cubit.dart';
import 'package:flashcards/pages/home/widgets/statstic_card.dart';
import 'package:flutter/material.dart';

class Chain extends StatelessWidget {
  final int longestChain;

  final int currentChain;

  final List<ChainDay> last5Days;

  const Chain({
    Key? key,
    required this.longestChain,
    required this.currentChain,
    required this.last5Days,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(right: StatisticCard.padding),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, -.4),
                  child: Container(
                    width: double.infinity,
                    height: 3,
                    color: Colors.blue,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 10),
                    ...last5Days.reversed
                        .map((day) => Column(
                              children: [
                                ChainNode(day.completed),
                                SizedBox(height: 2),
                                Text(
                                  day.day,
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                            ))
                        .toList(),
                    Container(
                      height: Size.fromRadius(ChainNode.raduis).height,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border:
                              Border.all(width: 2, color: Colors.blueAccent),
                          color: Colors.grey.shade800),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        currentChain.toString(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: StatisticCard.padding),
          child: Divider(
            color: Colors.white60,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(StatisticCard.padding),
          child: Row(
            children: [
              Icon(Icons.track_changes_outlined),
              SizedBox(width: 4),
              Text("longest chain: $longestChain"),
            ],
          ),
        )
      ],
    );
  }
}

class ChainNode extends StatelessWidget {
  final bool done;
  const ChainNode(
    this.done, {
    Key? key,
  }) : super(key: key);
  static const raduis = 14.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: const Size.fromRadius(raduis).width,
      height: const Size.fromRadius(raduis).height,
      decoration: BoxDecoration(
        color: done ? Colors.green : Colors.black,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
      ),
      child: done
          ? Icon(
              Icons.done,
            )
          : null,
    );
  }
}
