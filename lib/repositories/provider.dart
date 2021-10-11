import '../models/general.dart';

abstract class Provider {
  Future<List<Cart>> getCards(String setId);
  Future<List<Set>> getSets();

  Future<Stats> getStats();

  Future<void> submitScore(Score score);
}
