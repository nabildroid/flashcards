import 'package:flashcards/cubits/random_browse_cubit.dart';
import 'package:flashcards/pages/practice/widgets/flashcard_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RandomBrowse extends StatefulWidget {
  const RandomBrowse({Key? key}) : super(key: key);

  @override
  _RnadomBrowseState createState() => _RnadomBrowseState();
}

class _RnadomBrowseState extends State<RandomBrowse> {
  @override
  initState() {
    super.initState();
    context.read<RandomCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).canvasColor,
                            Theme.of(context).canvasColor.withOpacity(.6),
                            Theme.of(context).canvasColor.withOpacity(0),
                          ],
                          begin: Alignment.centerRight,
                          end: const Alignment(.9, 0),
                        ),
                      ),
                      position: DecorationPosition.foreground,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: BlocBuilder<RandomCubit, RandomBrowseState>(
                            builder: (context, state) {
                          return Row(
                            children: state.tags.map((tag) {
                              final selected =
                                  state.tag != null && state.tag == tag;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: selected
                                    ? Chip(
                                        onDeleted: context
                                            .read<RandomCubit>()
                                            .clearTag,
                                        label: Text(tag),
                                      )
                                    : ActionChip(
                                        onPressed: () => context
                                            .read<RandomCubit>()
                                            .setTag(tag),
                                        label: Text(tag),
                                      ),
                              );
                            }).toList(),
                          );
                        }),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: RepaintBoundary(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Center(
                    child: BlocBuilder<RandomCubit, RandomBrowseState>(
                        builder: (context, state) {
                      return PageView(
                        key: UniqueKey(),
                        clipBehavior: Clip.none,
                        children: state.selected
                            .map(
                              (item) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: FlashcardContainer(
                                  head: item.term,
                                  tail: item.definition,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
