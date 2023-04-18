import 'package:flutter/material.dart';

import '../helper/db_helper.dart';

class HistoryItem {
  final String dateTime;
  final String exersise;
  HistoryItem(this.dateTime, this.exersise);
}

class History with ChangeNotifier {
  List<HistoryItem?> _item = [];
  List<HistoryItem?> get item {
    return [..._item];
  }

  HistoryItem historyItem = HistoryItem('', '');

  Future<void> fetchExercise(String dateTime) async {
    print(dateTime);
    final dataList = await DBhelper.getData('history_table');
    var index =
        dataList.indexWhere((element) => element['dateTime'] == dateTime);
    historyItem =
        HistoryItem(dataList[index]['dateTime'], dataList[index]['exercise']);

    notifyListeners();
  }

  Future<void> fetchAllExercise() async {
    final dataList = await DBhelper.getData('history_table');
    _item =
        dataList.map((e) => HistoryItem(e['dateTime'], e['exercise'])).toList();
    notifyListeners();
  }
}
