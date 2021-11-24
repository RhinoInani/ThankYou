import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({Key? key}) : super(key: key);

  @override
  _TablesScreenState createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
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
            rows: data,
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
