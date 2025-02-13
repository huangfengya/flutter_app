import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/fee/feeProvider.dart';
import 'package:flutter_app/sql/index.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CustomKeyboard extends StatefulWidget {
  final double _keyboardHeight;
  const CustomKeyboard(this._keyboardHeight, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _CustomKeyboard();
  }
}

class _CustomKeyboard extends State<CustomKeyboard> {
  @override
  void initState() {
    handleInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isShowKeyboard = widget._keyboardHeight > 0;

    return Container(
        padding: EdgeInsets.only(
          top: isShowKeyboard ? widget._keyboardHeight : 70,
        ),
        height: 335,
        width: double.infinity,
        color: Colors.white,
        child: isShowKeyboard ? null : _keyboardPan());
  }

  Widget _keyboardPan() {
    List<List<String>> _child = [
      ['1', '2', '3', 'calendar'],
      ['4', '5', '6', 'add'],
      ['7', '8', '9', 'minus'],
      ['.', '0', 'backspace', 'done']
    ];

    return Column(
      children: _child
          .asMap()
          .entries
          .map(
            (row) => Expanded(
              child: Row(
                children: row.value.map(
                  (val) {
                    return Expanded(
                      child: KeyItem(val, row.key),
                    );
                  },
                ).toList(),
              ),
            ),
          )
          .toList(),
    );
  }
}

class KeyItem extends StatefulWidget {
  final int rowIdx;
  final String currKey;
  const KeyItem(this.currKey, this.rowIdx, {super.key});

  @override
  State<StatefulWidget> createState() => _KeyItem();
}

class _KeyItem extends State<KeyItem> {
  Timer? _activeTimer;
  bool _activeStatus = false;

  @override
  Widget build(BuildContext context) {
    int rowIdx = widget.rowIdx;
    String currKey = widget.currKey;

    BorderSide borderSide = BorderSide(color: Colors.grey.shade200, width: 1);
    BoxDecoration boxDecoration = BoxDecoration(
      border: Border(
        top: rowIdx == 0 ? borderSide : BorderSide.none,
        right: borderSide,
        bottom: borderSide,
      ),
      color: _activeStatus
          ? Colors.green
          : currKey != 'done'
              ? null
              : Colors.lightGreen.shade100,
    );
    TextStyle textStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(206, 61, 182, 1),
    );
    Map<String, IconData> iconMap = {
      'done': Icons.done_all,
      'calendar': Icons.calendar_month_outlined,
      'add': Icons.add,
      'minus': Icons.remove,
      'backspace': Icons.backspace
    };
    RegExp numberReg = RegExp(r'^\d|\.$');

    Container container;
    if (numberReg.hasMatch(currKey)) {
      container = Container(
        height: double.infinity,
        decoration: boxDecoration,
        child: Center(
          child: Text(
            currKey,
            style: textStyle,
          ),
        ),
      );
    } else if (currKey == "calendar") {
      FeeState provider = Provider.of<FeeState>(context);
      DateTime? selectedDate = provider.selectedDate;
      if (selectedDate == null) {
        container = Container(
          height: double.infinity,
          decoration: boxDecoration,
          child: Center(
            child: Icon(iconMap[currKey]),
          ),
        );
      } else {
        container = Container(
          height: double.infinity,
          decoration: boxDecoration,
          child: Center(
            child: Text(
              "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}",
              style: TextStyle(fontSize: 10),
            ),
          ),
        );
      }
    } else {
      container = Container(
        height: double.infinity,
        decoration: boxDecoration,
        child: Center(
          child: Icon(iconMap[currKey]),
        ),
      );
    }

