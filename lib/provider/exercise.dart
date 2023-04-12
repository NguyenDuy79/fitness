import 'package:flutter/material.dart';

class ExerciseItem {
  final String name;
  bool choose;
  final int set;
  final int restTime;
  ExerciseItem(
      {required this.name,
      required this.set,
      required this.restTime,
      this.choose = false});
}

class Exercise with ChangeNotifier {
  List<ExerciseItem> _item = [
    ExerciseItem(name: 'squat', set: 0, restTime: 0),
    ExerciseItem(name: 'bench press', set: 0, restTime: 0),
    ExerciseItem(name: 'leg press', set: 0, restTime: 0),
    ExerciseItem(name: 'deadlift', set: 0, restTime: 0),
    ExerciseItem(name: 'shoulder press', set: 0, restTime: 0),
    ExerciseItem(name: 'hammer curl', set: 0, restTime: 0)
  ];
  List<ExerciseItem> get item {
    return [..._item];
  }

  List<ExerciseItem> newList = [];
  List<ExerciseItem> get newItem {
    return newList;
  }

  addExercise(String name, bool choose) {
    newList.add(ExerciseItem(name: name, set: 0, restTime: 0, choose: choose));
  }

  removeExercise(String name) {
    final index = newList.indexWhere((element) => element.name == name);
    if (index == null) {
      return;
    }
    newList.removeAt(index);
  }

  updateExercise(ExerciseItem exerciseItem) {
    final exerciseIndex =
        newList.indexWhere((element) => element.name == exerciseItem.name);
    newList[exerciseIndex] = exerciseItem;
    notifyListeners();
  }
}
