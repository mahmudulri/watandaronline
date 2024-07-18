import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:watandaronline/utils/colors.dart';
import 'package:watandaronline/widgets/auth_textfield.dart';
import 'package:watandaronline/widgets/default_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/myprofile_box_widget.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        title: Text(
          "Edit Profile",
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
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/profilepic.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              AuthTextField(
                hintText: "Name",
              ),
              SizedBox(
                height: 15,
              ),
              AuthTextField(
                hintText: "Email",
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 80,
                width: screenWidth,
                // decoration: BoxDecoration(
                //   color: Colors.red,
                //   borderRadius: BorderRadius.circular(20),
                //   border: Border.all(
                //     width: 1,
                //     color: AppColors.borderColor,
                //   ),
                // ),
                child: IntlPhoneField(
                  initialCountryCode: "AFG",
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          // color: Colors.red,
                          // width: 5,
                          ),
                    ),
                  ),
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
