import 'package:flutter/material.dart';

class FeeState extends ChangeNotifier {
  DateTime? selectedDate;
  int feeType = 0;
  int selectItem = -1;
  List<String> inputData = [];
  String calcPrice = "";
  String notes = ""; // 备注

  void modifySelectedDate(DateTime? value) {
    print("date: $value");
    selectedDate = value;
  }

  void modifyFeeType(int value) {
    feeType = value;
    notifyListeners();
  }

  void modifySelectItem(int value) {
    selectItem = value;
    notifyListeners();
  }

  void modifyFees(List<String> input, String price) {
    calcPrice = price;
    inputData = input;
    notifyListeners();
  }

  void modifyNotes(String value) {
    notes = value;
  }
}
