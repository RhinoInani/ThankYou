import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

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

  Future<bool> onComplete() async {
    late bool completed;
    setState(() {
      location.add("${recipientController.value.text.trim()}");
      amount.add(amountController.value.text.replaceAll(',', ''));
      date.add("${DateFormat.yMd('en_US').format(picked ??= DateTime.now())}");
      itemDescription.add(itemController.value.text.trim());
      item.add(widget.isMoney ? "0" : "1");
      data.add(
        DataRow(
          cells: [
            DataCell(
              Text("${recipientController.value.text.trim()}"),
            ),
            DataCell(
              Text(
                double.parse(amountController.value.text.replaceAll(',', ''))
                    .toString(),
              ),
            ),
            DataCell(
              Text(
                  "${DateFormat.yMd('en_US').format(picked ??= DateTime.now())}"),
            ),
          ],
        ),
      );
      recipientController.clear();
      amountController.clear();
      picked = DateTime.now();
      completed = true;
    });
    return completed;
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
              ),
              widget.isMoney
                  ? Container()
                  : DonationsTextField(
                      textController: itemController,
                      text: "Item",
                      isAmount: false,
                    ),
              DonationsTextField(
                textController: amountController,
                text: widget.isMoney ? "Amount:" : "Value",
                isAmount: true,
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
                      await _selectDate(context, widget.isMoney);
                      setState(() {});
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
                    bool complete = await onComplete();
                    await setLocalData();
                    if (complete) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false);
                    }
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
      required this.isAmount})
      : super(key: key);

  final TextEditingController textController;
  final String text;
  final bool isAmount;

  static const _locale = 'en';

  @override
  _DonationsTextFieldState createState() => _DonationsTextFieldState();
}

class _DonationsTextFieldState extends State<DonationsTextField> {
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: DonationsTextField._locale)
          .currencySymbol;

  String errorText = "";

  @override
  Widget build(BuildContext context) {
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
