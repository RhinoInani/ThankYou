import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'userValues.g.dart';

const kBlackColor = Color(0xFF393939);
const kLightBlackColor = Color(0xFF8F8F8F);
const mainGreen = Color.fromRGBO(193, 225, 193, 1);
const mainBlue = Color.fromRGBO(174, 213, 244, 1);

//counter
double userCounter = 0;

//DO NOT ALTER CODE UNDER THIS LINE
//if you do run: flutter packages pub run build_runner build

@HiveType(typeId: 2)
class Item extends HiveObject {
  @HiveField(0)
  String? recipient;

  @HiveField(1)
  double? amount;

  @HiveField(2)
  DateTime? date;

  @HiveField(3)
  String? item;

  @HiveField(4)
  bool? isMoney;

  @HiveField(5)
  String? uuid;

  Item(
    this.recipient,
    this.item,
    this.amount,
    this.date,
    this.isMoney,
    this.uuid,
  );
}