import 'package:fitness_app/provider/exercise.dart';
import 'package:fitness_app/provider/history.dart';
import 'package:fitness_app/provider/set_number_time.dart';
import 'package:fitness_app/screen/detail_history_screen.dart';
import 'package:fitness_app/screen/exercise_screen.dart';
import 'package:fitness_app/screen/history_screen.dart';
import 'package:fitness_app/screen/workout_screen.dart';
import 'package:fitness_app/widget/Circular_progress_bar_item.dart';
import 'package:fitness_app/widget/choose_screen_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Exercise()),
        ChangeNotifierProvider(create: (ctx) => History()),
        ChangeNotifierProvider(create: (ctx) => SetNumber())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.amber)),
        home: HistoryScreen(),
        routes: {
          WorkoutScreen.router: (context) => WorkoutScreen(),
          ChooseExerciseScreen.router: (context) => ChooseExerciseScreen(),
          DetailHistoryScreen.router: (context) => DetailHistoryScreen()
        },
      ),
    );
  }
}
