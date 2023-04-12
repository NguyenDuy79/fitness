import 'package:fitness_app/provider/exercise.dart';
import 'package:fitness_app/screen/exercise_screen.dart';
import 'package:fitness_app/screen/finish_screen.dart';
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
    return ChangeNotifierProvider(
      create: (ctx) => Exercise(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.amber)),
        home: ChooseExerciseScreen(),
        routes: {
          WorkoutScreen.router: (context) => const WorkoutScreen(),
          FinishScreen.router: (context) => const FinishScreen()
        },
      ),
    );
  }
}
