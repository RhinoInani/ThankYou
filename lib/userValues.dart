import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'userValues.g.dart';

const kBlackColor = Color(0xFF393939);
const kLightBlackColor = Color(0xFF8F8F8F);

//user lists to build and store with
List<String> location = [];
List<String> amount = [];
List<String> date = [];
List<String> itemDescription = [];
List<String> item = []; //uses 0 and 1 so that it can be saved properly

List<DataRow> data = List.generate(
  location.length - 1,
  (index) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            location[index],
          ),
        ),
        DataCell(
          Text(
            amount[index].toString(),
          ),
        ),
        DataCell(
          Text(
            date[index],
          ),
        ),
      ],
    );
  },
  growable: true,
);

Future<void> setLocalData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('location', location);
  prefs.setStringList('date', date);
  prefs.setStringList('amount', amount);
  prefs.setStringList("item", item);
}

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
