import 'package:flutter/material.dart';
import 'package:flutter_app/common/icons.dart';
import 'package:flutter_app/common/utils.dart';
import 'package:flutter_app/components/circularProgress/index.dart';
import 'package:flutter_app/pages/home/components/header/index.dart';

var data = [
  {
    "date": "2021-12-01",
    "values": [
      {
        "type": "add",
        "value": 100.32,
        "category": "工资",
        "icon": "wallet_giftcard"
      },
      {
        "type": "sub",
        "value": 100.32,
        "category": "餐饮",
        "icon": "food_bank_outlined"
      },
    ]
  },
  {
    "date": "2023-12-01",
    "values": [
      {
        "type": "sub",
        "value": 10,
        "category": "餐饮",
        "icon": "food_bank_outlined"
      },
      {
        "type": "sub",
        "value": 999,
        "category": "烟酒",
        "icon": "all_inclusive_outlined"
      },
      {
        "type": "sub",
        "value": 1011,
        "category": "其他",
        "icon": "ssid_chart_outlined"
      },
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
      margin: const EdgeInsets.only(left: 15, right: 15),
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
            const SizedBox(height: 15),
            Expanded(
              child: CustomScrollView(
                controller: scrollController,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(scrollViewItem(data)),
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

List<Widget> scrollViewItem(List<Map<String, dynamic>> data) {
  List<Widget> items = [];
  const TextStyle titleStyle = TextStyle(
    fontSize: 10,
    color: Color(0xaa000000),
  );
  for (int i = 0; i < data.length; i++) {
    var item = data[i];
    Widget title = Container(
      height: 30,
      padding: i == 0 ? null : const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: i == 0
            ? null
            : Border(top: BorderSide(color: Colors.grey.shade400)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                item["date"],
                style: titleStyle,
              ),
              const SizedBox(width: 15),
              Text(
                getDayofWeekFromDate(item["date"]),
                style: titleStyle,
              )
            ],
          ),
          Row(children: [
            Offstage(
              child: Text(
                "收入：12313元",
                style: titleStyle,
              ),
              offstage: false,
            ),
            Offstage(
              child: SizedBox(width: 15),
              offstage: false,
            ),
            Offstage(
              child: Text(
                "支出：-34343元",
                style: titleStyle,
              ),
              offstage: false,
            ),
          ])
        ],
      ),
    );
    items.add(title);
    List<Map<String, dynamic>> values = item["values"];
    for (int j = 0; j < values.length; j++) {
      var val = values[j];
      Widget detail = SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                iconMapping[val["icon"]] as Widget,
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: i != data.length - 1 && j == data.length - 1
                      ? null
                      : Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(val["category"]),
                    Text("${val["type"] == "add" ? "+" : "-"} ${val["value"]}")
                  ],
                ),
              ),
            )
          ],
        ),
      );
      items.add(detail);
    }
  }

  return items;
}

class MonthTotal extends StatelessWidget {
  const MonthTotal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
