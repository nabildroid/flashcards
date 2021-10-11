import 'package:flashcards/cubits/statistics_cubit.dart';
import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/score.dart';

abstract class Provider {
  Future<List<Cart>> getCards(String setId);

  Future<Stats> getStats();

  Future<void> submitScore(Score score);
}
