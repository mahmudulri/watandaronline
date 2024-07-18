import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watandaronline/utils/colors.dart';
import 'package:watandaronline/widgets/default_button.dart';
import 'package:watandaronline/widgets/social_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../widgets/auth_textfield.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sign Up",
                              style: GoogleFonts.rubik(
                                color: AppColors.defaultColor,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Please enter the details bellow to continue",
                              style: GoogleFonts.rubik(
                                color: Color(0xff3C3C3C),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AuthTextField(
                          hintText: "Name",
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        AuthTextField(
                          hintText: "Email address",
                        ),
                        SizedBox(
                          height: 8,
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
                        SizedBox(
                          height: 8,
                        ),
                        AuthTextField(
                          hintText: "Password",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DefaultButton(
                          buttonName: "Sign Up",
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Or",
                              style: GoogleFonts.rubik(
                                color: AppColors.defaultColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SocialButton(
                                buttonName: "Google",
                                imageLink: "assets/images/googleicon.png",
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: SocialButton(
                                buttonName: "Apple",
                                imageLink: "assets/images/appleicon.png",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account ?",
                          style: TextStyle(
                            color: Color(0xffA3A3A3),
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: AppColors.defaultColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
