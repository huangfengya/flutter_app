import 'package:flutter/material.dart';
import 'package:flutter_app/pages/fee/feeProvider.dart';
import 'package:provider/provider.dart';

class InputDataMask extends StatelessWidget {
  const InputDataMask({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.blueGrey.withAlpha(100),
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
    bool isShowKeyboard = widget._keyboardHeight > 0;
    return Positioned(
      left: 0,
      bottom: isShowKeyboard ? widget._keyboardHeight : 265,
      right: 0,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            height: 35,
            width: double.infinity,
            color: Colors.red.shade50,
            child: Consumer<FeeState>(
                builder: (context, provider, child) =>
                    ScrollableText(provider.inputData.join(" "))),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            width: double.infinity,
            height: 35,
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
                        child: Container(
                          padding: EdgeInsets.zero,
                          child: TextField(
                            maxLines: 1,
                            minLines: 1,
                            focusNode: _focusNode,
                            onChanged: (value) {
                              Provider.of<FeeState>(context, listen: false)
                                  .modifyNotes(value);
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
                  child: Consumer<FeeState>(
                    builder: (context, provider, child) => Text(
                      provider.calcPrice,
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.right,
                    ),
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
