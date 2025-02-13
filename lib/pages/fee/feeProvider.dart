import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class FeeState extends ChangeNotifier {
  DateTime? selectedDate;
  int feeType = 0;
  int selectItem = -1;
  List<String> inputData = [];
  String calcPrice = "";
  String notes = ""; // 备注

  void init() {
    selectedDate = null;
    feeType = 0;
    selectItem = -1;
    inputData = [];
    calcPrice = "";
    notes = "";
  }

  void modifySelectedDate(DateTime? value) {
    print("date: $value");
    selectedDate = value;
    notifyListeners();
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

  void done(VoidCallback? cb) {
    if (cb != null) {
      cb();
    }
  }
}

class FeesManager {
  RegExp lastIsNum = RegExp(r'\d$');
  RegExp lastIsDot = RegExp(r'\.$');
  RegExp lastIsOp = RegExp(r'^[+-]$');

  final FeeState _feeState;
  FeesManager(this._feeState);

  void init() {
    _feeState.inputData = [];
    _feeState.calcPrice = "";
  }

  void modifyCalcPrice(String value) {
    _feeState.calcPrice = value;
  }

  void add() {}

  void calcTotalPrice() {
    Decimal total = Decimal.zero;
    String op = "+";
    for (String str in _feeState.inputData) {
      if (str == "-" || str == "+") {
        op = str;
      } else {
        total = total + Decimal.parse("$op$str");
      }
    }
  }
}
