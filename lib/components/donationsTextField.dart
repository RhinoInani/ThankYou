import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

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

  @override
  _DonationsTextFieldState createState() => _DonationsTextFieldState();
}

class _DonationsTextFieldState extends State<DonationsTextField> {
  String locale = Platform.localeName.toString();

  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: locale).currencySymbol;

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
              ? TextInputType.numberWithOptions(
                  decimal: true,
                )
              : null,
          textInputAction: widget.isAmount ? TextInputAction.done : null,
          controller: widget.textController,
          textAlign: TextAlign.center,
          autocorrect: true,
          expands: false,
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (string) {
            String replacedString =
                widget.isAmount ? string.replaceAll(',', '') : string;
            widget.isAmount
                ? setState(() {
                    widget.textController.text = NumberFormat.simpleCurrency(
                      locale: Platform.localeName.toString(),
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
              NumberFormat f = new NumberFormat(
                  "#,##0.00", "${Platform.localeName.toString()}");
              string = widget.isAmount
                  ? f.format(f.parse(string.replaceAll(',', '')))
                  : string;
              setState(() {
                errorText = "";
              });
            } catch (err) {
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
