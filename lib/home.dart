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
              (BuildContext context, index) {
                Item card = box.getAt(index); //TODO: not sort lexicographically
                return Dismissible(
                  ///TODO: add confirm deleting
                  key: Key(card.date.toString()),
                  onDismissed: (direction) async {
                    confirmDelete(size, card);
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

  void confirmDelete(Size size, Item card) {
    showDialog(
        context: context,
        barrierLabel: "Confirm Delete",
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: size.height * 0.1,
              width: size.width * 0.5,
              child: Column(
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      await box.delete(card.uuid);
                    },
                    icon: Icon(Icons.check),
                    label: Text("Confirm Delete"),
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
