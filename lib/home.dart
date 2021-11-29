import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:thank_you/userValues.dart';

import 'components/recentDonationCard.dart';
import 'components/unboldBoldText.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var box = Hive.box('donations');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: HeaderSilverDelegate(
              size: size,
              expandedHeight: size.height * 0.2,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, num) {
                int index = box.length - num - 1;
                Item card = box.getAt(index);
                return Dismissible(
                  key: Key(card.date.toString()),
                  onDismissed: (direction) async {
                    await confirmDelete(size, card);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.01,
                      horizontal: size.width * 0.06,
                    ),
                    width: size.width * 0.85,
                    child: RecentDonationsCard(
                      recipient: card.recipient!,
                      amount: card.amount!.toString(),
                      date: card.date!,
                      isMoney: card.isMoney!,
                      item: card.item!,
                    ),
                  ),
                );
              },
              childCount: box.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> confirmDelete(Size size, Item card) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: size.height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(size.width * 0.02),
              child: Column(
                children: [
                  Text(
                    "Confirm Delete",
                    style: TextStyle(
                      fontSize: size.height * 0.03,
                      color: kBlackColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    child: Text(
                      "This action cannot be undone",
                      style: TextStyle(
                        fontSize: size.height * 0.013,
                        color: kLightBlackColor,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await box.delete(card.uuid);
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.check,
                      color: kBlackColor,
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    label: Text(
                      "Confirm",
                      style: TextStyle(
                        fontSize: size.height * 0.02,
                        color: kBlackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class HeaderSilverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Size size;
  final bool hideTitleWhenExpanded;

  HeaderSilverDelegate({
    required this.expandedHeight,
    required this.size,
    this.hideTitleWhenExpanded = true,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - shrinkOffset;
    final cardTopPosition = expandedHeight / 2 - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    return SizedBox(
      height: expandedHeight + expandedHeight / 2,
      child: Stack(
        children: [
          SizedBox(
            height: appBarSize < kToolbarHeight
                ? kToolbarHeight + 30
                : appBarSize + 30,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Opacity(
                opacity: hideTitleWhenExpanded ? 1.0 - percent : 1.0,
                child: Text(
                  "Recent Donations",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.065,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: cardTopPosition > 0 ? cardTopPosition : 0,
            bottom: 0.0,
            child: Opacity(
              opacity: percent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30 * percent),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 20.0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UnboldBoldText(
                          size: size,
                          unbold: "Target Amount: ",
                          bold: "\$0.00",
                        ),
                        UnboldBoldText(
                          size: size,
                          unbold: "Remainder Balance: ",
                          bold: "\$0.00",
                        ),
                        UnboldBoldText(
                          size: size,
                          unbold: "Amount Donated: ",
                          bold: "\$0.00",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + expandedHeight / 2;

  @override
  double get minExtent => size.height * 0.03;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
