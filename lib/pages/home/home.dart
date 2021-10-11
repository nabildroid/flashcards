import 'package:flashcards/cubits/practice_cubit.dart';
import 'package:flashcards/pages/practice/practice.dart';
import 'package:flashcards/repositories/remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/statstic_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                      children: [
                        Text(
                          "Days in a Row",
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        const SizedBox(height: 90),
                      ],
                    ),
                    SizedBox(height: 10),
                    StatisticCard(
                      children: [
                        Text(
                          "Learning Curve",
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
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
        label: Text("Practsice"),
        heroTag: "practice",
        onPressed: () {
          Navigator.push(
            context,
            Practice.route(
              PracticeCubit(RepositoryProvider.of<RemoteRepository>(context)),
            ),
          );
        },
      ),
    );
  }
}
