import 'package:provider/provider.dart';

import 'package:fitness_app/provider/exercise.dart';
import 'package:fitness_app/widget/Circular_progress_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class WorkoutScreen extends StatelessWidget {
  static const router = '/workout-screen';
  WorkoutScreen({super.key});
  String dateTime = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Work Out'),
      automaticallyImplyLeading: false,
    );
    var height = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);
    bool restTime = true;
    return Scaffold(
      appBar: appBar,
      body: CircularProgressBar(height, dateTime),
    );
  }
}
