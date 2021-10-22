import 'package:flashcards/cubits/practice_cubit.dart';
import 'package:flashcards/models/memorization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF5D7D9A),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<PracticeCubit, PracticeState>(
                  buildWhen: (p, n) =>
                      p.index != n.index || p.toPractice.isEmpty,
                  builder: (context, state) {
                    return CardNumber(
                      number: state.index,
                      total: state.toPractice.length,
                    );
                  }),
              BlocBuilder<PracticeCubit, PracticeState>(
                  buildWhen: (p, n) => p.learningTime != n.learningTime,
                  builder: (context, state) {
                    return Timer(state.learningTime);
                  }),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 3,
            width: double.infinity,
            child: BlocBuilder<PracticeCubit, PracticeState>(
                buildWhen: (p, n) => p.index != n.index || p.toPractice.isEmpty,
                builder: (context, state) {
                  return Progress([
                    ...state.reviewed.map((l) {
                      switch (l.state) {
                        case MemorizationState.easy:
                          return const Color(0xFF00A2C6);
                        case MemorizationState.good:
                          return const Color(0xFF41A430);
                        default:
                          return const Color(0xFFEF668F);
                      }
                    }),
                    ...List.generate(
                      state.toPractice.length - state.index,
                      (_) => const Color(0xFF9BD1E5),
                    )
                  ]);
                }),
          ),
        ],
      ),
    );
  }
}

class Timer extends StatelessWidget {
  final String time;
  const Timer(
    this.time, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.timer,
          color: Color(0xFF157145),
        ),
        const SizedBox(width: 4),
        Text(
          time,
          style: const TextStyle(color: Color(0xFFD1FAFF)),
        ),
      ],
    );
  }
}

class CardNumber extends StatelessWidget {
  final int number;
  final int total;
  const CardNumber({
    Key? key,
    required this.number,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Card " + number.toString(),
        style: const TextStyle(
          color: Color(0xFFD1FAFF),
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: " / " + total.toString(),
            style: const TextStyle(
              color: Color(0xFF157145),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class Progress extends StatelessWidget {
  final List<Color> colors;
  const Progress(
    this.colors, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: colors
            .map((color) => Container(
                  height: double.infinity,
                  width: (width * .7) / 10,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ))
            .toList(),
      );
    });
  }
}
