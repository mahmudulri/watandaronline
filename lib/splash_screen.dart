import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:watandaronline/bottom_nav_screen.dart';
import 'package:watandaronline/controllers/iso_code_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/slider_controller.dart';
import 'package:watandaronline/routes/routes.dart';
import 'package:watandaronline/screens/onboarding_screen.dart';
import 'package:watandaronline/utils/colors.dart';

import 'global controller/languages_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () => checkData());

    super.initState();
  }

  final languagesController = Get.find<LanguagesController>();
  final iscoCodeController = Get.find<IscoCodeController>();
  final sliderController = Get.find<SliderController>();

  checkData() async {
    String languageShortName = box.read("language") ?? "Fa";

    // Find selected language details from the list
    final matchedLang = languagesController.alllanguagedata.firstWhere(
      (lang) => lang["name"] == languageShortName,
      orElse: () => {"isoCode": "fa", "direction": "rtl"},
    );

    final isoCode = matchedLang["isoCode"] ?? "fa";
    final direction = matchedLang["direction"] ?? "rtl";

    // Save language and direction
    box.write("language", languageShortName);
    box.write("direction", direction);

    // Load translations manually
    languagesController.changeLanguage(languageShortName);

    // Set EasyLocalization locale using proper region code
    Locale locale;
    switch (isoCode) {
      case "fa":
        locale = Locale("fa", "IR");
        break;
      case "en":
        locale = Locale("en", "US");
        break;
      case "ar":
        locale = Locale("ar", "AE");
        break;
      case "ps":
        locale = Locale("ps", "AF");
        break;
      case "tr":
        locale = Locale("tr", "TR");
        break;
      case "bn":
        locale = Locale("bn", "BD");
        break;
      default:
        locale = Locale("fa", "IR");
    }

    setState(() {
      EasyLocalization.of(context)!.setLocale(locale);
    });

    // If no token, go to onboarding
    if (box.read('userToken') == null) {
      Get.toNamed(signinscreen);
    } else {
      // Fetch initial data
      sliderController.fetchSliderData();

      Get.toNamed(bottomnavscreen);
    }
  }

  // dcheckData() async {
  //   if (box.read('userToken') == null) {
  //     languagesController.changeLanguage("Fa");
  //     box.write("direction", "rtl");

  //     setState(() {
  //       EasyLocalization.of(context)!.setLocale(Locale('ar', 'AE'));
  //     });
  //     Get.toNamed(signinscreen);
  //   } else {
  //     if (box.read("language") == null) {
  //       languagesController.changeLanguage("Fa");
  //       box.write("direction", "rtl");
  //       setState(() {
  //         EasyLocalization.of(context)!.setLocale(Locale('ar', 'AE'));
  //       });
  //     } else {
  //       languagesController.changeLanguage(box.read("language"));
  //       if (box.read("direction") == "ltr") {
  //         setState(() {
  //           EasyLocalization.of(context)!.setLocale(Locale('en', 'US'));
  //         });
  //       } else {
  //         setState(() {
  //           EasyLocalization.of(context)!.setLocale(Locale('ar', 'AE'));
  //         });
  //       }
  //     }

  //     sliderController.fetchSliderData();

  //     Get.toNamed(bottomnavscreen);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.blue, // Optional: makes status bar transparent
    ));

    return Scaffold(
      backgroundColor: Colors.blue,
      // backgroundColor: Color(0xffD2D2D2),
      body: Center(
        child: GestureDetector(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "WELCOME TO",
                style: GoogleFonts.bebasNeue(
                  // color: Color(0xff46558A),
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Watandaronline",
                style: GoogleFonts.bebasNeue(
                  // color: Color(0xff46558A),
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              Lottie.asset(
                'assets/loties/loading-01.json',
                height: 200,
                width: 200,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
