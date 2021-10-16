import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/stats.dart';

abstract class Provider {
  Future<List<Cart>> getCards(String setId);

  Future<Stats> getStats();

  Future<void> submitScore(Score score);

  Future<void> updateSpecialCard(String id, bool boosted);
}
