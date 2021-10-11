import 'package:flashcards/cubits/practice_cubit.dart';
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
      height: 35,
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
      child: Row(
        children: [
          Chip(
            label: BlocBuilder<PracticeCubit, PracticeState>(
              buildWhen: (p, n) => p.learningTime != n.learningTime,
              builder: (context, state) {
                return Text(state.learningTime);
              },
            ),
            deleteIcon: Icon(Icons.exit_to_app),
            onDeleted: () => Navigator.of(context).pop(),
          ),
          const Spacer(),
          BlocBuilder<PracticeCubit, PracticeState>(
              buildWhen: (p, n) => p.index != n.index || p.status != n.status,
              builder: (context, state) {
                final hide = state.status == PracticeStatus.saving ||
                    state.status == PracticeStatus.loading;
                return AnimatedOpacity(
                  opacity: hide ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    (state.index + 1).toString() +
                        " / " +
                        state.learningCards.length.toString(),
                    style: Theme.of(context).textTheme.button?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
