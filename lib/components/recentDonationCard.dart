import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thank_you/components/buildMethods.dart';
import 'package:thank_you/components/custom_icon_icons.dart';
import 'package:thank_you/userValues.dart';

import '../main_screens/donationDetails.dart';

class RecentDonationsCard extends StatefulWidget {
  const RecentDonationsCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  State<RecentDonationsCard> createState() => _RecentDonationsCardState();
}

class _RecentDonationsCardState extends State<RecentDonationsCard> {
  bool longPress = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName);

    return GestureDetector(
      onTap: () {
        if (longPress == false) {
          Navigator.of(context).push(PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return DonationDetails(item: widget.item);
              }));
        } else {
          setState(() {
            longPress = false;
            selectedItems.remove(widget.item.uuid!);
            print(selectedItems);
          });
        }
      },
      onLongPress: () {
        setState(() {
          longPress = true;
          if (!selectedItems.contains(widget.item.uuid!)) {
            selectedItems.add(widget.item.uuid!);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.02,
          horizontal: size.width * 0.06,
        ),
        width: size.width * 0.85,
        decoration: BoxDecoration(
          color: longPress
              ? Colors.grey
              : !widget.item.isMoney!
                  ? mainBlue
                  : mainGreen,
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
                        "${dateFormat(widget.item.date!)}",
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
                        tag: widget.item.uuid!,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "${widget.item.recipient!}",
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
                  ),
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
                          "${format.currencySymbol}${widget.item.amount!.toStringAsFixed(2)}",
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
                        visible: !widget.item.isMoney!,
                        child: Text(
                          widget.item.item!,
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
                    visible: widget.item.notes!.length >= 1,
                    child: Icon(
                      CustomIcon.notes_notepad_svgrepo_com,
                    )),
                Visibility(
                  maintainInteractivity: false,
                  maintainSize: false,
                  visible: widget.item.imagePath!.length >= 1,
                  child: Icon(
                    CustomIcon.camera_svgrepo_com,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
