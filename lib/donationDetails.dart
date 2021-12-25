import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thank_you/userValues.dart';

class DonationDetails extends StatelessWidget {
  const DonationDetails({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:
          AppBar(), //dont need more info than this becuase i have set the theme in the beginning files
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
        child: Column(
          children: [
            Hero(
              //TODO: make hero animations one way otherwise it looks very janky
              tag: item.uuid!,
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  "${item.recipient}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.height * 0.04,
                  ),
                ),
              ),
            ),
            Divider(
              color: item.isMoney! ? mainGreen : mainBlue,
              thickness: 1.3,
              height: size.height * 0.03,
            ),
            DetailsColumn(
              title: 'Type:',
              description: item.isMoney! ? 'Money' : 'Item(s)',
            ),
            DetailsColumn(
              title: 'Date:',
              description: '${DateFormat.yMd().format(item.date!)}',
            ),
            Visibility(
              visible: !item.isMoney!,
              child: DetailsColumn(
                title: 'Item:',
                description: '${item.item}',
              ),
            ),
            Visibility(
              visible: item.notes!.length >= 1,
              child: DetailsColumn(
                title: 'Additional Notes:',
                description: '${item.notes!}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsColumn extends StatelessWidget {
  const DetailsColumn({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    const double constFontSize = 0.021;
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.012),
          child: Text(
            "$title",
            style: TextStyle(fontSize: size.height * constFontSize),
          ),
        ),
        Container(
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: kLightBlackColor.withOpacity(0.13),
          ),
          padding: EdgeInsets.all(size.height * 0.015),
          child: Text(
            "$description",
            style: TextStyle(fontSize: size.height * constFontSize),
          ),
        ),
      ],
    );
  }
}
