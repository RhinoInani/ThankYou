import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thank_you/userValues.dart';

List<String> headers = [
  "Edit Goals",
  "Edit Currency",
  "Default Page",
  "Our Mission",
  "Privacy Policy",
  "Other Apps",
  "About Us",
];

List<IconData> icons = [
  Icons.edit_outlined,
  Icons.public_outlined,
  Icons.filter,
  Icons.favorite_outline,
  Icons.lock_outlined,
  Icons.now_widgets_outlined,
  Icons.info_outlined,
];

List<VoidCallback> callback = [
  () {},
  () {},
  () {},
  () {},
  () {},
  () {},
  () {},
];

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              expandedHeight: size.height * 0.2,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        'assets/circleIcon.png',
                        height: size.height * 0.125,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Divider(),
                  ],
                ),
                title: Text(
                  "Settings",
                  style: GoogleFonts.comfortaa(
                    color: kBlackColor,
                    fontSize: size.width * 0.065,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return SettingsCard(
                    index: index,
                  );
                },
                childCount: headers.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: callback[index],
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.03,
          horizontal: size.width * 0.05,
        ),
        child: Row(
          children: [
            Icon(
              icons[index],
              color: index % 2 == 0
                  ? Color.fromRGBO(158, 193, 158, 1.0)
                  : Color(0xff97d6e5),
            ),
            SizedBox(
              width: size.width * 0.05,
            ),
            Text(
              headers[index],
              style:
                  TextStyle(fontSize: size.height * 0.02, color: kBlackColor),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: kLightBlackColor,
            ),
          ],
        ),
      ),
    );
  }
}
