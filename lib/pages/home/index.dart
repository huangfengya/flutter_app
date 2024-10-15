import 'package:flutter/material.dart';
import 'package:flutter_app/components/circularProgress/index.dart';
import 'package:flutter_app/pages/home/components/header/index.dart';

var data = [
  {
    "title": "2021.12.1",
    "data": [
      {"a": 12, "b": 13}
    ]
  },
  {
    "type": "date",
    "title": "2021.12.1",
    "data": [
      {"a": 12, "b": 13}
    ]
  }
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      // scroll
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 0.5,
          stops: [0, 0.6, 0.8, 1],
          colors: [
            Color(0xFFFFF4C9),
            Color(0xF0FFF4C9),
            Color(0xA0FFF4C9),
            Color(0x00FFF4C9),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            HomeHeader(),
            const MonthTotal(),
            const SizedBox(height: 20),
            Expanded(
              child: CustomScrollView(
                controller: scrollController,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index.isEven) {
                          return Container(
                            color: Colors.grey[300],
                            height: 40,
                            alignment: Alignment.center,
                            child: Text('Group ${index ~/ 2 + 1} Header'),
                          );
                        } else {
                          return ListTile(
                            title: Text('Item $index'),
                          );
                        }
                      },
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthTotal extends StatelessWidget {
  const MonthTotal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Color(0x28333333),
              offset: Offset(0, 2),
              blurRadius: 10,
              spreadRadius: 0,
            )
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "10月份支出",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '0.0',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  CustomPaint(
                    painter: CircularProgressPainter(
                      progress: -0.45,
                      strokeWidth: 3,
                    ),
                    size: const Size(50, 50),
                  ),
                  const Column(
                    children: [
                      Text(
                        "45%",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          height: 1,
                        ),
                      ),
                      Text(
                        "预算剩余",
                        style: TextStyle(color: Colors.grey, fontSize: 8),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Text(
                  "支出",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 5),
                Text('0.0'),
              ]),
              Row(children: [
                Text(
                  "支出",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 5),
                Text('0.0'),
              ])
            ],
          ),
        ],
      ),
    );
  }
}
