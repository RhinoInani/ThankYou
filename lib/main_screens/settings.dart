import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thank_you/components/buildMethods.dart';
import 'package:thank_you/components/custom_icon_icons.dart';
import 'package:thank_you/components/donationsTextField.dart';
import 'package:thank_you/userValues.dart';
import 'package:url_launcher/url_launcher_string.dart';

List<String> headers = [
  "Edit Goals",
  'Additional Info',
  "Image Compression",
  // "Edit Currency",
  "Export to CSV",
  "Report a Bug",
  "Request a Feature",
  "Privacy Policy",
  "Other Resources",
  "About Us",
];

List<IconData> icons = [
  Icons.edit_outlined,
  // Icons.public_outlined,
  Icons.info_outlined,
  CustomIcon.camera_svgrepo_com,
  CustomIcon.export_outline,
  Icons.help_outline,
  Icons.question_answer,
  Icons.lock_outlined,
  Icons.now_widgets_outlined,
  Icons.info_outlined,
];

Future<void> _launchInBrowser(String url) async {
  if (!await launchUrlString(
    url,
  )) {
    throw 'Could not launch $url';
  }
}

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String privacyPolicy =
      "https://docs.google.com/document/d/1hB6N1HtlJuLWJxu45DOMXdmETF3yBOUkACw6gIA-f94/edit?usp=sharing";
  String reportBug =
      "https://docs.google.com/forms/d/e/1FAIpQLScAzeK9MwzyH_PIJSyLHFGGFeLRi-poulbny0QwogvRHzzT_w/viewform?usp=sf_link";
  String requestFeature =
      "https://docs.google.com/forms/d/e/1FAIpQLSdflfyY6PUmLu93Xvn1xbjYkIPoi6DPw92kYzdN7b91_ane0g/viewform?usp=sf_link";

  List<String> levels = ["High", "Normal", "None"];
  late String levelsValue;

  @override
  void initState() {
    if (compression == 50) {
      levelsValue = "High";
    } else if (compression == 75) {
      levelsValue = "Normal";
    } else {
      levelsValue = "None";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Box userValues = Hive.box('userValues');
    var donations = Hive.box<Item>('donations');

    List<VoidCallback> callback = [
      () {
        Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return EditGoals();
            }));
      },
      // () {
      //   Navigator.of(context).push(PageRouteBuilder(
      //       transitionDuration: Duration(milliseconds: 500),
      //       pageBuilder: (BuildContext context, Animation<double> animation,
      //           Animation<double> secondaryAnimation) {
      //         return EditCurrency();
      //       }));
      // },
      () {
        setState(() {
          additionalInfo = !additionalInfo;
        });
        userValues.put('additionalInfo', additionalInfo);
      },
      () {
        //nothing for image compression
      },
      () async {
        List<List> items = [
          [
            "Type",
            "Date",
            "Recipient",
            "Amount",
            "Item",
            "Notes",
            "UUID (DO NOT EDIT)",
          ],
        ];
        for (int i = 0; i < donations.length; i++) {
          Item item = donations.getAt(i)!;
          items.add(itemToList(item));
        }
        String csvData = ListToCsvConverter().convert(items);
        final String directory = (await getApplicationSupportDirectory()).path;
        final path = "$directory/ThankYouAppDonations${DateTime.now()}.csv";
        final File file = File(path);
        File newFile = await file.writeAsString(csvData);
        Share.shareFiles(['${newFile.path}'], text: "Donation's CSV");
      },
      () {
        _launchInBrowser(reportBug);
      },
      () {
        _launchInBrowser(requestFeature);
      },
      () {
        _launchInBrowser(privacyPolicy);
      },
      () {
        Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return OtherResources();
            }));
      },
      () {
        showAboutDialog(
            context: context,
            applicationIcon: Image.asset(
              "assets/circleIcon.png",
              height: size.height * 0.1,
            ),
            applicationName: 'Thank You',
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Created with ♡ by Rohin Inani',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('rhino.inani@gmail.com'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Artwork by Freepiks and Riya Karkhanis',
                  style: TextStyle(
                    fontSize: size.height * 0.015,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]);
      },
    ];

    Map<String, Widget> trailing = {
      'Image Compression': Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
            border: Border.all(color: kLightBlackColor),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.035,
          ),
          child: DropdownButton(
            dropdownColor: Colors.transparent,
            underline: Container(),
            elevation: 5,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: size.height * 0.04,
            isExpanded: false,
            style: TextStyle(color: kBlackColor, fontSize: 17.0),
            value: levelsValue,
            onChanged: (dynamic value) {
              if (value == "High") {
                compression = 50;
              } else if (value == "None") {
                compression = 100;
              } else {
                compression = 75;
              }
              setState(() {
                levelsValue = value;
              });
              userValues.put('compression', compression);
            },
            items: levels.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.poppins(),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      'Additional Info': Switch.adaptive(
          value: additionalInfo,
          activeColor: mainBlue,
          onChanged: (change) {
            setState(() {
              change = additionalInfo;
            });
            userValues.put('additionalInfo', additionalInfo);
          }),
    };

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
              leading: IconButton(
                icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
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
                    onTap: callback[index],
                    trailing: trailing.containsKey(headers[index].toString())
                        ? trailing[headers[index].toString()]
                        : null,
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
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  final int index;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
      child: ListTile(
        onTap: onTap,
        title: Text(
          headers[index],
          style: TextStyle(fontSize: size.height * 0.02, color: kBlackColor),
        ),
        leading: Hero(
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
        trailing: trailing != null
            ? trailing
            : Icon(
                Icons.arrow_forward_ios_rounded,
                color: kLightBlackColor,
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
      appBar: buildSettingsScreensAppBar(size, context, 0),
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
                target = double.parse(controller.value.text
                    .replaceAll(',', '')
                    .replaceAll('$currency', ''));
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
            style: setGreenButtonStyle(),
          )
        ],
      ),
    );
  }
}

