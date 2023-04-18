import 'dart:math';
import 'package:fitness_app/provider/exercise.dart';
import 'package:fitness_app/provider/set_number_time.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../provider/history.dart';

class CircularProgressBar extends StatefulWidget {
  const CircularProgressBar(this.height, this.dateTime, {super.key});
  final height;
  final dateTime;

  // final showDialog;

  @override
  State<CircularProgressBar> createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar>
    with TickerProviderStateMixin {
  int time = 5;
  final StopWatchTimer _stopWatchTimerCountUp =
      StopWatchTimer(mode: StopWatchMode.countUp);
  final StopWatchTimer _stopWatchTimerCountDown = StopWatchTimer(
    mode: StopWatchMode.countDown,
  );
  final StopWatchTimer _stopWatchTimerCountUpAll =
      StopWatchTimer(mode: StopWatchMode.countUp);
  bool isAction = false;
  AnimationController? _controller;
  int? timer;
  int countSet = 0;
  bool isInit = true;
  List<ExerciseItem>? data;
  int? restTime;

  int countExercise = 0;
  int? exercise;
  int? set;
  @override
  void initState() {
    print('1');
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addListener(() {
            setState(() {});
          });
    _controller!.reverse(from: 1);
    _stopWatchTimerCountDown.onStartTimer();
    _stopWatchTimerCountDown.setPresetSecondTime(time);
    _stopWatchTimerCountUpAll.onStartTimer();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit = true) {
      data = Provider.of<Exercise>(context, listen: false).newItem;
      exercise = data!.length;
    }
    isInit = false;
    _stopWatchTimerCountDown.fetchEnded.listen((event) {
      print('lol');
      setState(() {
        isAction = true;
        countSet++;
      });
      if (countSet > data![countExercise].set) {
        setState(() {
          countSet = 1;
          countExercise++;
        });
      }
      set = data![countExercise].set;
      restTime = data![countExercise].restTime;
      _stopWatchTimerCountUp.onStartTimer();
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _stopWatchTimerCountDown.dispose();
    _stopWatchTimerCountUp.dispose();
    _controller!.dispose();
    super.dispose();
  }
  //Show dia log finish

  _showFinishDialog(BuildContext context) {
    final history = Provider.of<History>(context, listen: false).historyItem;
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
              title: Text('Finish'),
              scrollable: true,
              content: FutureBuilder(
                future: Provider.of<History>(context, listen: false)
                    .fetchExercise(widget.dateTime),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? CircularProgressIndicator()
                        : Consumer<History>(
                            builder: (ctx, item, child) =>
                                Text(item.historyItem.exersise)),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Provider.of<Exercise>(context, listen: false).reset();
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    child: Text('End'))
              ]);
        });
  }
  // Stop Funcion

  void stopAction(int time) {
    print('$exercise');

    if (countExercise == (exercise! - 1) && countSet == set) {
      _stopWatchTimerCountUp.onStopTimer();

      _stopWatchTimerCountUp.onResetTimer();

      _stopWatchTimerCountUpAll.onStopTimer();
      Provider.of<Exercise>(context, listen: false)
          .addDatabase(widget.dateTime);
      Provider.of<SetNumber>(context, listen: false).addSetNuber(
          widget.dateTime,
          data![countExercise].name,
          countSet,
          time.toString());

      _showFinishDialog(context);
    } else {
      Provider.of<SetNumber>(context, listen: false).addSetNuber(
          widget.dateTime,
          data![countExercise].name,
          countSet,
          time.toString());
      _stopWatchTimerCountUp.onStopTimer();

      _stopWatchTimerCountUp.onResetTimer();

      setState(() {
        isAction = false;
      });
      _controller = AnimationController(
          vsync: this, duration: Duration(seconds: restTime!))
        ..addListener(() {
          setState(() {});
        });
      _controller!.reverse(from: 1);

      _stopWatchTimerCountDown.onStartTimer();
      _stopWatchTimerCountDown.setPresetSecondTime(restTime!);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('lieu');
    return isAction == true
        ? Container(
            child: StreamBuilder(
              stream: _stopWatchTimerCountUp.rawTime,
              initialData: _stopWatchTimerCountUp.rawTime.value,
              builder: (context, snap) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: widget.height * 0.1,
                          child: Text(
                            StopWatchTimer.getDisplayTime(snap.data!,
                                hours: false, milliSecond: false),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              stopAction(((snap.data!) % 60000) ~/ 1000);
                            },
                            child: (countSet == set &&
                                    countExercise == (exercise! - 1))
                                ? Text('Finish')
                                : Text('Done')),
                      ]),
                );
              },
            ),
          )
        : StreamBuilder<int>(
            stream: _stopWatchTimerCountDown.secondTime,
            initialData: _stopWatchTimerCountDown.secondTime.value,
            builder: (context, snap) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: widget.height * 0.3,
                        child: Stack(children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: widget.height * 0.3,
                              width: widget.height * 0.3,
                              child: CircularProgressIndicator(
                                backgroundColor: Theme.of(context).primaryColor,
                                value: _controller!.value,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              child: Text(
                                snap.data.toString(),
                                style: const TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold),
                              ))
                        ])),
                    countSet == 0
                        ? const Text(
                            'Ready',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )
                        : const Text('Rest Time',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 30,
                    ),
                    (countSet == set && countExercise < (exercise! - 1))
                        ? Text(
                            'Next exercise ${data![countExercise + 1].name}',
                            style: TextStyle(fontSize: 35),
                          )
                        : Text('')
                  ]);
            },
          );
  }
}
