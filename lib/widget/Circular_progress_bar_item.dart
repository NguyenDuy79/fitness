import 'dart:math';
import 'package:fitness_app/provider/exercise.dart';
import 'package:fitness_app/screen/finish_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CircularProgressBar extends StatefulWidget {
  const CircularProgressBar({super.key});

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

    super.initState();
  }

  @override
  void didUpdateWidget(covariant CircularProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
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

  void stopAction(int data) {
    print('$exercise');
    if (countExercise == (exercise! - 1) && countSet == set) {
      Navigator.of(context).pushNamed(FinishScreen.router);
      setState(() {
        countExercise = 0;
      });
    } else {
      _stopWatchTimerCountUp.onStopTimer();

      _stopWatchTimerCountUp.onResetTimer();
      timer = data;
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
      print('$timer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isAction == true
        ? StreamBuilder(
            stream: _stopWatchTimerCountUp.rawTime,
            initialData: _stopWatchTimerCountUp.rawTime.value,
            builder: (context, snap) {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        StopWatchTimer.getDisplayTime(snap.data!,
                            hours: false, milliSecond: false),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            stopAction(((snap.data!) % 60000) ~/ 1000);
                          },
                          child: (countSet == set &&
                                  countExercise == (exercise! - 1))
                              ? Text('Finsh')
                              : Text('Done'))
                    ]),
              );
            },
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                            value: _controller!.value,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: StreamBuilder<int>(
                            stream: _stopWatchTimerCountDown.secondTime,
                            initialData:
                                _stopWatchTimerCountDown.secondTime.value,
                            builder: (context, snap) {
                              return Text(
                                snap.data.toString(),
                                style: const TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold),
                              );
                            },
                          ))
                    ],
                  ),
                ),
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
  }
}
