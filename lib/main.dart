import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/controllers/time_zone_controller.dart';
import 'package:watandaronline/draftcode.dart';
import 'package:watandaronline/routes/routes.dart';
import 'package:watandaronline/splash_screen.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'AE'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // localizationsDelegates: context.localizationDelegates,
      // supportedLocales: context.supportedLocales,
      // locale: context.locale,
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: Startpage(),
    );
  }
}

class Startpage extends StatelessWidget {
  Startpage({super.key});

  final box = GetStorage();

  final TimeZoneController timeZoneController = Get.put(TimeZoneController());

  myfunction() async {
    box.write("timezone", await FlutterTimezone.getLocalTimezone());
    timeZoneController.fetchTimeData();
  }

  @override
  Widget build(BuildContext context) {
    myfunction();
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: splash,
      routes: mypagemap,
    );
  }
}
