import 'package:flutter/material.dart';
import 'package:flutter_app/common/icons.dart';

class ConsumeIconItem {
  final String label;
  final Widget icon;

  ConsumeIconItem({required this.label, required this.icon});
}

List<ConsumeIconItem> consumeIconList = [
  ConsumeIconItem(label: "购物", icon: shoppingIcon),
  ConsumeIconItem(label: "游戏", icon: gameIcon),
  ConsumeIconItem(label: "幼儿", icon: babyIcon),
  ConsumeIconItem(label: "话费", icon: phoneIcon),
  ConsumeIconItem(label: "学习", icon: learnIcon),
  ConsumeIconItem(label: "餐饮", icon: foodIcon),
  ConsumeIconItem(label: "房租", icon: homeIcon),
  ConsumeIconItem(label: "交通", icon: jiaotongIcon),
  ConsumeIconItem(label: "礼物", icon: giftIcon),
  ConsumeIconItem(label: "烟酒", icon: yanjiuIcon),
  ConsumeIconItem(label: "家庭", icon: familyIcon),
  ConsumeIconItem(label: "视频", icon: videoIcon),
  ConsumeIconItem(label: "医疗", icon: hospitalIcon),
  ConsumeIconItem(label: "设置", icon: settingIcon),
];

List<ConsumeIconItem> incomeIconList = [
  ConsumeIconItem(label: "幼儿", icon: babyIcon),
  ConsumeIconItem(label: "话费", icon: phoneIcon),
  ConsumeIconItem(label: "学习", icon: learnIcon),
  ConsumeIconItem(label: "餐饮", icon: foodIcon),
  ConsumeIconItem(label: "房租", icon: homeIcon),
  ConsumeIconItem(label: "交通", icon: jiaotongIcon),
];
