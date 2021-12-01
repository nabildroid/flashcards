import 'dart:async';
import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/models/practice_flashcard.dart';
import 'package:flashcards/repositories/repository_factory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RandomBrowseState {
  final List<Flashcard> selected;
  final List<Flashcard> all;
  final List<String> tags;
  final String? tag;

  RandomBrowseState({
    required this.selected,
    required this.all,
    required this.tags,
    this.tag,
  });

  RandomBrowseState copyWith({
    List<Flashcard>? selected,
    List<Flashcard>? all,
    List<String>? tags,
    String? tag,
  }) {
    return RandomBrowseState(
      all: all ?? this.all,
      selected: selected ?? this.selected,
      tags: tags ?? this.tags,
      tag: tag,
    );
  }

  RandomBrowseState.fill(List<Flashcard> flashcards)
      : all = flashcards,
        selected = flashcards,
        tags = flashcards.fold<Set<String>>({}, (previousValue, element) {
          previousValue.addAll(element.tags);
          return previousValue;
        }).toList(),
        tag = null;

  RandomBrowseState.init()
      : all = [],
        selected = [],
        tags = [],
        tag = null;
}

class RandomCubit extends Cubit<RandomBrowseState> {
  final ReposityFactory _repository;

  RandomCubit(this._repository) : super(RandomBrowseState.init());

  void fetch() async {
    final prevProgress = await _repository.getProgress();
    prevProgress.shuffle();

    final List<PracticeFlashcard> selected = [];
    // todo refactore this
    for (var item in prevProgress) {
      final query = await _repository.getFlashcardByIds([item.id]);
      if (query.isNotEmpty) {
        selected.add(PracticeFlashcard(
          query[0],
          item,
        ));
      }
    }

    emit(RandomBrowseState.fill(selected.map((e) => e.flashcard).toList()));
  }

  clearTag() => emit(state.copyWith(
        tag: null,
        selected: state.all,
      ));

  setTag(String tag) => emit(
        state.copyWith(
            tag: tag,
            selected: state.all
                .where((element) => element.tags.contains(tag))
                .toList()),
      );

  Future<bool> toggleBoosted(String id, bool boosted) async {
    // BUG implement this!
    return boosted;
  }

  Future<void> remove(String id) async {}
}
