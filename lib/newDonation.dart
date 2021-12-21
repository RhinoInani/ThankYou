import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'userValues.dart';

class NewDonationsScreen extends StatefulWidget {
  NewDonationsScreen({Key? key, required this.isMoney}) : super(key: key);
  final bool isMoney;

  @override
  _NewDonationsScreenState createState() => _NewDonationsScreenState();
}

class _NewDonationsScreenState extends State<NewDonationsScreen> {
  DateTime? picked = DateTime.now();

  TextEditingController recipientController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController itemController = TextEditingController();

  var donations = Hive.box('donations');
  var userValues = Hive.box('userValues');

  Future<void> setHive() async {
    String id = userValues.get('donationsCount', defaultValue: '0').toString();
    donations.put(
      id,
      Item(
        "${recipientController.value.text.trim()}",
        itemController.value.text.trim(),
        double.parse(amountController.value.text.replaceAll(',', '')),
        picked == null ? DateTime.now() : picked,
        widget.isMoney,
        id,
      ),
    );

    double currentDonated = userValues.get('donated', defaultValue: 0.00);
    donated = currentDonated +
        double.parse(amountController.value.text.replaceAll(',', ''));
    await setDonations();
    int donationsCount = int.parse(id) + 1;
    userValues.put('donationsCount', donationsCount.toString());
    recipientController.clear();
    amountController.clear();
    picked = DateTime.now();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    "New Donation",
                    style: TextStyle(fontSize: size.width * 0.06),
                  ),
                ],
              ),
              Divider(
                height: 10,
                indent: 10,
                endIndent: 10,
                color: Colors.black87,
                thickness: 0.5,
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              DonationsTextField(
                textController: recipientController,
                text: "Recipient",
                isAmount: false,
                isTarget: false,
              ),
              widget.isMoney
                  ? Container()
                  : DonationsTextField(
                      textController: itemController,
                      text: "Item",
                      isAmount: false,
                      isTarget: false,
                    ),
              DonationsTextField(
                textController: amountController,
                text: widget.isMoney ? "Amount:" : "Value",
                isAmount: true,
                isTarget: false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                    child: Text(
                      "Date:",
                      style: TextStyle(fontSize: size.width * 0.045),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _selectDate(context, widget.isMoney)
                          .then((value) => setState(() {}));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[400]!,
                          width: 0.7,
                        ),
                      ),
                      width: size.width * 0.6,
                      height: size.height * 0.07,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${DateFormat.yMMMMd('en_US').format(picked ??= DateTime.now())}",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Center(
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 0.7,
                      ),
                    ),
                    width: size.width * 0.85,
                    height: size.height * 0.07,
                    child: Center(
                      child: Text(
                        "Confirm",
                        style: TextStyle(fontSize: size.width * 0.045),
                      ),
                    ),
                  ),
                  onTap: () async {
                    setHive();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', (Route<dynamic> route) => false);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isMoney) async {
    picked = await showDatePicker(
      context: context,
      initialDate: picked ??= DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.dark(
              primary: isMoney ? Colors.green[300]! : Colors.blue[300]!,
              onPrimary: Colors.black,
              surface: isMoney ? Colors.green[300]! : Colors.blue[300]!,
              onSurface: Colors.black,
              secondary: Colors.black,
              onSecondary: Colors.black,
              secondaryVariant: Colors.black,
              brightness: Brightness.dark,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
  }
}

class DonationsTextField extends StatefulWidget {
  DonationsTextField(
      {Key? key,
      required this.textController,
      required this.text,
      required this.isAmount,
      required this.isTarget})
      : super(key: key);

  final TextEditingController textController;
  final String text;
  final bool isAmount;
  final bool isTarget;

  static const locale = 'en';

  @override
  _DonationsTextFieldState createState() => _DonationsTextFieldState();
}

class _DonationsTextFieldState extends State<DonationsTextField> {
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: DonationsTextField.locale)
          .currencySymbol;

  String errorText = "";

  @override
  Widget build(BuildContext context) {
    Box? userValues;
    if (widget.isTarget) {
      userValues = Hive.box('userValues');
    }
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "${widget.text}",
            style: TextStyle(fontSize: size.width * 0.045),
          ),
        ),
        TextField(
          autofocus: false,
          decoration: InputDecoration(
            prefixText: widget.isAmount ? _currency : " ",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            errorText: errorText == "" ? null : errorText,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red[400]!),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red[400]!),
            ),
          ),
          keyboardType: widget.isAmount
              ? TextInputType.numberWithOptions(signed: true, decimal: true)
              : null,
          controller: widget.textController,
          textAlign: TextAlign.center,
          autocorrect: true,
          expands: false,
          onSubmitted: (string) {
            String replacedString =
                widget.isAmount ? string.replaceAll(',', '') : string;
            widget.isAmount
                ? setState(() {
                    widget.textController.text = NumberFormat.simpleCurrency(
                      locale: 'en',
                      name: '',
                      decimalDigits: 2,
                    ).format((double.parse(replacedString.trim())));
                    if (widget.isTarget) {
                      userValues!
                          .put('target', double.parse(replacedString.trim()));
                    }
                  })
                : string = string;
          },
          onChanged: (string) {
            try {
              NumberFormat f = new NumberFormat("#,##0.00", "en_US");
              string = widget.isAmount
                  ? f.format(f.parse(string.replaceAll(',', '')))
                  : string;
              setState(() {
                errorText = "";
              });
            } catch (FormatException) {
              setState(() {
                errorText = "Please enter an appropriate amount";
              });
            }
          },
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
      ],
    );
  }
}
