import 'package:flashcards/cubits/practice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'flashcard.dart';

class PracticingArea extends StatelessWidget {
  const PracticingArea({
    Key? key,
    required PageController pageController,
  })  : _pageController = pageController,
        super(key: key);

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PracticeCubit, PracticeState>(
        listener: (_, state) {
          if (state.status == PracticeStatus.finished) {
            final score = context.read<PracticeCubit>().getScore();
            return Navigator.of(context).pop(score);
          }

          _pageController.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        },
        listenWhen: (p, n) =>
            p.index != n.index || n.status == PracticeStatus.finished,
        buildWhen: (p, n) {
          return p.status == PracticeStatus.loading &&
                  n.status != PracticeStatus.loading ||
              n.status == PracticeStatus.saving;
        },
        builder: (context, state) {
          if (state.status == PracticeStatus.loading ||
              state.status == PracticeStatus.saving) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Hero(
                tag: "practice",
                child: Flashcard(
                  head: "Flash Cards",
                  tail: "Speace Repetition Application\n made by Nabil Lakrib",
                ),
              ),
            );
          } else {
            return PageView(
              clipBehavior: Clip.none,
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: state.learningCards
                  .map(
                    (cart) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Flashcard(
                        head: cart.term,
                        tail: cart.definition,
                      ),
                    ),
                  )
                  .toList(),
            );
          }
        });
  }
}