// class EditCurrency extends StatelessWidget {
//   const EditCurrency({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController controller = TextEditingController();
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: buildSettingsScreensAppBar(size, context, 1),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: DonationsTextField(
//               textController: controller,
//               isAmount: false,
//               text: 'Enter Currency',
//               isTarget: false,
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               currency = controller.value.text;
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               "Change Currency",
//               style: TextStyle(color: kBlackColor),
//             ),
//             style: setBlueButtonStyle(),
//           )
//         ],
//       ),
//     );
//   }
// }

class ImageCompression extends StatelessWidget {
  const ImageCompression({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> levels = ["High", "Normal", "Low", "None"];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildSettingsScreensAppBar(size, context, 1),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
                border: Border.all(color: kLightBlackColor),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.035,
              ),
              child: DropdownButton(
                dropdownColor: Color(0xff97d6e5),
                underline: Container(),
                elevation: 5,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: size.height * 0.04,
                isExpanded: false,
                style: TextStyle(color: kBlackColor, fontSize: 17.0),
                value: "Normal",
                onChanged: (dynamic value) {
                  if (value == "High (50% Compression)") {
                    compression = 50;
                  } else if (value == "None") {
                    compression = 100;
                  } else {
                    compression = 75;
                  }
                },
                items: levels.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.poppins(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

AppBar buildSettingsScreensAppBar(Size size, BuildContext context, int index) {
  return AppBar(
    title: Text(
      "${headers[index]}",
      style: TextStyle(fontSize: size.height * 0.025),
    ),
    leading: Hero(
      tag: index,
      child: Material(
        type: MaterialType.transparency,
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            icons[index],
            color: index % 2 == 0
                ? Color.fromRGBO(158, 193, 158, 1.0)
                : Color(0xff97d6e5),
          ),
        ),
      ),
    ),
  );
}

class OtherResources extends StatelessWidget {
  const OtherResources({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String impromptuGenerator = "https://smarturl.it/impromptugenerator";
    String pristineScreen = "https://smarturl.it/pristinescreen";
    String instagram = "https://www.instagram.com/appsbyrhino/";
    String github = "https://github.com/RhinoInani";
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildSettingsScreensAppBar(size, context, 5),
      body: Column(
        children: [
          buildListTile(
            size,
            impromptuGenerator,
            "Impromptu Generator",
            "An easy way to practice impromptu public speaking",
            Icons.chevron_right_rounded,
          ),
          buildListTile(
            size,
            pristineScreen,
            "Pristine Screen",
            "An easy way to keep your Mac clean",
            Icons.chevron_right_rounded,
          ),
          buildListTile(
            size,
            instagram,
            "Instagram",
            "Come check out my other content!",
            CustomIcon.instagram,
          ),
          buildListTile(
            size,
            github,
            "Github",
            "Come check out my other code!",
            CustomIcon.mark_github,
          ),
        ],
      ),
    );
  }

  ListTile buildListTile(
    Size size,
    String url,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: size.height * 0.03,
        horizontal: size.width * 0.05,
      ),
      onTap: () {
        _launchInBrowser(url);
      },
      title: Text("$title"),
      subtitle: Text("$subtitle"),
      trailing: Icon(icon),
    );
  }
}
