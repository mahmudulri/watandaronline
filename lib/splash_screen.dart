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
import 'package:watandaronline/screens/onboarding_screen.dart';
import 'package:watandaronline/utils/colors.dart';

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

  final LanguageController languageController = Get.put(LanguageController());
  final IscoCodeController iscoCodeController = Get.put(IscoCodeController());

  final SliderController sliderController = Get.put(SliderController());
  checkData() async {
    // if (box.read("isoCode") == null) {
    //   languageController.fetchlanData("en");
    //   box.write("isoCode", "en");
    // } else {
    //   print("has data");
    //   languageController.fetchlanData(box.read("isoCode"));
    // }

    if (box.read('userToken') == null) {
      box.write("isoCode", "fa");
      box.write("direction", "rtl");
      languageController.fetchlanData("fa");

      setState(() {
        EasyLocalization.of(context)!.setLocale(Locale('ar', 'AE'));
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OnboardingScreen(),
        ),
      );
    } else {
      languageController.fetchlanData(box.read("isoCode"));
      sliderController.fetchSliderData();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationbar(),
        ),
      );
    }
  }

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
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    box.write("myname", "Mahmudul hasan");
                  });
                },
                child: Text("Add"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    box.remove("myname");
                  });
                },
                child: Text("Delete"),
              ),
              Text(box.read("userToken").toString()),
            ],
          ),
        ),
      ),
    );
  }
}
