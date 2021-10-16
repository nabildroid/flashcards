import 'package:flashcards/pages/home/home.dart';
import 'package:flashcards/repositories/remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cubits/statistics_cubit.dart';
import 'repositories/repository_factory.dart';

class App extends MaterialApp {
  App()
      : super(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          theme: ThemeData(
            textTheme: GoogleFonts.robotoTextTheme(),
            canvasColor: Color(0xFF6A8EAE),
          ),
          home: RepositoryProvider(
            create: (_) => RemoteRepository(),
            child: BlocProvider(
              create: (ctx) => StatisticsCubit(
                RepositoryProvider.of<RemoteRepository>(ctx),
              ),
              child: HomeScreen(),
            ),
          ),
        );
}
