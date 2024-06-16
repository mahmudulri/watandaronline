import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:watantelecom/models/bundle_model.dart';

import '../utils/api_endpoints.dart';

class BundlesApi {
  final box = GetStorage();
  Future<BundleModel> fetchBundles() async {
    final url = Uri.parse(
        "${ApiEndPoints.baseUrl}bundles?country_id=${box.read("country_id")}&validity_type=${box.read("validity_type")}&company_id=${box.read("company_id")}&service_category_id=${box.read("service_category_id")}");
    print(url);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final bundleModel = BundleModel.fromJson(json.decode(response.body));

      return bundleModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}
