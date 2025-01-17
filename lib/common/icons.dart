import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 箭头
final Widget downIcon = SvgPicture.asset(
  'assets/icons/down.svg',
  semanticsLabel: "向下箭头",
);

final Widget upIcon = SvgPicture.asset(
  'assets/icons/up.svg',
  semanticsLabel: "向上箭头",
);

final Widget leftIcon = SvgPicture.asset(
  'assets/icons/left.svg',
  semanticsLabel: "向左箭头",
);

final Widget rightIcon = SvgPicture.asset(
  'assets/icons/right.svg',
  semanticsLabel: "向右箭头",
);

final Widget doubleDownIcon = SvgPicture.asset(
  'assets/icons/duo_down.svg',
  semanticsLabel: "双向下箭头",
);

final Widget doubleUpIcon = SvgPicture.asset(
  'assets/icons/duo_up.svg',
  semanticsLabel: "双向上箭头",
);

// 消费
final Widget catering = SvgPicture.asset(
  'assets/icons/catering.svg',
  semanticsLabel: "餐饮",
  width: 20,
  height: 20,
);

final Widget shoppingIcon =
    SvgPicture.asset('assets/icons/gouwu.svg', semanticsLabel: "购物");

final Widget gameIcon =
    SvgPicture.asset('assets/icons/game.svg', semanticsLabel: "游戏");

final Widget settingIcon =
    SvgPicture.asset('assets/icons/shezhi.svg', semanticsLabel: "设置");

final Widget babyIcon =
    SvgPicture.asset('assets/icons/haizi.svg', semanticsLabel: "幼儿");

final Widget phoneIcon =
    SvgPicture.asset('assets/icons/shouji.svg', semanticsLabel: "话费");

final Widget learnIcon =
    SvgPicture.asset('assets/icons/shuben.svg', semanticsLabel: "学习");

final Widget foodIcon =
    SvgPicture.asset('assets/icons/huanqiuyinshi.svg', semanticsLabel: "餐饮");

final Widget homeIcon =
    SvgPicture.asset('assets/icons/bianzu2.svg', semanticsLabel: "房租");

final Widget jiaotongIcon =
    SvgPicture.asset('assets/icons/jiaotong.svg', semanticsLabel: "交通");

final Widget giftIcon =
    SvgPicture.asset('assets/icons/liwu.svg', semanticsLabel: "礼物");

final Widget yanjiuIcon =
    SvgPicture.asset('assets/icons/yanjiu.svg', semanticsLabel: "烟酒");

final Widget familyIcon =
    SvgPicture.asset('assets/icons/jiaren.svg', semanticsLabel: "家庭");

final Widget videoIcon =
    SvgPicture.asset('assets/icons/shipin.svg', semanticsLabel: "视频");

final Widget hospitalIcon =
    SvgPicture.asset('assets/icons/jijiu.svg', semanticsLabel: "医疗");

// ----------- line ---------------------
Map<String, Widget> iconMapping = {
  "wallet_giftcard": catering,
  "food_bank_outlined": catering,
  "all_inclusive_outlined": catering,
  "ssid_chart_outlined": catering
};
