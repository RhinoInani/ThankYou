import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:thank_you/components/buildMethods.dart';
import 'package:thank_you/userValues.dart';

import '../components/recentDonationCard.dart';
import '../components/unboldBoldText.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var donations = Hive.box('donations');
  var userValues = Hive.box('userValues');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            expandedHeight: size.height * 0.23,
            floating: false,
            pinned: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              "Recent Donations",
              style: GoogleFonts.comfortaa(
                color: Colors.black,
                fontSize: size.width * 0.065,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: HeaderCard(),
            ),
          ),
          // SliverPersistentHeader(
          //   pinned: true,
          //   floating: false,
          //   delegate: HeaderSilverDelegate(
          //     size: size,
          //     expandedHeight: size.height * 0.2,
          //   ),
          // ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int num) {
                int index = donations.length - num - 1;
                Item card = donations.getAt(index);
                return Dismissible(
                  key: Key(card.date.toString()),
                  onDismissed: (direction) async {
                    // await confirmDelete(size, card);
                    await donations.delete(card.uuid);
                    setState(() {
                      donated -= card.amount!;
                    });
                    await setDonations();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.01,
                      horizontal: size.width * 0.06,
                    ),
                    width: size.width * 0.85,
                    child: RecentDonationsCard(
                      item: card,
                    ),
                  ),
                );
              },
              childCount: donations.length,
            ),
          ),
        ],
      ),
    );
  }

  ///CONFIRM DELETE
  // Future<void> confirmDelete(Size size, Item card) async {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Center(
  //           child: Container(
  //             height: size.height * 0.2,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(15),
  //               color: Colors.white,
  //             ),
  //             padding: EdgeInsets.all(size.width * 0.02),
  //             child: Column(
  //               children: [
  //                 Text(
  //                   "Confirm Delete",
  //                   style: TextStyle(
  //                     fontSize: size.height * 0.03,
  //                     color: kBlackColor,
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
  //                   child: Text(
  //                     "This action cannot be undone",
  //                     style: TextStyle(
  //                       fontSize: size.height * 0.013,
  //                       color: kLightBlackColor,
  //                     ),
  //                   ),
  //                 ),
  //                 OutlinedButton.icon(
  //                   onPressed: () async {
  //                     await box.delete(card.uuid);
  //                     Navigator.of(context).pop();
  //                   },
  //                   icon: Icon(
  //                     Icons.check,
  //                     color: kBlackColor,
  //                   ),
  //                   style: OutlinedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(15),
  //                     ),
  //                   ),
  //                   label: Text(
  //                     "Confirm",
  //                     style: TextStyle(
  //                       fontSize: size.height * 0.02,
  //                       color: kBlackColor,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
}

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.17,
      padding: EdgeInsets.only(
        top: kToolbarHeight + size.height * 0.04,
        left: size.width * 0.03,
        right: size.width * 0.04,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 10.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UnboldBoldText(
              unbold: "Target Amount: ",
              bold: "$currency${target.toStringAsFixed(2)}",
              color: kBlackColor,
            ),
            UnboldBoldText(
              unbold: "Amount Donated: ",
              bold: "$currency${donated.toStringAsFixed(2)}",
              //.toStringAsFixed makes it so that the values are rounded to two decimals places
              //use throughout code !
              color: kBlackColor,
            ),
            Divider(
              height: 1,
            ),
            UnboldBoldText(
              unbold: "Remainder Balance: ",
              bold: "$currency${remainder.toStringAsFixed(2)}",
              color: donated >= target ? Colors.lightGreen : kBlackColor,
            ),
          ],
        ),
      ),
    );
  }
}

///SLIVER APP DELEGATE
// class HeaderSilverDelegate extends SliverPersistentHeaderDelegate {
//   final double expandedHeight;
//   final Size size;
//   final bool hideTitleWhenExpanded;
//
//   HeaderSilverDelegate({
//     required this.expandedHeight,
//     required this.size,
//     this.hideTitleWhenExpanded = true,
//   });
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     final appBarSize = expandedHeight - shrinkOffset;
//     final cardTopPosition = expandedHeight / 2 - shrinkOffset;
//     final proportion = 2 - (expandedHeight / appBarSize);
//     final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
//     return SizedBox(
//       height: expandedHeight + expandedHeight / 2,
//       child: Stack(
//         children: [
//           SizedBox(
//             height: appBarSize < kToolbarHeight
//                 ? kToolbarHeight + 30
//                 : appBarSize + 30,
//             child: AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0.0,
//               centerTitle: true,
//               title: Opacity(
//                 opacity: hideTitleWhenExpanded ? 1.0 - percent : 1.0,
//                 child: Text(
//                   "Recent Donations",
//                   style: GoogleFonts.comfortaa(
//                     color: Colors.black,
//                     fontSize: size.width * 0.065,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: 0.0,
//             right: 0.0,
//             top: cardTopPosition > 0 ? cardTopPosition : 0,
//             bottom: 0.0,
//             child: Opacity(
//               opacity: percent,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 30 * percent),
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   elevation: 10.0,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       UnboldBoldText(
//                         unbold: "Target Amount: ",
//                         bold: "\$${target.toStringAsFixed(2)}",
//                         color: kBlackColor,
//                       ),
//                       UnboldBoldText(
//                         unbold: "Amount Donated: ",
//                         bold: "\$${donated.toStringAsFixed(2)}",
//                         //.toStringAsFixed makes it so that the values are rounded to two decimals places
//                         //use throughout code !
//                         color: kBlackColor,
//                       ),
//                       Divider(
//                         height: 1,
//                       ),
//                       UnboldBoldText(
//                         unbold: "Remainder Balance: ",
//                         bold: "\$${remainder.toStringAsFixed(2)}",
//                         color:
//                             donated >= target ? Colors.lightGreen : kBlackColor,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   double get maxExtent => expandedHeight + expandedHeight / 2;
//
//   @override
//   double get minExtent => size.height * 0.03;
//
//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//     return true;
//   }
// }
