import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/fee/feeProvider.dart';
import 'package:flutter_app/pages/fee/up/consume_icon.dart';
import 'package:flutter_app/pages/fee/up/tabs.dart';
import 'package:provider/provider.dart';

class UpScreen extends StatefulWidget {
  final double _keyboardHeight;
  const UpScreen(this._keyboardHeight, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _UpScreen();
  }
}

class _UpScreen extends State<UpScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      FeeState provider = Provider.of<FeeState>(context, listen: false);
      provider.modifySelectItem(-1);
      provider.modifyFeeType(_tabController.index);
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);
    double height = mq.size.height -
        mq.padding.top -
        mq.padding.bottom -
        50 -
        (widget._keyboardHeight == 0 ? 335 : widget._keyboardHeight);
    return Column(
      children: [
        Tabs(tabController: _tabController),
        Container(
          height: height,
          child: TabBarView(
            controller: _tabController,
            children: [
              _gridView(consumeIconList),
              _gridView(incomeIconList),
            ],
          ),
        )
      ],
    );
  }

  Widget _gridView(List<ConsumeIconItem> list) {
    return Container(
      decoration: BoxDecoration(color: Colors.amber),
      child: GridView.builder(
        padding: EdgeInsets.only(left: 25, right: 25, top: 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          return _items(index, list[index]);
        },
        itemCount: list.length,
      ),
    );
  }

  Widget _items(int index, ConsumeIconItem item) {
    ConsumeIconItem item = consumeIconList[index];
    return Consumer<FeeState>(
      builder: (context, provider, child) => GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          provider.modifySelectItem(index);
        },
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: provider.selectItem != index
                ? Colors.red.shade100
                : Colors.red.shade500,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 35,
                height: 35,
                child: item.icon,
              ),
              Text(item.label),
            ],
          ),
        ),
      ),
    );
  }
}
