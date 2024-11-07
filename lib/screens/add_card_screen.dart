import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watandaronline/bottom_nav_screen.dart';
import 'package:watandaronline/controllers/history_controller.dart';
import 'package:watandaronline/widgets/add_card_widget.dart';
import 'package:watandaronline/widgets/auth_textfield.dart';
import 'package:watandaronline/widgets/default_button.dart';

import '../utils/colors.dart';

class AddCardScreen extends StatelessWidget {
  AddCardScreen({super.key});
  final historyController = Get.find<HistoryController>();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            // historyController.finalList.clear();
            // historyController.initialpage = 1;
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "My Cards",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment method ",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              AddCardWidget(
                imagelink: "assets/icons/paypal.png",
                carName: "Paypal",
              ),
              SizedBox(
                height: 15,
              ),
              AddCardWidget(
                imagelink: "assets/icons/visa.png",
                carName: "Visa",
              ),
              SizedBox(
                height: 15,
              ),
              AddCardWidget(
                imagelink: "assets/icons/applepay.png",
                carName: "Apple pay",
              ),
              SizedBox(
                height: 15,
              ),
              AddCardWidget(
                imagelink: "assets/icons/googlepay.png",
                carName: "Google pay",
              ),
              Spacer(),
              DefaultButton(
                buttonName: "Add card",
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
