import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:namma_score_board/score_board/score_board.dart';

import 'score_board/player_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PlayerAdapter());
  await Hive.openBox('players');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade500),
          useMaterial3: true,
        ),
        home: const ScoreBoard());
  }
}
