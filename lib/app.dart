import 'package:flashcards/cubits/practice_cubit.dart';
import 'package:flashcards/cubits/sync_cubit.dart';
import 'package:flashcards/pages/home/home.dart';
import 'package:flashcards/repositories/remote_repository.dart';
import 'package:flashcards/services/cache_sync.dart';
import 'package:flashcards/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cubits/statistics_cubit.dart';
import 'repositories/local_repository.dart';
import 'repositories/repository_factory.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _localRepo = LocalRepository(Database());
    final _repo = ReposityFactory(
      RemoteRepository(),
      _localRepo,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
        canvasColor: Color(0xFF6A8EAE),
      ),
      home: RepositoryProvider.value(
        value: _repo,
        child: BlocProvider(
          create: (ctx) => SyncCubit(_repo, CacheSync()),
          lazy: false,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (ctx) => StatisticsCubit(
                  _repo,
                ),
              ),
              BlocProvider(
                create: (ctx) => PracticeCubit(
                  _repo,
                ),
              ),
            ],
            child: HomeScreen(),
          ),
        ),
      ),
    );
  }
}
