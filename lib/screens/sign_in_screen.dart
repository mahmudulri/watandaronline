import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watantelecom/controllers/checker.dart';
import 'package:watantelecom/controllers/sign_in_controller.dart';
import 'package:watantelecom/pages/homescreen.dart';
import 'package:watantelecom/utils/colors.dart';
import 'package:watantelecom/widgets/default_button.dart';
import 'package:watantelecom/widgets/social_button.dart';

import '../bottom_nav_screen.dart';
import '../widgets/auth_textfield.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final SignInController signInController = Get.put(SignInController());

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
                              "Log in",
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
                          controller: signInController.usernameController,
                          hintText: "Username",
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        AuthTextField(
                          controller: signInController.passwordController,
                          hintText: "Password",
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Forgot pasasowrd ?",
                              style: TextStyle(
                                color: Color(0xff5F5F5F),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => DefaultButton(
                            buttonName:
                                signInController.isLoading.value == false
                                    ? "Log In"
                                    : "Please wait...",
                            onPressed: () async {
                              await signInController.signIn();
                              if (signInController.loginsuccess.value ==
                                  false) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BottomNavigationbar(),
                                  ),
                                );
                              } else {
                                print("object");
                              }

                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => BottomNavigationbar()),
                              // );
                              // Get.to(() => BottomNavigationbar());
                            },
                          ),
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
                          "Don't have an account ?",
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
                            Get.to(() => SignUpScreen());
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: AppColors.defaultColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
