import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:watandaronline/controllers/change_pin_controller.dart';
import 'package:watandaronline/global%20controller/languages_controller.dart';
import 'package:watandaronline/widgets/default_button.dart';
import '../controllers/sub_reseller_password_controller.dart';
import '../utils/colors.dart';

class ChangeSubPasswordScreen extends StatelessWidget {
  final String? subID;

  ChangeSubPasswordScreen({super.key, this.subID});

  final SubresellerPassController passwordController =
      Get.put(SubresellerPassController());
  final languagesController = Get.find<LanguagesController>();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          languagesController.tr("SET_PASSWORD"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                languagesController.tr("NEW_PASSWORD"),
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 15),
              PasswordBox(
                controller: passwordController.newpassController,
              ),
              SizedBox(height: 15),
              Text(
                languagesController.tr("CONFIRM_PASSWORD"),
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 15),
              PasswordBox(
                controller: passwordController.confirmpassController,
              ),
              SizedBox(height: 25),
              Obx(
                () => DefaultButton(
                  buttonName: passwordController.isLoading.value == false
                      ? languagesController.tr("CHANGE_NOW")
                      : languagesController.tr("PLEASE_WAIT"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Check if both passwords match
                      if (passwordController.newpassController.text !=
                          passwordController.confirmpassController.text) {
                        Fluttertoast.showToast(
                          msg: languagesController.tr("PASSWORD_NOT_MATCH"),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else {
                        passwordController.change(subID);
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: languagesController.tr("FILL_DATA_CORRECTLY"),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      languagesController
                          .tr("PASSWORD_LENGTH_SHOULD_BE_MINIMUM_8_CHARACTER"),
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordBox extends StatefulWidget {
  final TextEditingController? controller;
  final int? minLength;

  PasswordBox({
    super.key,
    this.controller,
    this.minLength = 8,
  });

  @override
  State<PasswordBox> createState() => _PasswordBoxState();
}

class _PasswordBoxState extends State<PasswordBox> {
  String? _errorText;

  final languagesController = Get.find<LanguagesController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          width: screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: _errorText == null ? AppColors.borderColor : Colors.red,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: TextField(
                controller: widget.controller,
                maxLength: 50,
                decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      _errorText =
                          languagesController.tr("PASSWORD_IS_REQUIRED");
                    } else if (value.length < widget.minLength!) {
                      _errorText = languagesController
                          .tr("MINIMUM_8_CHARACTERS_REQUIRED");
                    } else {
                      _errorText = null;
                    }
                  });
                },
              ),
            ),
          ),
        ),

        // ✅ Show error below the container
        if (_errorText != null) ...[
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              _errorText!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
