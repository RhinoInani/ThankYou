import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thank_you/userValues.dart';

class RecentDonationsCard extends StatelessWidget {
  const RecentDonationsCard({
    Key? key,
    required this.recipient,
    required this.amount,
    required this.date,
    required this.isMoney,
    required this.item,
  }) : super(key: key);

  final String recipient;
  final String amount;
  final DateTime date;
  final bool isMoney;
  final String item;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.02,
        horizontal: size.width * 0.06,
      ),
      width: size.width * 0.85,
      decoration: BoxDecoration(
        color: !isMoney ? mainBlue : mainGreen,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 7),
            blurRadius: 5,
            color: Colors.grey[300]!,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.8,
            child: Stack(
              children: [
                Positioned(
                  left: size.width * 0.5,
                  child: Container(
                    child: Text(
                      "${DateFormat.yMd().format(date)}",
                      style: TextStyle(
                        fontSize: size.height * 0.02,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    width: size.width * 0.45,
                    child: Text(
                      "$recipient",
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: size.height * 0.027,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Container(
              width: size.width * 0.55,
              child: Text(
                "\$$amount",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.height * 0.025,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: !isMoney
                ? Text(
                    item,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                    softWrap: true,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
