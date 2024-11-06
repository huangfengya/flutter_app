import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/eventBus.dart';

EventBus eventBus = EventBus();

class TransEvent {
  String text;
  TransEvent(this.text);
}

class SlideUpPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  SlideUpPageRoute({required this.builder}) : super();

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get opaque => false;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }
}

class Fee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Text('up screen'),
                      ),
                    ),
                  ),
                  if (_keyboardHeight == 0) CustomKeyboard(_keyboardHeight),
                ],
              ),
              if (_keyboardHeight > 0)
                Positioned(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.blueGrey,
                  ),
                  left: 0,
                  top: 0,
                ),
              InputData(_keyboardHeight),
            ],
          ),
        ),
      ),
    );
  }
}

class InputData extends StatefulWidget {
  final double _keyboardHeight;

  const InputData(this._keyboardHeight, {super.key});

  @override
  State<StatefulWidget> createState() => _InputData();
}

class _InputData extends State<InputData> {
  String fees = '';

  @override
  void initState() {
    eventBus.on<TransEvent>().listen((TransEvent data) {
      setState(() {
        fees = data.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    eventBus.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isShowKeyboard = widget._keyboardHeight > 0;
    return Positioned(
      left: 0,
      bottom: isShowKeyboard ? widget._keyboardHeight : 240,
      right: 0,
      child: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.red.shade50,
            child: Text(
              fees,
              style: const TextStyle(),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            height: 40,
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  "备注:",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomKeyboard extends StatefulWidget {
  final double _keyboardHeight;
  const CustomKeyboard(this._keyboardHeight, {super.key});

  @override
  State<StatefulWidget> createState() => _CustomKeyboard();
}

class _CustomKeyboard extends State<CustomKeyboard> {
  @override
  Widget build(BuildContext context) {
    bool isShowKeyboard = widget._keyboardHeight > 0;

    return Container(
        padding: EdgeInsets.only(
          top: isShowKeyboard ? widget._keyboardHeight : 100,
        ),
        height: 330,
        width: double.infinity,
        color: Colors.white,
        child: isShowKeyboard ? null : _keyboardPan());
  }

  Widget _keyboardPan() {
    List<List<String>> _child = [
      ['1', '2', '3', 'calendar'],
      ['4', '5', '6', 'add'],
      ['7', '8', '9', 'remove'],
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

List<String> _inputData = [];

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
      'remove': Icons.remove,
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
      onTapDown: (_) {
        _activeTimer?.cancel();
        HapticFeedback.mediumImpact();
        setState(() {
          _activeStatus = true;
        });
      },
      onTapUp: (_) {
        _activeTimer = Timer(const Duration(milliseconds: 100), () {
          setState(() {
            _activeStatus = false;
          });
        });
        panDown(currKey);
      },
      child: container,
    );
  }

  void panDown(String key) {
    String? last = _inputData.lastOrNull;
    // 键盘输入处理函数
    if (key == 'done') {
      // 输入完成，应该关闭当前页面
    } else if (key == 'calendar') {
    } else if (key == 'backspace') {
      if (last != null) {
        String nLast = last.substring(0, last.length - 1);
        if (nLast.isNotEmpty) {
          modifyLastEle(nLast);
        } else {
          _inputData.removeLast();
        }
      }
    } else if (key == 'add') {
      if (last == '-' || last == '.') {
        modifyLastEle('+');
      } else if (last != null && last != '+') {
        addEle('+');
      }
    } else if (key == 'remove') {
      if (last == '+' || last == '.') {
        modifyLastEle('-');
      } else if (last != null && last != '-') {
        addEle('-');
      }
    } else if (key == '.') {
      if (last != null && !last.contains('.')) {
        modifyLastEle('$last.');
      }
    } else {
      if (last == null || last == '-' || last == '+') {
        _inputData.add(key);
      } else {
        // 这儿是数字哦
        // 最多两位小数，最大值为 99999999.99
        List<String> lastList = last.split('.');
        String next = '$last$key';
        if ((lastList[1].isEmpty || lastList[1].length < 2) &&
            double.parse(next) < 1e8) {
          modifyLastEle(next);
        }
      }
    }
    print('input: $_inputData');
    eventBus.fire(TransEvent(_inputData.join(" ")));
  }

  void addEle(String key) {
    _inputData.add(key);
  }

  void modifyLastEle(String key) {
    if (_inputData.isNotEmpty) {
      _inputData[_inputData.length - 1] = key;
    } else {
      _inputData.add(key);
    }
  }
}
