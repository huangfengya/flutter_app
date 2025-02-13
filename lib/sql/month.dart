import 'package:flutter/material.dart';

class MonthProvider extends ChangeNotifier {
  int _currMonth = DateTime.now().month;
  int _currYear = DateTime.now().day;

  int get currMonth => _currMonth;
  int get currYear => _currYear;
  String get currDate => "$currYear/$_currMonth";

  void setCurrDate(String date) {
    DateTime cDate = DateTime.parse(date);
    _currMonth = cDate.month;
    _currYear = cDate.year;
    notifyListeners();
  }
}
