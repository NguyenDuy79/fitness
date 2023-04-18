import 'package:fitness_app/helper/db_helper.dart';
import 'package:flutter/material.dart';

class SetNumberItem {
  final String name;
  final int setNumber;
  final String time;
  SetNumberItem(
      {required this.name, required this.setNumber, required this.time});
}

class SetNumber with ChangeNotifier {
  List<SetNumberItem?> _item = [];
  List<SetNumberItem?> get item {
    return [..._item];
  }

  addSetNuber(String dateTime, String name, int setNumber, String time) {
    DBhelper.insert('set_time_table', {
      'dateTime': dateTime,
      'name': name,
      'setNumber': setNumber,
      'time': time
    });
    print('done');
  }

  Future<void> fetchDatabase(String dateTime) async {
    final dataList = await DBhelper.getData('set_time_table');
    _item = dataList.map((e) {
      if (e['dateTime'] == dateTime) {
        return SetNumberItem(
            name: e['name'], setNumber: e['setNumber'], time: e['time']);
      }
    }).toList();
    notifyListeners();
  }
}
