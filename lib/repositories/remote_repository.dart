import 'dart:convert';

import 'package:http/http.dart' as Http;

import 'package:flashcards/core/scheduler.dart';
import 'package:flashcards/models/cart.dart';
import 'package:flashcards/models/score.dart';
import 'package:flashcards/models/stats.dart';

import 'provider.dart';

class RemoteRepository extends Provider {
  //https://stackoverflow.com/questions/44250184/setting-environment-variables-in-flutter
  //https://github.com/nabildroid/automation
  static const endpoint = String.fromEnvironment('END_POINT',
      defaultValue: 'http://localhost:8080');

  @override
  Future<List<Cart>> getCards(String setId) async {
    final response = await Http.get(Uri.parse(endpoint + "/flashcards"));

    final items = jsonDecode(response.body) as List<dynamic>;

    return items.map((e) => Cart.fromJson(e)).toList();
  }

  @override
  Future<Stats> getStats() async {
    print("getting stats");
    return Future.value(Stats(days: [
      DateTime.now().subtract(Duration(days: 1)),
      DateTime.now().subtract(Duration(days: 2)),
      DateTime.now().subtract(Duration(days: 6)),
      DateTime.now().subtract(Duration(days: 5)),
      DateTime.now().subtract(Duration(days: 6)),
      DateTime.now().subtract(Duration(days: 10)),
      DateTime.now().subtract(Duration(days: 11)),
    ], memorizations: []));
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
}
