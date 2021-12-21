import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thank_you/userValues.dart';

import '../donationDetails.dart';

class RecentDonationsCard extends StatelessWidget {
  const RecentDonationsCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 700),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return DonationDetails(item: item);
            }));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.02,
          horizontal: size.width * 0.06,
        ),
        width: size.width * 0.85,
        decoration: BoxDecoration(
          color: !item.isMoney! ? mainBlue : mainGreen,
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
                        "${DateFormat.yMd().format(item.date!)}",
                        style: TextStyle(
                          fontSize: size.height * 0.02,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      width: size.width * 0.45,
                      child: Hero(
                        tag: item.uuid!,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "${item.recipient!}",
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: size.height * 0.027,
                            ),
                          ),
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
                  "\$${item.amount!.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: !item.isMoney!
                  ? Text(
                      item.item!,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                      softWrap: true,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
