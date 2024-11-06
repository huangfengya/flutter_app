import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  'assets/icons/down.svg',
  semanticsLabel: "双向下箭头",
);

final Widget doubleUpIcon = SvgPicture.asset(
  'assets/icons/up.svg',
  semanticsLabel: "双向上箭头",
);

final Widget catering = SvgPicture.asset(
  'assets/icons/catering.svg',
  semanticsLabel: "餐饮",
  width: 20,
  height: 20,
);

Map<String, Widget> iconMapping = {
  "wallet_giftcard": catering,
  "food_bank_outlined": catering,
  "all_inclusive_outlined": catering,
  "ssid_chart_outlined": catering
};
