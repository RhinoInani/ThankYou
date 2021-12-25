import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../newDonation.dart';
import '../userValues.dart';

void setGoals(context, TextEditingController controller, Box userValues) {
  Size size = MediaQuery.of(context).size;
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: size.height * 0.6,
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Set your goals"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DonationsTextField(
                  textController: controller,
                  isAmount: true,
                  text: 'Set a Target Amount',
                  isTarget: true,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  target =
                      double.parse(controller.value.text.replaceAll(',', ''));
                  await userValues.put('target', target);
                  await setDonations();
                  goalsSet = true;
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Set",
                  style: TextStyle(color: kBlackColor),
                ),
                style: setButtonStyle(),
              )
            ],
          ),
        ),
      );
    },
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    elevation: 15,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MediaQuery.of(context).size.height * 0.02),
          topRight: Radius.circular(MediaQuery.of(context).size.height * 0.02)),
    ),
  );
}

ButtonStyle setButtonStyle() {
  return ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    primary: mainGreen.withGreen(mainGreen.green + 8),
  );
}

String dateFormat(DateTime date) {
  return "${DateFormat.yMd().format(date)}";
}
