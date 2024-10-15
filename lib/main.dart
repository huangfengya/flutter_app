import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/components/bottomTab/index.dart';

void main() => runApp(const FlutterApp());

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    // debugPaintSizeEnabled = true;
    return const MaterialApp(
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
        ),
        child: BottomTab(),
      ),
    );
  }
}
