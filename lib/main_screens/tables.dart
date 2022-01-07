import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:thank_you/components/buildMethods.dart';
import 'package:thank_you/components/searchWidgets.dart';
import 'package:thank_you/main_screens/donationDetails.dart';
import 'package:thank_you/userValues.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({Key? key}) : super(key: key);

  @override
  _TablesScreenState createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  var box = Hive.box<Item>('donations');

  final List<String> recipient = [];
  final List<double> amount = [];
  final List<String> date = [];

  // final List<Map> donations = List.generate(box.length, (index){
  //
  // })

  int? sortColumnIndex;
  bool isAscending = false;
  late List<Item> items = [];

  @override
  void initState() {
    box.toMap().forEach((key, value) {
      items.add(box.get(key)!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 30,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchWidget());
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          dragStartBehavior: DragStartBehavior.start,
          children: [
            DataTable(
              sortAscending: isAscending,
              sortColumnIndex: sortColumnIndex,
              showCheckboxColumn: false,
              rows: items.map((item) {
                return DataRow(
                  onSelectChanged: (bool? selected) {
                    if (selected!) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return DonationDetails(item: item);
                      }));
                    }
                  },
                  cells: [
                    DataCell(
                      Text(
                        item.recipient!,
                      ),
                    ),
                    DataCell(
                      Text(
                        item.amount.toString(),
                      ),
                    ),
                    DataCell(
                      Text(
                        dateFormat(item.date!),
                      ),
                    ),
                  ],
                  color: MaterialStateProperty.resolveWith(
                    (Set states) {
                      if (item.isMoney!) return mainGreen;
                      return mainBlue;
                    },
                  ),
                );
              }).toList(),
              columns: [
                DataColumn(label: Text("Recipient"), onSort: onSort),
                DataColumn(label: Text("Amount"), onSort: onSort),
                DataColumn(label: Text("Date"), onSort: onSort),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      if (columnIndex == 0) {
        items.sort((donation1, donation2) {
          return ascending
              ? donation1.recipient!.compareTo(donation2.recipient!)
              : donation2.recipient!.compareTo(donation1.recipient!);
        });
      } else if (columnIndex == 1) {
        items.sort((donation1, donation2) {
          return ascending
              ? donation1.amount!.compareTo(donation2.amount!)
              : donation2.amount!.compareTo(donation1.amount!);
        });
      } else if (columnIndex == 2) {
        items.sort((donation1, donation2) {
          return ascending
              ? donation1.date!.compareTo(donation2.date!)
              : donation2.date!.compareTo(donation1.date!);
        });
      }
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }
}
