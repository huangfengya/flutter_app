import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Tabs extends StatelessWidget {
  final TabController tabController;
  const Tabs({required this.tabController, super.key});

  @override
  Widget build(BuildContext context) {
    double safeTop = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      height: 50 + safeTop,
      padding: EdgeInsets.only(top: safeTop),
      decoration: BoxDecoration(color: Colors.pinkAccent.shade100),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // 返回按钮点击事件
              },
            ),
            left: 10,
          ),
          Center(
            child: Container(
              width: 250,
              child: TabBar(
                controller: tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.red, width: 4),
                ),
                labelColor: Colors.white,
                tabs: [
                  _tabItem('支出'),
                  _tabItem('收入'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabItem(String title) {
    return Tab(
      child: Container(
        width: double.infinity,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
