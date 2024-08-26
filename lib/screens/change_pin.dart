import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:watandaronline/controllers/change_pin_controller.dart';
import 'package:watandaronline/widgets/auth_textfield.dart';
import 'package:watandaronline/widgets/default_button.dart';

class ChangePin extends StatelessWidget {
  ChangePin({super.key});

  final ChangePinController changePinController =
      Get.put(ChangePinController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
          "Change Pin",
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
                "Old Pin: ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              AuthTextField(
                hintText: "Enter your old pin...",
                controller: changePinController.oldPinController,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "New Pin: ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              AuthTextField(
                hintText: "Enter your new pin...",
                controller: changePinController.newPinController,
              ),
              // SizedBox(
              //   height: 15,
              // ),
              // Text(
              //   "Confirm Your Password: ",
              //   style: TextStyle(
              //     fontSize: 18,
              //     color: Colors.black,
              //   ),
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              // AuthTextField(
              //   hintText: "Confirm password...",
              // ),
              SizedBox(
                height: 25,
              ),
              Obx(
                () => DefaultButton(
                  buttonName: changePinController.isLoading.value == false
                      ? "Change"
                      : "Please wait...",
                  onPressed: () {
                    if (changePinController.oldPinController.text.isEmpty ||
                        changePinController.newPinController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Fill the data",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      changePinController.change();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
