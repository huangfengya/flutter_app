import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/eventBus.dart';

import "package:decimal/decimal.dart";

EventBus eventBus = EventBus();

class TransEvent {
  String text;
  String calcPrice;
  TransEvent(this.text, this.calcPrice);
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

class Fee extends StatefulWidget {
  const Fee({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Fee();
  }
}

class _Fee extends State<Fee> {
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

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
                  left: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              InputData(_keyboardHeight, _focusNode),
            ],
          ),
        ),
      ),
    );
  }
}

class InputData extends StatefulWidget {
  final double _keyboardHeight;
  final FocusNode _focusNode;

  const InputData(this._keyboardHeight, this._focusNode, {super.key});

  @override
  State<StatefulWidget> createState() => _InputData();
}

class _InputData extends State<InputData> {
  String fees = '';
  String calcPrice = '';

  @override
  void initState() {
    eventBus.on<TransEvent>().listen((TransEvent data) {
      setState(() {
        fees = data.text;
        calcPrice = data.calcPrice;
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
      bottom: isShowKeyboard ? widget._keyboardHeight : 230,
      right: 0,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            height: 35,
            width: double.infinity,
            color: Colors.red.shade50,
            child: ScrollableText(fees),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            width: double.infinity,
            color: Colors.amberAccent,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Container(
                  width: 190,
                  child: Row(
                    children: [
                      Text(
                        "备注",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        // child: Text(
                        //   "奥赛减法囧定了发空扥就阿塞阀阿塞阀安抚",
                        //   overflow: TextOverflow.ellipsis,
                        //   style: TextStyle(
                        //       fontSize: 15, color: Colors.blueGrey.shade500),
                        // ),
                        child: Container(
                          padding: EdgeInsets.zero,
                          child: TextField(
                            maxLines: 1,
                            minLines: 1,
                            focusNode: widget._focusNode,
                            onChanged: (value) {
                              print("value$value");
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    calcPrice,
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ScrollableText extends StatefulWidget {
  final String _text;
  const ScrollableText(this._text, {super.key});

  @override
  State<StatefulWidget> createState() => _ScrollableText();
}

class _ScrollableText extends State<ScrollableText> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToRight());
  }

  @override
  void didUpdateWidget(covariant ScrollableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._text != widget._text) {
      _scrollToRight();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToRight() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            widget._text,
            style: TextStyle(fontSize: 16),
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
      handleBackspace(last);
    } else if (key == 'add' || key == 'minus') {
      handleOperator(last, key);
    } else if (key == '.') {
      handleDot(last);
    } else {
      handleNumber(last, key);
    }

    print('input: $_inputData;  total: ${calcTotalPrice()}');
    eventBus.fire(TransEvent(_inputData.join(" "), calcTotalPrice()));
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
      print(lastList.length);
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
