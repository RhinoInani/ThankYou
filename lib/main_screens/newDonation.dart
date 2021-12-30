import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thank_you/components/custom_icon_icons.dart';

import '../components/buildMethods.dart';
import '../components/donationsTextField.dart';
import '../userValues.dart';

class NewDonationsScreen extends StatefulWidget {
  NewDonationsScreen({Key? key, required this.isMoney}) : super(key: key);
  final bool isMoney;

  @override
  _NewDonationsScreenState createState() => _NewDonationsScreenState();
}

class _NewDonationsScreenState extends State<NewDonationsScreen> {
  File? _image;
  bool imagePicked = false;
  final _imagePicker = ImagePicker();

  DateTime? picked = DateTime.now();
  TextEditingController recipientController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  var donations = Hive.box<Item>('donations');
  var userValues = Hive.box('userValues');

  bool error = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
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
                text: "Recipient *",
                isAmount: false,
                isTarget: false,
              ),
              Visibility(
                visible: !widget.isMoney,
                child: DonationsTextField(
                  textController: itemController,
                  text: "Item *",
                  isAmount: false,
                  isTarget: false,
                ),
              ),
              DonationsTextField(
                textController: amountController,
                text: widget.isMoney ? "Amount *" : "Value *",
                isAmount: true,
                isTarget: false,
              ),
              DonationsTextField(
                textController: notesController,
                text: "Additional Notes",
                isAmount: false,
                isTarget: false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                    child: Text(
                      "Date *",
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
                            "${DateFormat.yMMMMd(Platform.localeName.toString()).format(picked ??= DateTime.now())}",
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
                height: size.height * 0.02,
              ),
              Text(
                "Donation Image",
                style:
                    TextStyle(color: kBlackColor, fontSize: size.width * 0.045),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      await pickImage();
                    },
                    icon: Icon(CustomIcon.gallery_svgrepo_com),
                    style: outlinedButtonStyle(size),
                    label: Text("Gallery"),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await takeImage();
                    },
                    icon: Icon(CustomIcon.camera_svgrepo_com),
                    label: Text("Camera"),
                    style: outlinedButtonStyle(size),
                  ),
                  Visibility(
                    child: imagePicked
                        ? GestureDetector(
                            onTap: () {
                              fullSizeImage(size, context);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.fill,
                                height: size.width * 0.2,
                                width: size.width * 0.2,
                              ),
                            ),
                          )
                        : Container(),
                    visible: imagePicked,
                  ),
                ],
              ),
              Visibility(
                visible: !error,
                child: SizedBox(
                  height: size.height * 0.05,
                ),
              ),
              Visibility(
                visible: error,
                child: Padding(
                  padding: EdgeInsets.all(size.height * 0.02),
                  child: Center(
                    child: Text(
                      "Missing one or more fields",
                      style: TextStyle(
                          color: Colors.red[600],
                          fontSize: size.height * 0.015),
                    ),
                  ),
                ),
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
                      if (recipientController.value.text.isEmpty ||
                          amountController.value.text.isEmpty ||
                          (!widget.isMoney &&
                              itemController.value.text.isEmpty)) {
                        setState(() {
                          error = true;
                        });
                      } else {
                        setHive();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/home', (Route<dynamic> route) => false);
                        setState(() {});
                      }
                    }),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> takeImage() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      Permission.camera.request();
    }
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );
    if (image == null) return;

    setState(() {
      _image = File(image.path);
      imagePicked = true;
    });
  }

  Future<void> pickImage() async {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      Permission.photos.request();
    }
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (image == null) return;

    // final finalImage = await savePermanentImage(image.path);
    setState(() {
      _image = File(image.path);
      imagePicked = true;
    });
  }

  Future<File> savePermanentImage(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final File image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  Future<void> setHive() async {
    String id = userValues.get('donationsCount', defaultValue: '0').toString();
    String finalImage = "";
    if (_image != null) {
      final finalFile = await savePermanentImage(_image!.path);
      finalImage = await finalFile.path;
      Future.delayed(Duration(milliseconds: 3));
    }
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    donations.put(
      id,
      Item(
        "${recipientController.value.text.trim()}",
        itemController.value.text.trim(),
        double.parse(amountController.value.text
            .replaceAll(',', '')
            .replaceAll('${format.currencySymbol}', '')),
        picked == null ? DateTime.now() : picked,
        widget.isMoney,
        id,
        '''${notesController.value.text.trim()}''',
        finalImage,
      ),
    );

    double currentDonated = userValues.get('donated', defaultValue: 0.00);
    donated = currentDonated +
        double.parse(amountController.value.text
            .replaceAll(',', '')
            .replaceAll('${format.currencySymbol}', ''));
    await setDonations();
    int donationsCount = int.parse(id) + 1;
    userValues.put('donationsCount', donationsCount.toString());
    recipientController.clear();
    amountController.clear();
    picked = DateTime.now();
    setState(() {});
  }

  ButtonStyle outlinedButtonStyle(Size size) {
    return OutlinedButton.styleFrom(
      primary: kBlackColor,
      maximumSize: Size(size.width * 0.4, size.height * 0.06),
      minimumSize: Size(size.width * 0.2, size.height * 0.06),
    );
  }

  void fullSizeImage(Size size, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _image!,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
