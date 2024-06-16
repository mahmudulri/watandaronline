import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:watantelecom/bottom_nav_screen.dart';
import 'package:watantelecom/screens/onboarding_screen.dart';
import 'package:watantelecom/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () => checkData());

    super.initState();
  }

  checkData() async {
    var usertoken = await box.read('userToken');

    if (usertoken == null) {
      Get.to(() => OnboardingScreen());
    } else {
      Get.to(() => BottomNavigationbar());
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
                "Watantelecom",
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
