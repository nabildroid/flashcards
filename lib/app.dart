import 'package:flashcards/pages/home/home.dart';
import 'package:flashcards/repositories/provider.dart';
import 'package:flashcards/repositories/remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/statistics_cubit.dart';
import 'repositories/repository_factory.dart';

class App extends MaterialApp {
  App()
      : super(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          home: RepositoryProvider(
            create: (_) => ReposityFactory.create(),
            child: BlocProvider(
              create: (ctx) => StatisticsCubit(
                RepositoryProvider.of<RemoteRepository>(ctx),
              ),
              child: HomeScreen(),
            ),
          ),
        );
}
