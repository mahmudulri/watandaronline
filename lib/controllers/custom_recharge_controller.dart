import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:watandaronline/utils/api_endpoints.dart';

class CustomRechargeController extends GetxController {
  TextEditingController numberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final box = GetStorage();

  TextEditingController pinController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool placeingLoading = false.obs;

  RxBool loadsuccess = false.obs;

  Future<void> verify() async {
    try {
      isLoading.value = true;
      loadsuccess.value =
          false; // Start with false, only set to true if successful.

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      var url = Uri.parse(
          "${ApiEndPoints.baseUrl}confirm_pin?pin=${pinController.text}");
      print(url.toString());

      http.Response response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${box.read("userToken")}',
        },
      );

      final results = jsonDecode(response.body);

      if (response.statusCode == 200 && results["success"] == true) {
        pinController.clear();
        loadsuccess.value =
            true; // Mark as successful only if status and success are correct

        // Proceed with placing the order
        placeOrder();
      } else {
        handleFailure(results["message"]);
      }
    } catch (e) {
      handleFailure(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void placeOrder() async {
    try {
      placeingLoading.value = true;
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
        loadsuccess.value = false;
        clearInputs();
        box.remove("bundleID");
        placeingLoading.value = false;
      } else {
        handleFailure(orderresults["message"]);
      }
    } catch (e) {
      handleFailure(e.toString());
    }
  }

  void handleFailure(String message) {
    loadsuccess.value = false;
    placeingLoading.value = false;
    Get.snackbar("Error", message,
        backgroundColor: Colors.red, colorText: Colors.white);
    clearInputs();
  }

  void clearInputs() {
    pinController.clear();
    numberController.clear();
  }
}
