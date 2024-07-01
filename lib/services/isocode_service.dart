import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:watantelecom/models/district_model.dart';
import 'package:watantelecom/models/isocode_model.dart';
import 'package:watantelecom/models/province_model.dart';

import '../models/country_list_model.dart';
import '../models/language_model.dart';
import '../utils/api_endpoints.dart';

class IsoCodeApi {
  final box = GetStorage();
  Future<IsoCodeModel> fetchIsoCode() async {
    final url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.languages);
    print(url);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      print(response.body.toString());
      final isoCodeModel = IsoCodeModel.fromJson(json.decode(response.body));

      return isoCodeModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}
