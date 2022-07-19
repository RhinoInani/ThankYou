import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:thank_you/components/searchWidgets.dart';
import 'package:thank_you/userValues.dart';

import '../components/buildMethods.dart';
import '../components/recentDonationCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var donations = Hive.box<Item>('donations');
  var userValues = Hive.box('userValues');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future<void> confirmDelete(Size size, context) async {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
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
                      for (int i = 0; i < selectedItems.length; i++) {
                        Item item = donations.get(selectedItems.elementAt(i))!;
                        if (item.imagePath!.isNotEmpty) {
                          await File(item.imagePath!).delete();
                        }
                        setState(() {
                          donated -= item.amount!;
                        });
                        await setDonations();
                        await donations.delete('${item.uuid}');
                      }
                      selectedItems.clear();
                      Navigator.pop(context, true);
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

    pw.Document createPDF() {
      final pdf = pw.Document();
      for (int i = 0; i < selectedItems.length; i++) {
        Item item = donations.get(selectedItems.elementAt(i))!;
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) => pw.Container(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text('Donation Receipt',
                        style: pw.TextStyle(
                          fontSize: 30,
                          fontWeight: pw.FontWeight.bold,
                        )),
                  ),
                  pw.Divider(
                    color: item.isMoney!
                        ? PdfColor.fromHex('#C1E1C1')
                        : PdfColor.fromHex('#AED5F4'),
                    thickness: 1.7,
                    height: 10,
                  ),
                  pw.Text(
                    "Donation Type:\n${item.isMoney! ? 'Money' : 'Items'}",
                    style: pdfMainBodyStyle(),
                  ),
                  pw.SizedBox(height: 15),
                  pw.Text('Recipient: \n${item.recipient}',
                      style: pdfMainBodyStyle()),
                  pw.SizedBox(height: 15),
                  pw.Text('Donation Date: \n${dateFormat(item.date!)}',
                      style: pdfMainBodyStyle()),
                  pw.SizedBox(height: 15),
                  pw.Text(
                      '${item.isMoney! ? 'Amount:' : 'Value:'} \n${moneyFormat.currencySymbol}${item.amount}',
                      style: pdfMainBodyStyle()),
                  pw.SizedBox(height: 15),
                  item.notes!.length > 1
                      ? pw.Text('Additional Notes: \n${item.notes}',
                          style: pdfMainBodyStyle())
                      : pw.Container(),
                  pw.SizedBox(height: 15),
                  item.imagePath.toString().length > 1
                      ? pw.Image(pw.MemoryImage(
                          File('${item.imagePath}').readAsBytesSync(),
                        ))
                      : pw.Container(),
                ],
              ),
            ),
          ),
        );
      }
      return pdf;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            expandedHeight:
                additionalInfo ? size.height * 0.3 : size.height * 0.25,
            floating: false,
            pinned: true,
            stretch: true,
            onStretchTrigger: () async {
              Future.delayed(Duration.zero, () => {setState(() {})});
            },
            actions: [
              Visibility(
                visible: selectedItems.length > 0,
                child: IconButton(
                  onPressed: () {
                    confirmDelete(size, context);
                  },
                  icon: Icon(Icons.delete_outline),
                ),
              ),
              Visibility(
                visible: selectedItems.length > 0,
                child: IconButton(
                  onPressed: () async {
                    pw.Document pdf = createPDF();
                    final directory = await getApplicationDocumentsDirectory();
                    final file = File("${directory.path}/donationReceipt.pdf");
                    await file.writeAsBytes(await pdf.save());
                    Share.shareFiles(['${file.path}'],
                        text: 'Donation Receipt');
                  },
                  icon: Platform.isIOS
                      ? Icon(Icons.ios_share)
                      : Icon(Icons.share),
                ),
              ),
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchWidget());
                },
                icon: Icon(Icons.search),
              ),
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            centerTitle: true,
            title: Text(
              "Recent Donations",
              style: GoogleFonts.comfortaa(
                color: Colors.black,
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [StretchMode.fadeTitle],
              background: HeaderCard(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int num) {
                int index = donations.length - num - 1;
                Item card = donations.getAt(index)!;
                return Container(
                  key: Key(card.uuid.toString()),
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.01,
                    horizontal: size.width * 0.06,
                  ),
                  width: size.width * 0.85,
                  child: RecentDonationsCard(
                    item: card,
                  ),
                  // ),
                );
              },
              childCount: donations.length,
            ),
          ),
        ],
      ),
    );
  }

  pw.TextStyle pdfMainBodyStyle() {
    return pw.TextStyle(
      fontSize: 20,
    );
  }
}

class HeaderCard extends StatelessWidget {
  HeaderCard({
    Key? key,
  }) : super(key: key);

  var donations = Hive.box<Item>('donations');

  double determineAmount(bool isMoney) {
    double counterMoney = 0;
    double counterItem = 0;
    for (int i = 0; i < donations.length; i++) {
      Item item = donations.getAt(i)!;
      item.isMoney!
          ? counterMoney += item.amount!
          : counterItem += item.amount!;
    }

    return isMoney ? counterMoney : counterItem;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.width * 0.22,
      padding: EdgeInsets.only(
        top: kToolbarHeight + size.height * 0.04,
        left: size.width * 0.03,
        right: size.width * 0.04,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 10.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UnboldBoldText(
              unbold: "Target Amount: ",
              bold: "$currency${target.toStringAsFixed(2)}",
              color: kBlackColor,
            ),
            UnboldBoldText(
              unbold: "Amount Donated: ",
              bold: "$currency${donated.toStringAsFixed(2)}",
              //.toStringAsFixed makes it so that the values are rounded to two decimals places
              //use throughout code !
              color: kBlackColor,
            ),
            Visibility(
              visible: additionalInfo,
              child: UnboldBoldText(
                unbold: "Money Amt Donated: ",
                bold: "$currency${determineAmount(true).toStringAsFixed(2)}",
                color: kBlackColor,
              ),
            ),
            Visibility(
              visible: additionalInfo,
              child: UnboldBoldText(
                unbold: "Item Amt Donated: ",
                bold: "$currency${determineAmount(false).toStringAsFixed(2)}",
                color: kBlackColor,
              ),
            ),
            Divider(
              height: 1,
            ),
            UnboldBoldText(
              unbold: "Remainder Balance: ",
              bold: "$currency${remainder.toStringAsFixed(2)}",
              color: donated >= target ? Colors.lightGreen : kBlackColor,
            ),
          ],
        ),
      ),
    );
  }
}

class UnboldBoldText extends StatelessWidget {
  const UnboldBoldText({
    Key? key,
    required this.unbold,
    required this.bold,
    required this.color,
  }) : super(key: key);

  final String unbold;
  final String bold;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsets.all(size.height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "$unbold",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: size.width * 0.043,
                color: kLightBlackColor.withBlue(kLightBlackColor.blue + 15),
              ),
            ),
            Text(
              "$bold",
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: size.width * 0.043,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ));
  }
}
