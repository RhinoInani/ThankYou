import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thank_you/components/buildMethods.dart';
import 'package:thank_you/userValues.dart';

class DonationDetails extends StatefulWidget {
  DonationDetails({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  State<DonationDetails> createState() => _DonationDetailsState();
}

class _DonationDetailsState extends State<DonationDetails> {
  Box donations = Hive.box<Item>('donations');
  String image = "";

  Future<void> confirmDelete(Size size, context) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(size.height * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: Text(
                    "Confirm Delete",
                    style: TextStyle(
                      fontSize: size.height * 0.023,
                      color: kBlackColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.01),
                  child: Text(
                    "This action cannot be undone",
                    style: TextStyle(
                      fontSize: size.height * 0.013,
                      color: kLightBlackColor,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    if (widget.item.imagePath!.isNotEmpty) {
                      await File(widget.item.imagePath!).delete();
                    }
                    setState(() {
                      donated -= widget.item.amount!;
                    });
                    await setDonations();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', (Route<dynamic> route) => false);
                    await donations.delete('${widget.item.uuid}');
                  },
                  icon: Icon(
                    Icons.check,
                    color: kBlackColor,
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  label: Text(
                    "Confirm",
                    style: TextStyle(
                      fontSize: size.height * 0.015,
                      color: kBlackColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    loadPicture();
    super.initState();
  }

  void loadPicture() async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(widget.item.imagePath!);
    final File img = File('${directory.path}/$name');

    setState(() {
      image = img.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await confirmDelete(size, context);
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      //don't need more info than this because i have set the theme in the beginning files
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
        child: Column(
          children: [
            Hero(
              //TODO: make hero animations one way otherwise it looks very janky
              tag: widget.item.uuid!,
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  "${widget.item.recipient}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.height * 0.04,
                  ),
                ),
              ),
            ),
            Divider(
              color: widget.item.isMoney! ? mainGreen : mainBlue,
              thickness: 1.3,
              height: size.height * 0.03,
            ),
            DetailsColumn(
              title: 'Type:',
              description: widget.item.isMoney! ? 'Money' : 'Items',
            ),
            DetailsColumn(
              title: 'Date:',
              description: '${DateFormat.yMd().format(widget.item.date!)}',
            ),
            DetailsColumn(
              title: widget.item.isMoney! ? 'Amount' : 'Value:',
              description: '${widget.item.amount}',
            ),
            Visibility(
              visible: !widget.item.isMoney!,
              child: DetailsColumn(
                title: 'Item:',
                description: '${widget.item.item}',
              ),
            ),
            Visibility(
              visible: widget.item.notes!.length >= 1,
              child: DetailsColumn(
                title: 'Additional Notes:',
                description: '${widget.item.notes!}',
              ),
            ),
            Visibility(
              visible: widget.item.imagePath!.length >= 1 && image.isNotEmpty,
              child: DetailsColumn(
                description: '',
                title: 'Picture of Donation',
                imagePath: image,
              ),
            ),
            SizedBox(
              height: size.height * 0.08,
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
    this.imagePath = "",
  }) : super(key: key);

  final String title;
  final String description;
  final String imagePath;

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
        Visibility(
          visible: imagePath.length <= 1,
          child: Container(
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
        ),
        Visibility(
          visible: imagePath.length >= 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(imagePath)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