    return GestureDetector(
      onPanDown: (_) {
        _activeTimer?.cancel();
        HapticFeedback.mediumImpact();
        setState(() {
          _activeStatus = true;
        });
      },
      onPanEnd: (_) {
        _activeTimer = Timer(const Duration(milliseconds: 100), () {
          setState(() {
            _activeStatus = false;
          });
        });
        panDown(context, currKey);
      },
      child: container,
    );
  }

  void panDown(BuildContext context, String key) {
    String? last = _inputData.lastOrNull;
    FeeState provider = Provider.of<FeeState>(context, listen: false);

    // 键盘输入处理函数
    if (key == 'done') {
      if (provider.calcPrice == '0') {
        Navigator.pop(context);
        return;
      }
      if (provider.selectItem < 0) {
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                content: const Text("尚未选择类型哦~"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("确定"),
                  )
                ],
              );
            });
        return;
      }
      Provider.of<DataBaseProvider>(context, listen: false)
          .addAccountItem(AccountItemsParams(
        type: '${provider.feeType}',
        notes: provider.notes,
        dateTime: DateFormat('yyyy/MM/dd')
            .format(provider.selectedDate ?? DateTime.now()),
        price: provider.calcPrice,
        subtype: '${provider.selectItem}',
      ))
          .then((_) {
        print('add accountItems: success');
        Navigator.pop(context);
      }).catchError((error) {
        print("add accountItems: error; reason: $error");
      });
      return;
      // 输入完成，应该关闭当前页面
    } else if (key == 'calendar') {
      _selectDate(context);
      return;
    } else if (key == 'backspace') {
      handleBackspace(last);
    } else if (key == 'add' || key == 'minus') {
      handleOperator(last, key);
    } else if (key == '.') {
      handleDot(last);
    } else {
      handleNumber(last, key);
    }

    print('input: $_inputData;  total: ${calcTotalPrice()}');
    provider.modifyFees(
      _inputData,
      calcTotalPrice(),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
      cancelText: "取消",
      confirmText: "确定",
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    FeeState provider = Provider.of<FeeState>(context, listen: false);
    if (picked != provider.selectedDate) {
      provider.modifySelectedDate(picked);
    }
  }
}

List<String> _inputData = [];
RegExp lastIsNum = RegExp(r'\d$');
RegExp lastIsDot = RegExp(r'\.$');
RegExp lastIsOp = RegExp(r'^[+-]$');

void handleInit() {
  _inputData = [];
}

String calcTotalPrice() {
  List<String> cpList = List.from(_inputData);
  String? last = cpList.lastOrNull;
  if (last != null && (last == '-' || last == '+')) {
    cpList.removeLast();
  }
  Decimal total = Decimal.zero;
  String op = "+";
  for (String str in _inputData) {
    if (str == "-" || str == "+") {
      op = str;
    } else {
      total = total + Decimal.parse("$op$str");
    }
  }
  return total.toString();
}

void handleBackspace(String? last) {
  if (last == null) {
    return;
  }

  if (lastIsOp.hasMatch(last)) {
    _inputData.removeLast();
  } else if (lastIsDot.hasMatch(last) || lastIsNum.hasMatch(last)) {
    String nlast = last.substring(0, last.length - 1);
    if (nlast.isNotEmpty) {
      _inputData.last = nlast;
    } else {
      _inputData.removeLast();
    }
  }
}

void handleOperator(String? last, String key) {
  if (last == null) {
    return;
  }

  String operator = key == 'add' ? '+' : '-';
  if (lastIsNum.hasMatch(last)) {
    _inputData.add(operator);
  } else if (lastIsDot.hasMatch(last)) {
    _inputData.last = last.substring(0, last.length - 1);
    _inputData.add(operator);
  } else if (lastIsOp.hasMatch(last)) {
    _inputData.last = operator;
  }
}

void handleDot(String? last) {
  if (last == null) {
    return;
  }

  if (lastIsNum.hasMatch(last) && !last.contains('.')) {
    _inputData.last = '$last.';
  }
}

void handleNumber(String? last, String key) {
  if (last == null) {
    _inputData.add(key);
    return;
  }

  if (lastIsOp.hasMatch(last)) {
    _inputData.add(key);
    return;
  }
  String nlast = '$last$key';
  if (lastIsDot.hasMatch(last)) {
    _inputData.last = nlast;
  } else if (lastIsNum.hasMatch(last)) {
    if (last == '0') {
      _inputData.last = key;
    } else {
      List<String> lastList = nlast.split('.');
      if (lastList.length == 2) {
        if (lastList[1].length <= 2) {
          _inputData.last = nlast;
        }
        return;
      }
      if (last.length < 8) {
        _inputData.last = nlast;
      }
    }
  }
}
