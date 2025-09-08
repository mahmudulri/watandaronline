import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/controllers/time_zone_controller.dart';
import 'package:watandaronline/routes/routes.dart';
import 'package:watandaronline/splash_screen.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await GetStorage.init();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAHf2sH4VaGRej1dY0X8HmLGHWM4oXIdzU",
      authDomain: "watandaronlinewoosat.firebaseapp.com",
      projectId: "watandaronlinewoosat",
      storageBucket: "watandaronlinewoosat.firebasestorage.app",
      messagingSenderId: "849035657162",
      appId: "1:849035657162:web:f5aaa9e02c6f68b9c01933",
    ),
  );
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('fa', 'IR'),
        Locale('ar', 'AE'),
        Locale('ps', 'AF'),
        Locale('tr', 'TR'),
        Locale('bn', 'BD'),
      ],
      path: 'assets/langs',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
  // used for check real time internet access
  DependencyInjection.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  final TimeZoneController timeZoneController = Get.put(TimeZoneController());
  @override
  void initState() {
    super.initState();
    gettimezone();
  }

  Future<void> gettimezone() async {
    timeZoneController.myzone = await FlutterTimezone.getLocalTimezone();
    timeZoneController.setTimezoneOffset();
    timeZoneController.extractTimeDetails();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: splash,
      getPages: myroutes,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Schedule locale update after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.updateLocale(context.locale);
    });
  }
}
