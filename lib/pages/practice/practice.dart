import 'package:flashcards/cubits/practice_cubit.dart';
import 'package:flashcards/models/memorization.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/pages/practice/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/learning_feedback.dart';
import 'widgets/practicing_area.dart';

class Practice extends StatefulWidget {
  const Practice._({Key? key}) : super(key: key);

  static route(PracticeCubit practiceCubit) {
    return MaterialPageRoute<Score>(
      builder: (_) => BlocProvider.value(
        value: practiceCubit,
        child: const Practice._(),
      ),
    );
  }

  @override
  _PracticeState createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  late final PageController _pageController;

  @override
  initState() {
    _pageController = PageController();
    context.read<PracticeCubit>().fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          children: [
            const StatusBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Center(
                  child: PracticingArea(pageController: _pageController),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18).copyWith(
                top: 0,
              ),
              child: BlocBuilder<PracticeCubit, PracticeState>(
                  buildWhen: (p, n) => p.status != n.status,
                  builder: (context, state) {
                    final addFeedback =
                        context.read<PracticeCubit>().addFeedback;

                    return LearningFeedback(
                      enabled: state.status == PracticeStatus.practicing,
                      easy: () => addFeedback(MemorizationState.easy),
                      hard: () => addFeedback(MemorizationState.forget),
                      good: () => addFeedback(MemorizationState.good),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
