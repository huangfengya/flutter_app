import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/index.dart';
import 'package:flutter_app/pages/my/index.dart';
import 'package:flutter_app/pages/property/index.dart';
import 'package:flutter_app/pages/report/index.dart';

class BottomTab extends StatefulWidget {
  const BottomTab({super.key});

  @override
  State<BottomTab> createState() => _BottomTab();
}

class _BottomTab extends State<BottomTab> {
  int _selectedIndex = 0;

  final pages = const <Widget>[Home(), Property(), Report(), My()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        mini: true,
        shape: const CircleBorder(),
        splashColor: Colors.transparent,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // 凹槽设置
        notchMargin: 0.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _tabItem(0, "首页", Icons.home),
            _tabItem(1, "资产", Icons.wallet),
            const SizedBox(width: 30),
            _tabItem(2, "图表", Icons.pie_chart),
            _tabItem(3, "我的", Icons.person),
          ],
        ),
      ),
      body: pages[_selectedIndex],
    );
  }

  _tabItem(int index, String label, IconData icon) {
    final bool selected = index == _selectedIndex;
    Widget item = Column(children: [
      Icon(icon, color: selected ? Colors.blue : Colors.grey),
      const SizedBox(
        height: 2,
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: selected ? Colors.blue : Colors.grey,
        ),
      )
    ]);

    return Expanded(
      flex: 1,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          if (!selected) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        child: item,
      ),
    );
  }
}
