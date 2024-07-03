import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:watantelecom/models/history_model.dart';
import 'package:watantelecom/models/orders_list_model.dart';

import '../controllers/order_list_controller.dart';

import '../models/sub_reseller_model.dart';
import '../utils/api_endpoints.dart';

class HistoryServiceApi {
  // OrderlistController orderlistController = Get.put(OrderlistController());
  final box = GetStorage();
  Future<HistoryModel> fetchHistory() async {
    final url = Uri.parse(
        "${ApiEndPoints.baseUrl}orders?page=${box.read("pageNo").toString()}${box.read("orderstatus").toString()}&selected_Date=&&");
    // print(url);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final orderlistModel = HistoryModel.fromJson(json.decode(response.body));

      return orderlistModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}
