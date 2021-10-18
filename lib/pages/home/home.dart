import 'package:flashcards/cubits/statistics_cubit.dart';
import 'package:flashcards/pages/home/widgets/app_bar.dart';
import 'package:flashcards/pages/home/widgets/ease_stats.dart';
import 'package:flashcards/pages/home/widgets/streaks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/custom_bottom_navigation_bar.dart';

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
      backgroundColor: Colors.white70,
      appBar: AppBar(
        shadowColor: Colors.black26,
        backgroundColor: Colors.white,
        title: const TextLogo(),
        actions: const [
          Sources(),
          SizedBox(width: 20),
          Icon(Icons.sync, color: Colors.black),
          SizedBox(width: 8),
        ],
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: const [
                Streaks(),
                SizedBox(height: 12),
                EaseStats(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),

      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: [
      //     FloatingActionButton.extended(
      //       onPressed: () {},
      //       label: Text("Practice"),
      //       icon: Icon(Icons.quiz_outlined),
      //       extendedPadding: const EdgeInsets.symmetric(horizontal: 6),
      //     ),
      //     FloatingActionButton.extended(
      //       onPressed: () {},
      //       label: Text("Favorit"),
      //       icon: Icon(Icons.star),
      //       extendedPadding: const EdgeInsets.symmetric(horizontal: 6),
      //     ),
      //     FloatingActionButton.extended(
      //       onPressed: () {},
      //       label: Text("Random"),
      //       icon: Icon(Icons.shuffle),
      //       extendedPadding: const EdgeInsets.symmetric(horizontal: 6),
      //     ),
      //   ],
      // ),
    );
  }
}
