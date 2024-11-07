import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/controllers/time_zone_controller.dart';
import 'package:watandaronline/draftcode.dart';
import 'package:watandaronline/routes/routes.dart';
import 'package:watandaronline/splash_screen.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await GetStorage.init();
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
  DependencyInjection.init(); // used for check real time internet access
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

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       // localizationsDelegates: context.localizationDelegates,
//       // supportedLocales: context.supportedLocales,
//       // locale: context.locale,
//       debugShowCheckedModeBanner: false,

//       theme: ThemeData(
//         // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: false,
//       ),
     
//     );
//   }
// }

// class Startpage extends StatelessWidget {
//   Startpage({super.key});

//   // final box = GetStorage();

//   final TimeZoneController timeZoneController = Get.put(TimeZoneController());

//   gettimezone() async {
//     // box.write("timezone", await FlutterTimezone.getLocalTimezone());

//     timeZoneController.myzone = await FlutterTimezone.getLocalTimezone();
//     timeZoneController.setTimezoneOffset();
//     timeZoneController.extractTimeDetails();
//     // timeZoneController.fetchTimeData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     gettimezone();
//     return MaterialApp(
//       localizationsDelegates: context.localizationDelegates,
//       supportedLocales: context.supportedLocales,
//       locale: context.locale,
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute: splash,
//       routes: mypagemap,
//     );
//   }
// }
