import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thank_you/settings.dart';
import 'package:thank_you/tables.dart';
import 'package:thank_you/userValues.dart';

import 'home.dart';
import 'newDonation.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());
  await Hive.openBox('donations');
  await Hive.openBox('userValues');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/home': (context) => Holder(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: kBlackColor,
            opacity: 0.9,
          ),
        ),
        dividerTheme: DividerThemeData(
          color: kLightBlackColor,
          endIndent: 30,
          indent: 30,
          thickness: 0.5,
        ),
        textTheme: GoogleFonts.comfortaaTextTheme(),
      ),
      home: Holder(),
    );
  }
}

class Holder extends StatefulWidget {
  Holder({Key? key}) : super(key: key);

  @override
  _HolderState createState() => _HolderState();
}

int currentPage = 0;

class _HolderState extends State<Holder> {
  PageController _pageController = new PageController(initialPage: currentPage);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        pageSnapping: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(
            key: Key("0"),
          ),
          TablesScreen(
            key: Key("1"),
          ),
        ],
        onPageChanged: (int page) {
          setState(() {
            currentPage = page;
          });
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.height * 0.07, vertical: size.height * 0.02),
        child: BottomBar(
          itemPadding: EdgeInsets.all(size.height * 0.01),
          selectedIndex: currentPage,
          onTap: (int index) {
            _pageController.jumpToPage(index);
            setState(() => currentPage = index);
          },
          height: size.height * 0.075,
          items: <BottomBarItem>[
            BottomBarItem(
              icon: currentPage == 0
                  ? Icon(Icons.home)
                  : Icon(Icons.home_outlined),
              title: Text("Home"),
              activeColor: Colors.green,
              inactiveColor: Colors.blueGrey[300],
            ),
            BottomBarItem(
              icon: currentPage == 1
                  ? Icon(Icons.table_chart)
                  : Icon(Icons.table_chart_outlined),
              title: Text("Tables"),
              activeColor: Colors.lightBlue[300]!,
              inactiveColor: Colors.blueGrey[300],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
        renderOverlay: true,
        useRotationAnimation: true,
        curve: Curves.bounceInOut,
        overlayColor: Colors.grey[100],
        buttonSize: 50.0,
        childrenButtonSize: 60.0,
        animationSpeed: 200,
        spacing: 10,
        visible: true,
        icon: Icons.add,
        activeIcon: Icons.clear,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 5.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.attach_money_rounded),
            backgroundColor: mainGreen,
            label: 'Money',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return NewDonationsScreen(isMoney: true);
              }));
            },
          ),
          SpeedDialChild(
            child: Icon(
              Icons.shopping_bag_outlined,
            ),
            backgroundColor: mainBlue,
            label: 'Item',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return NewDonationsScreen(isMoney: false);
              }));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.settings),
            backgroundColor: Colors.deepPurple[300],
            label: 'Settings',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return SettingsScreen();
              }));
            },
          )
        ],
      ),
    );
  }
}
