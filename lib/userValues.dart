import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart';

part 'userValues.g.dart';

//CONSTANTS DO NOT EDIT
const kBlackColor = Color(0xFF393939);
const kLightBlackColor = Color(0xFF8F8F8F);
const mainGreen = Color.fromRGBO(193, 225, 193, 1);
const mainBlue = Color.fromRGBO(174, 213, 244, 1);
const mainRed = Color.fromRGBO(253, 111, 115, 1.0);

double target = 0.00;
double remainder = 0.00;
double donated = 0.00;
bool firstTime = true;
bool goalsSet = false;
int compression = 75;

// String locale = "";
// try { locale = ; } catch (e){
//   locale = "US";
// }
String localeMain = Platform.localeName.toString();
var moneyFormat = NumberFormat.simpleCurrency(locale: localeMain);
String currency = "${moneyFormat.currencySymbol}";

Item? editItem;

///DO NOT ALTER CODE UNDER THIS LINE
///if you do run: flutter packages pub run build_runner build

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

  @HiveField(6)
  String? notes;

  @HiveField(7)
  String? imagePath;

  Item(
    this.recipient,
    this.item,
    this.amount,
    this.date,
    this.isMoney,
    this.uuid,
    this.notes,
    this.imagePath,
  );
}
