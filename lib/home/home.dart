import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:thank_you/constants.dart';

import 'components/recentDonationCard.dart';
import 'components/unboldBoldText.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    scrollController = new ScrollController(
      keepScrollOffset: true,
    );
    _controller.forward();

    scrollController
      ..addListener(() {
        print(scrollController.offset);
        if (location.length > 4) {
          if (scrollController.offset >= size.height * 0.06) {
            _controller.reverse();
          } else if (scrollController.offset < 0) {
            _controller.forward();
          }
        } else {
          _controller.forward();
        }
      });

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.06,
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.vertical,
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: size.height * 0.14,
                    width: size.width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 7),
                          blurRadius: 5,
                          color: Colors.grey[400]!,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        UnboldBoldText(
                          size: size,
                          unbold: "Target Amount: ",
                          bold: "\$0.00",
                        ),
                        UnboldBoldText(
                          size: size,
                          unbold: "Remainder Balance: ",
                          bold: "\$0.00",
                        ),
                        UnboldBoldText(
                          size: size,
                          unbold: "Amount Donated: ",
                          bold: "\$0.00",
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
              ],
            ),
          ),
          Text(
            "Recent Donations:",
            style: TextStyle(
              fontSize: size.width * 0.065,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: size.height * 0.015,
          ),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.zero,
                dragStartBehavior: DragStartBehavior.start,
                itemCount: location.length < 10 ? location.length : 10,
                itemBuilder: (context, index) {
                  int num = location.length - index - 1;
                  return Dismissible(
                    ///TODO: add confirm deleting
                    key: Key(
                      location[num].toString() +
                          amount[num].toString() +
                          date[num].toString() +
                          num.toString() +
                          item[num].toString(),
                    ),
                    onDismissed: (direction) async {
                      setState(() {
                        location.removeAt(num);
                        amount.removeAt(num);
                        date.removeAt(num);
                        item.removeAt(num);
                        itemDescription.removeAt(num);
                      });
                      await setLocalData();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.01,
                        horizontal: size.width * 0.06,
                      ),
                      width: size.width * 0.85,
                      child: RecentDonationsCard(
                        location: location[num],
                        amount: amount[num],
                        date: date[num],
                        item: item[num],
                        itemDescription: itemDescription[num],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
