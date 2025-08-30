import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/country_list_model.dart';
import '../utils/api_endpoints.dart';

class CountryListApi {
  final box = GetStorage();
  Future<CountryListModel> fetchCountryList() async {
    final url = Uri.parse(
        "https://api-vpro-hetz-25.watandaronline.com/api/public/countries");
    print(url);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      print(response.statusCode.toString());
      final countryModel =
          CountryListModel.fromJson(json.decode(response.body));

      return countryModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}
