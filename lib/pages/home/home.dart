import 'package:flashcards/cubits/practice_cubit.dart';
import 'package:flashcards/cubits/statistics_cubit.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/pages/practice/practice.dart';
import 'package:flashcards/repositories/remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/chain.dart';
import 'widgets/statstic_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<StatisticsCubit>().fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    StatisticCard(
                      title: "Days in a Row",
                      children: [
                        BlocBuilder<StatisticsCubit, StatisticsState>(
                            builder: (context, state) {
                          return Chain(
                            currentChain: state.currentChain,
                            longestChain: state.longestChain,
                            last5Days: state.last5Days,
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 10),
                    StatisticCard(
                      title: "Learning Curve",
                      children: [
                        const SizedBox(height: 90),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Practice"),
        heroTag: "practice",
        onPressed: () async {
          final score = await Navigator.push<Score>(
            context,
            Practice.route(
              PracticeCubit(RepositoryProvider.of<RemoteRepository>(context)),
            ),
          );

          if (score != null) {
            context.read<StatisticsCubit>().addScore(score);
          }
        },
      ),
    );
  }
}
