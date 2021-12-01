import 'dart:convert';

import 'package:flashcards/models/cached_sync_dates.dart';
import 'package:flashcards/models/sync_data.dart';
// ignore: library_prefixes
import 'package:http/http.dart' as Http;

import 'package:flashcards/models/score.dart';

class RemoteRepository {
  //https://stackoverflow.com/questions/44250184/setting-environment-variables-in-flutter
  //https://github.com/nabildroid/automation
  static const endpoint = String.fromEnvironment('END_POINT',
      defaultValue: 'https://supernabil.herokuapp.com');

  Future<void> submitScore(Score score) async {
    final body = score.toJson();
    final data = jsonEncode(body);
    await Http.post(
      Uri.parse(endpoint + "/flashcard/score"),
      headers: {"content-type": "application/json"},
      body: data,
    );
  }

  Future<SyncData> getLatestUpdates(CachedSyncDates dates) async {
    final host = endpoint.replaceFirst(RegExp("^http.*://"), "");
    final url = Uri.https(host, "/flashcard", dates.toJson());

    final response = await Http.get(url);

    final json = jsonDecode(response.body) as Map;
    return SyncData.fromJson(json);
  }

  Future<void> dispatchUpdates(SyncData updates) async {
    final body = updates.toJson();
    final data = jsonEncode(body);
    await Http.post(
      Uri.parse(endpoint + "/flashcard/offline"),
      headers: {"content-type": "application/json"},
      body: data,
    );
  }
}
