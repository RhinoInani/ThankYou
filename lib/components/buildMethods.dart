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

ButtonStyle setButtonStyle() {
  return ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    primary: mainGreen.withGreen(mainGreen.green + 8),
  );
}

String dateFormat(DateTime date) {
  return "${DateFormat.yMd(Platform.localeName).format(date)}";
}
