import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LanguagesController extends GetxController {
  RxString selectedlan = "En".obs; // Default language
  RxMap<String, String> currentlanguage = <String, String>{}.obs;

  List<Map<String, String>> alllanguagedata = [
    {
      "name": "En",
      "fullname": "English",
      "isoCode": "en",
      "direction": "ltr",
    },
    {
      "name": "Fa",
      "fullname": "فارسی",
      "isoCode": "fa",
      "direction": "rtl",
    },
    {
      "name": "Ar",
      "fullname": "العربية",
      "isoCode": "ar",
      "direction": "rtl",
    },
    {
      "name": "Tr",
      "fullname": "Türkçe",
      "isoCode": "tr",
      "direction": "ltr",
    },
    {
      "name": "Ps",
      "fullname": "پښتو",
      "isoCode": "ps",
      "direction": "rtl",
    },
    {
      "name": "Bn",
      "fullname": "বাংলা",
      "isoCode": "bn",
      "direction": "ltr",
    },
  ];

  @override
  void onInit() {
    super.onInit();
    loadLanguage("en"); // Load default language
  }

  // Load language JSON file
  Future<void> loadLanguage(String languageCode) async {
    try {
      print("📂 Loading JSON: assets/langs/$languageCode.json"); // Debug log
      String jsonString =
          await rootBundle.loadString("assets/langs/$languageCode.json");
      Map<String, dynamic> jsonData = json.decode(jsonString);

      // ✅ Ensure updates are detected in Obx()
      currentlanguage.clear();
      currentlanguage.addAll(
          jsonData.map((key, value) => MapEntry(key, value.toString())));

      // print("✅ Loaded Language Data: $currentlanguage"); // Debugging
    } catch (e) {
      print("❌ Error loading language file: $e");
    }
  }

  // Change language dynamically
  void changeLanguage(String language) {
    print("🔄 Changing Language to: $language");
    selectedlan.value = language;

    loadLanguage(language.toLowerCase()).then((_) {
      // print("✅ Language Loaded: ${selectedlan.value}");
      // print("📝 LOGIN TEXT: ${currentlanguage['LOGIN']}"); // Debugging
    });
  }

  // ✅ Define tr() method to fetch translated text
  String tr(String key) {
    return currentlanguage[key] ?? key; // Returns key if translation is missing
  }
}
