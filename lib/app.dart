import 'package:flashcards/pages/home/home.dart';
import 'package:flashcards/repositories/remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends MaterialApp {
  App()
      : super(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          home: RepositoryProvider(
            create: (_) => RemoteRepository(),
            child: HomeScreen(),
          ),
        );
}
