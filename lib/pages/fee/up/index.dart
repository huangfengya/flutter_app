import 'package:flutter/material.dart';

class UpScreen extends StatefulWidget {
  const UpScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UpScreen();
  }
}

class _UpScreen extends State<UpScreen> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _items(index);
      },
    );
  }

  Widget _items(int index) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular()),
    );
  }
}
