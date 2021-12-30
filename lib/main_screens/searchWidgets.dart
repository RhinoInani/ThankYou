import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thank_you/components/buildMethods.dart';
import 'package:thank_you/main_screens/donationDetails.dart';
import 'package:thank_you/userValues.dart';

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
        /// this is where we filter data
        var results = query.isEmpty
            ? donationsBox.values.toList().reversed.toList() // whole list
            : donationsBox.values
                .where((c) =>
                    c.recipient!.toLowerCase().contains(query) ||
                    dateFormat(c.date!).contains(query) ||
                    c.item!.toLowerCase().contains(query))
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
