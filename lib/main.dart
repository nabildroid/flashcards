import 'package:flashcards/repositories/repository_factory.dart';
import 'package:flashcards/services/cache_service.dart';
import 'package:flashcards/services/database.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() async {
  await CacheService.init();
  await Database.init();
  await ReposityFactory.init();

  runApp(App());
}
