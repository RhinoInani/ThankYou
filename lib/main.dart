import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:thank_you/main_screens//settings.dart';
import 'package:thank_you/main_screens/home.dart';
import 'package:thank_you/main_screens/tables.dart';
import 'package:thank_you/userValues.dart';

import 'introduction/intro.dart';
import 'main_screens/newDonation.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());
  await Hive.openBox('userValues');
  Box userValues = Hive.box('userValues');
  target = await userValues.get('target', defaultValue: 1000.00);
  donated = await userValues.get('donated', defaultValue: 0.00);
  firstTime = await userValues.get('firstTime', defaultValue: true);
  remainder = target - donated;
  initializeDateFormatting();
  await Hive.openBox<Item>('donations');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      statusBarColor: Colors.black,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/home': (context) => Holder(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black,
          ),
          iconTheme: IconThemeData(
            color: kBlackColor,
            opacity: 0.9,
          ),
          titleTextStyle: TextStyle(
            color: kBlackColor,
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
      home: firstTime ? Introduction() : Holder(),
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
      resizeToAvoidBottomInset: false,
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
          horizontal: size.height * 0.07,
          vertical: size.height * 0.02,
        ),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
              title: Text("Charts"),
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
          ),
        ],
      ),
    );
  }
}
