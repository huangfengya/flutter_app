import 'package:flutter/material.dart';
import 'package:flutter_app/sql/index.dart';

import "package:provider/provider.dart";
import 'package:flutter_app/pages/fee/feeProvider.dart';

import 'package:flutter_app/pages/fee/up/index.dart';
import 'package:flutter_app/pages/fee/down/custom_keyboard.dart';
import 'package:flutter_app/pages/fee/down/input_data.dart';

class Fee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FeeState()),
        ChangeNotifierProvider(create: (_) => DataBaseProvider())
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        UpScreen(_keyboardHeight),
                        if (_keyboardHeight == 0)
                          CustomKeyboard(_keyboardHeight)
                      ],
                    ),
                    if (_keyboardHeight > 0) InputDataMask(),
                    InputData(_keyboardHeight),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
