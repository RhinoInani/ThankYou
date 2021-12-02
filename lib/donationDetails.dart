import 'package:flutter/material.dart';
import 'package:thank_you/userValues.dart';

class DonationDetails extends StatelessWidget {
  const DonationDetails({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Hero(
                  tag: item.uuid!,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      "${item.recipient}",
                      style: TextStyle(
                        fontSize: size.height * 0.027,
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
