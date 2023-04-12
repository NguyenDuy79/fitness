import 'dart:ui';

import 'package:fitness_app/widget/Circular_progress_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class WorkoutScreen extends StatelessWidget {
  static const router = '/workout-screen';
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool restTime = true;
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Out'),
      ),
      body: CircularProgressBar(),
    );
  }
}
