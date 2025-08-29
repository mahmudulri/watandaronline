import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/widgets/default_button.dart';

import '../controllers/change_password_controller.dart';
import '../global controller/languages_controller.dart';
import '../utils/colors.dart';
import '../widgets/custom_text.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordController changePasswordController =
      Get.put(ChangePasswordController());

  LanguagesController languagesController = Get.put(LanguagesController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
          languagesController.tr("CHANGE_PASSWORD"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Container(
        color: AppColors.backgroundColor,
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: ListView(
            children: [
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => KText(
                            text: languagesController.tr("CURRENT_PASSWORD"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ChangePinBox(
                      // hintText:
                      //     languagesController.tr("ENTER_CURRENT_PASSWORD"),
                      controller:
                          changePasswordController.currentpassController,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Obx(
                          () => KText(
                            text: languagesController.tr("NEW_PASSWORD"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ChangePinBox(
                      // hintText:
                      //     languagesController.tr("ENTER_NEW_PASSWORD"),
                      controller: changePasswordController.newpassController,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Obx(
                          () => KText(
                            text:
                                languagesController.tr("CONFIRM_NEW_PASSWORD"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ChangePinBox(
                      // hintText:
                      //     languagesController.tr("CONFIRM_NEW_PASSWORD"),
                      controller:
                          changePasswordController.confirmpassController,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Obx(
                      () => DefaultButton(
                        buttonName:
                            changePasswordController.isLoading.value == false
                                ? languagesController.tr("CHANGE_NOW")
                                : languagesController.tr("PLEASE_WAIT"),
                        onPressed: () {
                          if (changePasswordController
                                  .currentpassController.text.isEmpty ||
                              changePasswordController
                                  .newpassController.text.isEmpty ||
                              changePasswordController
                                  .confirmpassController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: languagesController
                                    .tr("FILL_DATA_CORRECTLY"),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            changePasswordController.change();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePinBox extends StatelessWidget {
  ChangePinBox({
    super.key,
    this.hintText,
    this.controller,
  });

  String? hintText;
  TextEditingController? controller;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.065,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Colors.grey.shade300,
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                fontSize: 15,
              ),
              hintText: hintText,
              border: InputBorder.none,
              // suffixIcon: Icon(
              //   Icons.visibility_off,
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
