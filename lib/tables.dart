import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'userValues.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({Key? key}) : super(key: key);

  @override
  _TablesScreenState createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  var box = Hive.box('donations');
  late List<DataRow> tableData;

  @override
  void initState() {
    tableData = List.generate(box.length, (index) {
      Item item = box.getAt(index);
      return DataRow(cells: [
        DataCell(
          Text(
            item.recipient!,
          ),
        ),
        DataCell(
          Text(
            "${item.amount!}",
          ),
        ),
        DataCell(
          Text(
            "${DateFormat.yMd().format(item.date!)}",
          ),
        ),
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: EdgeInsets.zero,
        dragStartBehavior: DragStartBehavior.start,
        children: [
          SizedBox(
            height: size.height * 0.03,
          ),
          DataTable(
            rows: tableData,
            columns: [
              DataColumn(
                label: Text(
                  "Location",
                ),
              ),
              DataColumn(
                label: Text("Amount"),
              ),
              DataColumn(
                label: Text("Date"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
