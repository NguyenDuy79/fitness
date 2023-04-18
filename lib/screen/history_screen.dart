import 'package:fitness_app/provider/exercise.dart';
import 'package:fitness_app/screen/detail_history_screen.dart';
import 'package:fitness_app/screen/exercise_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/history.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  static const router = '/history-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future:
                Provider.of<History>(context, listen: false).fetchAllExercise(),
            builder: (ctx, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? CircularProgressIndicator()
                : Consumer<History>(
                    builder: (ctx, greatPlaces, child) => greatPlaces
                                .item.length <=
                            0
                        ? child!
                        : Container(
                            height: 500,
                            child: ListView.builder(
                              itemCount: greatPlaces.item.length,
                              itemBuilder: (ctx, i) => InkWell(
                                child: ListTile(
                                  leading: Text(greatPlaces.item[i]!.dateTime),
                                  title: Text(greatPlaces.item[i]!.exersise),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        DetailHistoryScreen.router,
                                        arguments:
                                            greatPlaces.item[i]!.dateTime);
                                  },
                                ),
                              ),
                            ),
                          ),
                    child: Center(
                      child:
                          const Text('Got no places yet, start adding some!'),
                    ),
                  ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ChooseExerciseScreen.router);
              },
              child: Text('Next'))
        ],
      ),
    );
  }
}
