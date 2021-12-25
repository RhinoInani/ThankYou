import 'package:flutter/material.dart';

import '../userValues.dart';

class UnboldBoldText extends StatelessWidget {
  const UnboldBoldText({
    Key? key,
    required this.unbold,
    required this.bold,
    required this.color,
  }) : super(key: key);

  final String unbold;
  final String bold;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsets.all(size.height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "$unbold",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: size.width * 0.043,
                color: kLightBlackColor.withBlue(kLightBlackColor.blue + 15),
              ),
            ),
            Text(
              "$bold",
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: size.width * 0.043,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        )

        //RichText(
        //         text: TextSpan(
        //           style: TextStyle(
        //             fontSize: size.width * 0.043,
        //             color: kLightBlackColor.withBlue(kLightBlackColor.blue + 15),
        //           ),
        //           children: [
        //             TextSpan(text: "$unbold"),
        //             TextSpan(
        //               text: "$bold",
        //               style: TextStyle(fontWeight: FontWeight.w600, color: color),
        //             ),
        //           ],
        //         ),
        //       ),
        );
  }
}
