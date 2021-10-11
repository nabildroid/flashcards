import 'package:flashcards/core/scheduler.dart';
import 'package:flashcards/cubits/practice_cubit.dart';
import 'package:flashcards/models/general.dart';
import 'package:flashcards/pages/practice/widgets/status_bar.dart';
import 'package:flashcards/repositories/provider.dart';
import 'package:flashcards/repositories/remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/flashcard.dart';
import 'widgets/learning_feedback.dart';
import 'widgets/practicing_area.dart';

class Practice extends StatefulWidget {
  const Practice._({Key? key}) : super(key: key);

  static route(PracticeCubit practiceCubit) {
    return MaterialPageRoute(
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
      child: Container(
          width: double.infinity,
          height: double.infinity,
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
              BlocBuilder<PracticeCubit, PracticeState>(
                  buildWhen: (p, n) => p.status != n.status,
                  builder: (context, state) {
                    return AnimatedSlide(
                      offset: state.status == PracticeStatus.practicing
                          ? Offset(0, 0)
                          : Offset(0, 1),
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      child: LearningFeedback(
                        easy: () => context
                            .read<PracticeCubit>()
                            .addFeedback(MemorizationState.easy),
                        hard: () => context
                            .read<PracticeCubit>()
                            .addFeedback(MemorizationState.forget),
                        good: () => context
                            .read<PracticeCubit>()
                            .addFeedback(MemorizationState.good),
                      ),
                    );
                  }),
            ],
          )),
    ));
  }
}
