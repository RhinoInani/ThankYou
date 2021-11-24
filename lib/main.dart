import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thank_you/constants.dart';

import 'holder.dart';

void main() {
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
        textTheme: GoogleFonts.comfortaaTextTheme(),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _getData() async {
    final prefs = await SharedPreferences.getInstance();
    // location = prefs.getStringList('location')!;
    // amount = prefs.getStringList('amount')!;
    // date = prefs.getStringList('date')!;
  }

  @override
  void initState() {
    new Timer(new Duration(milliseconds: 1500), () async {
      await _getData();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return Holder();
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
