import 'package:flashcards/entities/progress.dart';
import 'package:flashcards/models/flashcard.dart';

class PracticeFlashcard {
  final Flashcard flashcard;
  final ProgressEntity progress;

  PracticeFlashcard(this.flashcard, this.progress);
}
