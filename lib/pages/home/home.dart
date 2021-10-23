import 'package:flashcards/cubits/statistics_cubit.dart';
import 'package:flashcards/cubits/sync_cubit.dart';
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
    return BlocListener<SyncCubit, SyncState>(
      listenWhen: (p, n) => n != SyncState.syncing,
      listener: (ctx, state) {
        ctx.read<StatisticsCubit>().fetch();
      },
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          shadowColor: Colors.black26,
          backgroundColor: Colors.white,
          title: const TextLogo(),
          actions: [
            const Sources(),
            const SizedBox(width: 20),
            BlocBuilder<SyncCubit, SyncState>(
              buildWhen: (n, p) => n.index != p.index,
              builder: (ctx, state) => state == SyncState.synced
                  ? const SizedBox.shrink()
                  : Icon(
                      Icons.sync,
                      color: state == SyncState.syncing
                          ? Colors.green
                          : Colors.black87,
                    ),
            ),
            const SizedBox(width: 8),
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
        bottomNavigationBar: BlocBuilder<SyncCubit, SyncState>(
          builder: (context, state) {
            return IgnorePointer(
              ignoring: !(state == SyncState.init),
              child: const CustomBottomNavigationBar(),
            );
          },
        ),
      ),
    );
  }
}
