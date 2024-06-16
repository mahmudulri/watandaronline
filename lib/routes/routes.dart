import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watantelecom/splash_screen.dart';

const String splash = '/splash-screen';

// control all pages from here

Map<String, WidgetBuilder> mypagemap = {
  splash: (context) => SplashScreen(),
};

List<GetPage> getPages = [
  GetPage(
    name: splash,
    page: () => SplashScreen(),
  ),
];
