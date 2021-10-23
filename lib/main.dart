import 'package:flashcards/repositories/repository_factory.dart';
import 'package:flashcards/services/cache_sync.dart';
import 'package:flashcards/services/database.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() async {
  await CacheSync.init();
  await Database.init();
  await ReposityFactory.init();

  runApp(App());
}
