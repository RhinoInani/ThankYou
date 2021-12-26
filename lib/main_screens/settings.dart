import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:thank_you/components/buildMethods.dart';
import 'package:thank_you/introduction/intro.dart';
import 'package:thank_you/newDonation.dart';
import 'package:thank_you/userValues.dart';

List<String> headers = [
  "Edit Goals",
  "Edit Currency",
  "Our Mission",
  "Privacy Policy",
  "Other Apps",
  "About Us",
];

List<IconData> icons = [
  Icons.edit_outlined,
  Icons.public_outlined,
  Icons.favorite_outline,
  Icons.lock_outlined,
  Icons.now_widgets_outlined,
  Icons.info_outlined,
];

List<Widget> callback = [
  EditGoals(),
  Introduction(),
  Introduction(),
  Introduction(),
  Introduction(),
  Introduction(),
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
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return callback[index];
            }));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.03,
          horizontal: size.width * 0.05,
        ),
        child: Row(
          children: [
            Hero(
              tag: index,
              child: Material(
                type: MaterialType.transparency,
                child: Icon(
                  icons[index],
                  color: index % 2 == 0
                      ? Color.fromRGBO(158, 193, 158, 1.0)
                      : Color(0xff97d6e5),
                ),
              ),
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

class EditGoals extends StatefulWidget {
  const EditGoals({Key? key}) : super(key: key);

  @override
  State<EditGoals> createState() => _EditGoalsState();
}

class _EditGoalsState extends State<EditGoals> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController controller = TextEditingController();
    Box userValues = Hive.box('userValues');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit You Goals",
          style: TextStyle(fontSize: size.height * 0.025),
        ),
        leading: Hero(
          tag: 0,
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.edit_outlined,
                color: Color.fromRGBO(158, 193, 158, 1.0),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DonationsTextField(
              textController: controller,
              isAmount: true,
              text: 'Set a Target Amount',
              isTarget: true,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                target =
                    double.parse(controller.value.text.replaceAll(',', ''));
                remainder = target - donated;
              });
              await setDonations();
              await userValues.put('target', target);
              Navigator.of(context).pop();
            },
            child: Text(
              "Change Goals",
              style: TextStyle(color: kBlackColor),
            ),
            style: setButtonStyle(),
          )
        ],
      ),
    );
  }
}
