import 'package:flashcards/models/progress.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/models/stats.dart';
import 'package:flashcards/models/sync_data.dart';
import 'package:flashcards/services/database.dart';

class LocalRepository {
  final Database _db;
  LocalRepository(this._db);

  Future<List<Stats>> getStatsByIds(List<int> ids) async {
    return _db.getStats(ids);
  }

  Future<List<Stats>> getStats() async {
    return _db.getStats();
  }

  Future<int> submitScoreWithProgress(Score score) async {
    for (var flashcard in score.flashcards) {
      await _db.addProgress(
        flashcard.id,
        Progress(
          flashcard.id,
          updated: score.startTime, // the same as the serve
          ease: flashcard.progress.ease,
          interval: flashcard.progress.interval,
          repetitions: flashcard.progress.repetitions,
        ),
      );
    }

    final stats = score.stats();
    return _db.addStats(stats);
  }

  Future<List<Flashcard>> getFlashcardsByIds(List<String> ids) async {
    return _db.getFlashcards(ids);
  }

  Future<List<Progress>> getProgress() async {
    return _db.getProgress();
  }

  Future<List<Progress>> getProgressByIds(List<String> ids) async {
    return _db.getProgress(ids);
  }

  Future<void> dispatchUpdates(SyncData updates) async {
    for (var flashcard in updates.flashcards) {
      await _db.addCard(flashcard.id, flashcard);
    }

    for (var progress in updates.progress) {
      await _db.addProgress(progress.id, progress);
    }

    for (var stats in updates.statistics) {
      await _db.addStats(stats);
    }

    for (var delete in updates.deleted) {
      await _db.deleteCard(delete);
    }
  }

  dispose() {
    _db.dispose();
  }
}
