import 'dart:convert';

import 'package:http/http.dart' as Http;

import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/stats.dart';

import 'provider.dart';

class RemoteRepository extends Provider {
  //https://stackoverflow.com/questions/44250184/setting-environment-variables-in-flutter
  //https://github.com/nabildroid/automation
  static const endpoint = String.fromEnvironment('END_POINT',
      defaultValue: 'https://supernabil.herokuapp.com');

  @override
  Future<List<Cart>> getCards() async {
    final response = await Http.get(Uri.parse(endpoint + "/flashcards"));

    final items = jsonDecode(response.body) as List<dynamic>;

    return items.map((e) => Cart.fromJson(e)).toList();
  }

  @override
  Future<List<Stats>> getStats() async {
    final response = await Http.get(
      Uri.parse(endpoint + "/flashcardsStats"),
    );

    final items = jsonDecode(response.body) as List<dynamic>;

    return items.map((e) => Stats.fromJson(e)).toList();
  }

  @override
  Future<void> submitScore(Score score) async {
    final body = {"score": score};
    final data = jsonEncode(body);
    await Http.post(
      Uri.parse(endpoint + "/flashcards"),
      headers: {"content-type": "application/json"},
      body: data,
    );
  }

  @override
  Future<void> updateSpecialCard(String id, bool boosted) async {
    final data = {"id": id, "boosted": boosted};
    final body = jsonEncode(data);
    await Http.post(
      Uri.parse(endpoint + "/updateSpecialFlashcard"),
      headers: {"content-type": "application/json"},
      body: body,
    );
  }
}
