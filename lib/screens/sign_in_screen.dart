import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watandaronline/controllers/checker.dart';
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/controllers/dashboard_controller.dart';
import 'package:watandaronline/controllers/history_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/sign_in_controller.dart';

import 'package:watandaronline/utils/colors.dart';
import 'package:watandaronline/widgets/default_button.dart';
import 'package:watandaronline/widgets/social_button.dart';

import '../bottom_nav_screen.dart';
import '../widgets/auth_textfield.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final box = GetStorage();

  final SignInController signInController = Get.put(SignInController());
  whatsapp() async {
    var contact = "+93773735557";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      print("not found");
    }
  }

  final HistoryController historyController = Get.put(HistoryController());
  final LanguageController languageController = Get.put(LanguageController());

  final CountryListController countryListController =
      Get.put(CountryListController());
  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    exit(0);
                  },
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
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
                              GestureDetector(
                                onTap: () {
                                  print(box.read("timezone"));
                                },
                                child: Text(
                                  "Log in",
                                  style: GoogleFonts.rubik(
                                    color: AppColors.defaultColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                          Obx(() => DefaultButton(
                                buttonName:
                                    signInController.isLoading.value == false
                                        ? "Log In"
                                        : "Please wait...",
                                onPressed: () async {
                                  historyController.initialpage = 1;

                                  languageController
                                      .fetchlanData(box.read("isoCode"));

                                  if (signInController
                                          .usernameController.text.isEmpty ||
                                      signInController
                                          .passwordController.text.isEmpty) {
                                    Get.snackbar(
                                        "Oops!", "Fill the text fields");
                                  } else {
                                    print("Attempting login...");
                                    await signInController.signIn();

                                    if (signInController.loginsuccess.value ==
                                        false) {
                                      // Navigating to the BottomNavigationbar page
                                      countryListController.fetchCountryData();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BottomNavigationbar(),
                                        ),
                                      );

                                      if (box.read("direction") == "rtl") {
                                        setState(() {
                                          EasyLocalization.of(context)!
                                              .setLocale(Locale('ar', 'AE'));
                                        });
                                      } else {
                                        setState(() {
                                          EasyLocalization.of(context)!
                                              .setLocale(Locale('en', 'US'));
                                        });
                                      }
                                    } else {
                                      print("Navigation conditions not met.");
                                    }
                                  }
                                },
                              )),
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
                                  onPressed: () {
                                    print(box.read("direction"));
                                  },
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          whatsapp();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          child: Image.asset("assets/icons/whatsapp.png"),
                        ),
                      ),
                      Text("  Need Help ?"),
                    ],
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
      ),
    );
  }
}
