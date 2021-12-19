import 'package:flutter/material.dart';

import '../../userValues.dart';

class UnboldBoldText extends StatelessWidget {
  const UnboldBoldText({
    Key? key,
    required this.size,
    required this.unbold,
    required this.bold,
    required this.color,
  }) : super(key: key);

  final Size size;
  final String unbold;
  final String bold;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size.height * 0.01),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: size.width * 0.043,
            color: kLightBlackColor.withBlue(kLightBlackColor.blue + 15),
          ),
          children: [
            TextSpan(text: "$unbold"),
            TextSpan(
              text: "$bold",
              style: TextStyle(fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
