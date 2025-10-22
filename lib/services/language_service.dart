import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:watandaronline/models/district_model.dart';
import 'package:watandaronline/models/province_model.dart';

import '../models/country_list_model.dart';
import '../models/language_model.dart';
import '../utils/api_endpoints.dart';

// class LanguageApi {
//   final box = GetStorage();
//   Future<LanguageModel> fetchLanguage(String isoCode) async {
//     final url = Uri.parse(ApiEndPoints.languageUrl + isoCode);
//     print(url);

//     var response = await http.get(url);

//     if (response.statusCode == 200) {
//       // print(response.body.toString());

//       final languageModel = LanguageModel.fromJson(json.decode(response.body));
//       // print(languageModel.toJson()['language_data'].toString());

//       return languageModel;
//     } else {
//       throw Exception('Failed to fetch gateway');
//     }
//   }
// }
