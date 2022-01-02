import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thank_you/main_screens/searchWidgets.dart';
import 'package:thank_you/userValues.dart';

import '../components/recentDonationCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var donations = Hive.box<Item>('donations');
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
            expandedHeight: size.height * 0.25,
            floating: false,
            pinned: true,
            stretch: true,
            onStretchTrigger: () async {
              Future.delayed(Duration.zero, () => {setState(() {})});
            },
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchWidget());
                },
                icon: Icon(Icons.search),
              )
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              "Recent Donations",
              style: GoogleFonts.comfortaa(
                color: Colors.black,
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [StretchMode.fadeTitle],
              background: HeaderCard(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int num) {
                int index = donations.length - num - 1;
                Item card = donations.getAt(index)!;
                // return Dismissible(
                //   key: Key(card.uuid.toString()),
                //   onDismissed: (direction) async {
                //     if (card.imagePath!.isNotEmpty) {
                //       await File(card.imagePath!).delete();
                //     }
                //     await donations.delete(card.uuid);
                //     setState(() {
                //       donated -= card.amount!;
                //     });
                //     await setDonations();
                //   },
                //   child:
                return Container(
                  key: Key(card.uuid.toString()),
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.01,
                    horizontal: size.width * 0.06,
                  ),
                  width: size.width * 0.85,
                  child: RecentDonationsCard(
                    item: card,
                  ),
                  // ),
                );
              },
              childCount: donations.length,
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.width * 0.22,
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
        ));
  }
}
