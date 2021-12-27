import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:thank_you/components/buildMethods.dart';
import 'package:thank_you/components/donationsTextField.dart';
import 'package:thank_you/userValues.dart';

import '../main.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  AssetImage image1 = AssetImage('assets/donation1.gif');
  AssetImage image2 = AssetImage('assets/donation2.gif');
  AssetImage image3 = AssetImage('assets/donation3.gif');

  bool goalsSet = false;
  Box userValues = Hive.box('userValues');

  @override
  void dispose() {
    super.dispose();
    image1.evict();
    image2.evict();
    image3.evict();
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(fontSize: size.width * 0.03),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      body: IntroductionScreen(
        isProgress: true,
        globalBackgroundColor: Colors.white,
        showDoneButton: true,
        showNextButton: true,
        showSkipButton: false,
        done: Text(
          "Done",
          style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w600),
        ),
        onDone: () async {
          if (goalsSet) {
            await userValues.put('firstTime', false);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return Holder();
            }));
          } else {
            setGoals(context);
          }
        },
        next: Text(
          "Next",
          style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w600),
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: kLightBlackColor,
          activeSize: Size(22.0, 10.0),
          activeColor: kBlackColor,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
        isTopSafeArea: true,
        pages: [
          PageViewModel(
            title: "Keep track of your donations",
            body: "Never forget what your tax deducible amount is again!",
            image: Image(
              image: image1,
              repeat: ImageRepeat.repeat,
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Set Personal Goals",
            body:
                "Set goals for how much you would like to donate each year, and "
                "\"Thank You\" will keep track of how far along you are with this process",
            image: Image(
              image: image2,
            ),
            footer: ElevatedButton(
              onPressed: () {
                setGoals(context);
              },
              child: Text(
                "Set goals",
                style: TextStyle(color: kBlackColor),
              ),
              style: setButtonStyle(),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Give back to the community",
            body:
                "Here at Thank You we believe in giving back to the community,"
                "with a minimalistic interface it is easy for you to track your donations!",
            image: Image(
              image: image3,
            ),
            decoration: pageDecoration,
          ),
        ],
      ),
    );
  }

  void setGoals(context) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: size.height * 0.6,
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Set your goals"),
                ),
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
                    var format = NumberFormat.simpleCurrency(
                        locale: Platform.localeName);
                    target = double.parse(controller.value.text
                        .replaceAll(',', '')
                        .replaceAll('${format.currencySymbol}', ''));
                    await userValues.put('target', target);
                    await setDonations();
                    setState(() {
                      goalsSet = true;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Set",
                    style: TextStyle(color: kBlackColor),
                  ),
                  style: setButtonStyle(),
                )
              ],
            ),
          ),
        );
      },
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MediaQuery.of(context).size.height * 0.02),
            topRight:
                Radius.circular(MediaQuery.of(context).size.height * 0.02)),
      ),
    );
  }
}
