import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:watandaronline/controllers/change_pin_controller.dart';
import 'package:watandaronline/widgets/auth_textfield.dart';
import 'package:watandaronline/widgets/default_button.dart';

import '../controllers/sub_reseller_password_controller.dart';

class ChangeSubPasswordScreen extends StatelessWidget {
  String? subID;
  ChangeSubPasswordScreen({super.key, this.subID});

  final SubresellerPassController passwordConttroller =
      Get.put(SubresellerPassController());

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
          "Change Password",
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
                "New Password: ",
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
                controller: passwordConttroller.newpassController,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Confirm Password: ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              AuthTextField(
                hintText: "Confirm password...",
                controller: passwordConttroller.confirmpassController,
              ),
              SizedBox(
                height: 25,
              ),
              Obx(
                () => DefaultButton(
                  buttonName: passwordConttroller.isLoading.value == false
                      ? "Change Now"
                      : "Please wait...",
                  onPressed: () {
                    if (passwordConttroller.newpassController.text.isEmpty ||
                        passwordConttroller
                            .confirmpassController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Fill the data",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      passwordConttroller.change(subID);
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
