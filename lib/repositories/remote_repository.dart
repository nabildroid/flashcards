import 'dart:convert';

import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:flashcards/models/sync_data.dart';
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
  Future<void> submitScore(Score score) async {
    final body = {"score": score};
    final data = jsonEncode(body);
    await Http.post(
      Uri.parse(endpoint + "/flashcards"),
      headers: {"content-type": "application/json"},
      body: data,
    );
  }

  Future<SyncData> getLatestUpdates(CachedSyncDates dates) async {
    final host = endpoint.replaceFirst(RegExp("^http.*://"), "");
    final url = Uri.http(host, "/flashcards", dates.toJson());

    final response = await Http.get(url);

    final json = jsonDecode(response.body) as Map;
    return SyncData.fromJson(json);
  }
}
