import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thank_you/components/buildMethods.dart';
import 'package:thank_you/components/custom_icon_icons.dart';
import 'package:thank_you/userValues.dart';

import '../main_screens/donationDetails.dart';

class RecentDonationsCard extends StatelessWidget {
  const RecentDonationsCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
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
                    right: 0,
                    child: Container(
                      child: Text(
                        "${dateFormat(item.date!)}",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: size.width * 0.55,
                        child: Text(
                          "${format.currencySymbol}${item.amount!.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.025,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Visibility(
                        visible: !item.isMoney!,
                        child: Text(
                          item.item!,
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                    visible: item.notes!.length >= 1,
                    child: Icon(
                      CustomIcon.notes_notepad_svgrepo_com,
                    )),
                Visibility(
                  maintainInteractivity: false,
                  maintainSize: false,
                  visible: item.imagePath!.length >= 1,
                  child: item.imagePath!.length >= 1
                      ? Icon(
                          CustomIcon.camera_svgrepo_com,
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
