import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:watandaronline/models/orders_list_model.dart';
import 'package:watandaronline/models/service_model.dart';

import '../controllers/order_list_controller.dart';

import '../models/sub_reseller_model.dart';
import '../utils/api_endpoints.dart';

class ServiceListApi {
  final box = GetStorage();
  Future<ServiceModel> fetchservicelist() async {
    final url = Uri.parse(
        "${ApiEndPoints.baseUrl}services?service_category_id=${box.read("service_category_id")}&country_id=${box.read("country_id")}");
    print(url);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      print(response.body.toString());
      final servicelistModel =
          ServiceModel.fromJson(json.decode(response.body));

      return servicelistModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}
