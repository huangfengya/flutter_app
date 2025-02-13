import 'package:flutter/material.dart';

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
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: SizedBox(
              width: 250,
              child: TabBar(
                controller: tabController,
                indicator: const UnderlineTabIndicator(
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
      child: SizedBox(
        width: double.infinity,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
