import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:watantelecom/models/currency_model.dart';

import '../models/country_list_model.dart';
import '../utils/api_endpoints.dart';

class CurrencyApi {
  final box = GetStorage();
  Future<CurrencyModel> fetchCurrency() async {
    final url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.currency);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final currencyModel = CurrencyModel.fromJson(json.decode(response.body));

      return currencyModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}
