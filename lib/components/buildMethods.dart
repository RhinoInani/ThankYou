import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../userValues.dart';

//function to set the donations to the value donated and also set the remainder balance to the proper locations
Future<bool> setDonations() async {
  try {
    Box userValues = Hive.box('userValues');
    remainder = target - donated;
    await userValues.put('donated', donated);
    return true;
  } catch (err) {
    return false;
  }
}

ButtonStyle setGreenButtonStyle() {
  return ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    primary: mainGreen.withGreen(mainGreen.green + 8),
  );
}

ButtonStyle setBlueButtonStyle() {
  return ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    primary: Color(0xff97d6e5),
  );
}

String dateFormat(DateTime date) {
  return "${DateFormat.yMd(Platform.localeName).format(date)}";
}

List itemToList(Item item) {
  //THE LIST IS IN THIS ORDER
  //"Type", "Date", "Recipient", "Amount", "Item", "Notes", "UUID",

  return [
    "${item.isMoney! ? "Money" : "Item"}",
    "${dateFormat(item.date!)}",
    "${item.recipient!}",
    "${moneyFormat.currencySymbol}${item.amount!.toStringAsFixed(2)}",
    "${item.isMoney! ? "None" : "${item.item!}"}",
    "${item.notes!}",
    "${item.uuid}",
  ];
}
