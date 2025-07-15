import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:watandaronline/controllers/custom_history_controller.dart';
import 'package:watandaronline/utils/api_endpoints.dart';

import '../global controller/languages_controller.dart';

class CustomRechargeController extends GetxController {
  TextEditingController numberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final box = GetStorage();

  TextEditingController pinController = TextEditingController();

  final customhistoryController = Get.find<CustomHistoryController>();

  final languagesController = Get.find<LanguagesController>();

  RxBool isLoading = false.obs;

  RxBool loadsuccess = false.obs;
  RxBool showanimation = false.obs;
  void placeOrder() async {
    try {
      isLoading.value = true;
      loadsuccess.value = false; // Default to false until success

      var url = Uri.parse(
          "${ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.customrecharge}");
      print(url);
      Map body = {
        'country_id': box.read("country_id"),
        'rechargeble_account': numberController.text,
        'amount': amountController.text,
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read("userToken")}',
        },
      );

      final orderresults = jsonDecode(response.body);
      if (response.statusCode == 201 && orderresults["success"] == true) {
        loadsuccess.value = true; // Indicate success
        isLoading.value = false;
        customhistoryController.finalList.clear();
        customhistoryController.initialpage = 1;
        customhistoryController.fetchHistory();

        Get.snackbar(
          languagesController.tr("SUCCESS"),
          orderresults["message"],
        );
        clearInputs();
      } else {
        handleFailure(orderresults["message"]);
      }
    } catch (e) {
      handleFailure(e.toString());
    }
  }

  void handleFailure(String message) {
    loadsuccess.value = false;

    isLoading.value = false;
    Get.snackbar("Error", message,
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  void clearInputs() {
    numberController.clear();
    amountController.clear();
  }
}
