import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thank_you/components/buildMethods.dart';
import 'package:thank_you/components/donationDetails.dart';
import 'package:thank_you/userValues.dart';

import '../components/recentDonationCard.dart';
import '../components/unboldBoldText.dart';

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
            expandedHeight: size.height * 0.23,
            floating: false,
            pinned: true,
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
              background: HeaderCard(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int num) {
                int index = donations.length - num - 1;
                Item card = donations.getAt(index)!;
                return Dismissible(
                  key: Key(card.date.toString()),
                  onDismissed: (direction) async {
                    // await confirmDelete(size, card);
                    if (card.imagePath!.isNotEmpty) {
                      await File(card.imagePath!).delete();
                    }
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

class SearchWidget extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.chevron_left_rounded),
      onPressed: () {
        close(context, null); // for closing the search page and going back
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchFinder(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchFinder(query: query);
  }
}

class SearchFinder extends StatelessWidget {
  final String query;

  const SearchFinder({Key? key, required this.query}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // var databaseProvider = Provider.of(context);
    return ValueListenableBuilder(
      valueListenable: Hive.box<Item>('donations').listenable(),
      builder: (context, Box<Item> donationsBox, _) {
        ///* this is where we filter data
        var results = query.isEmpty
            ? donationsBox.values.toList() // whole list
            : donationsBox.values
                .where((c) =>
                    c.recipient!.toLowerCase().contains(query) ||
                    dateFormat(c.date!).contains(query))
                .toList();

        return results.isEmpty
            ? Center(
                child: Text(
                  'No results found!',
                ),
              )
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  // passing as a custom list
                  final Item donationListItem = results[index];

                  return ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DonationDetails(item: donationListItem)));
                    },
                    title: Text(
                      donationListItem.recipient!,
                    ),
                    subtitle: Text(
                      donationListItem.amount!.toString(),
                      textScaleFactor: 1.0,
                    ),
                    trailing: Text(
                      dateFormat(donationListItem.date!),
                    ),
                    leading: donationListItem.isMoney!
                        ? Icon(Icons.attach_money_rounded)
                        : Icon(Icons.shopping_bag_outlined),
                  );
                },
              );
      },
    );
  }
}
