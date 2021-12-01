import 'package:flashcards/cubits/practice_cubit.dart';
import 'package:flashcards/models/memorization.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/pages/practice/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/learning_feedback.dart';
import 'widgets/practicing_area.dart';

class Practice extends StatefulWidget {
  final PracticeMode mode;
  const Practice(this.mode, {Key? key}) : super(key: key);

  @override
  _PracticeState createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  late final PageController _pageController;

  @override
  initState() {
    _pageController = PageController();
    context.read<PracticeCubit>().fetch(widget.mode);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            // TODO refactor this!
            if (widget.mode == PracticeMode.learning) const StatusBar(),
            if (widget.mode != PracticeMode.learning)
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.exit_to_app),
              ),
            Expanded(
              child: RepaintBoundary(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Center(
                    child: PracticingArea(
                      pageController: _pageController,
                      manual: widget.mode != PracticeMode.learning,
                    ),
                  ),
                ),
              ),
            ),
            if (widget.mode == PracticeMode.learning)
              RepaintBoundary(
                child: Padding(
                  padding: const EdgeInsets.all(18).copyWith(
                    top: 0,
                  ),
                  child: BlocBuilder<PracticeCubit, PracticeState>(
                      buildWhen: (p, n) => p.status.index != n.status.index,
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
              ),
          ],
        ),
      ),
    );
  }
}
