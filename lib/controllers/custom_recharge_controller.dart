import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:watandaronline/controllers/history_controller.dart';
import 'package:watandaronline/utils/api_endpoints.dart';

class CustomRechargeController extends GetxController {
  TextEditingController numberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final box = GetStorage();

  // TextEditingController pinController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool placeingLoading = false.obs;

  RxBool loadsuccess = false.obs;

  Future<void> dorecharge() async {
    try {
      isLoading.value = true;
      placeingLoading.value == true;
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      var url = Uri.parse(
          "${ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.customrecharge}");
      Map body = {
        'country_id': box.read("country_id"),
        'rechargeble_account': numberController.text,
        'amount': amountController.text,
      };
      http.Response response = await http.post(
        url,
        body: body,
        headers: {
          'Authorization': 'Bearer ${box.read("userToken")}',
        },
      );

      // print(response.body.toString());
      print("statuscode" + response.statusCode.toString());

      final orderresults = jsonDecode(response.body);
      print(orderresults);

      if (response.statusCode == 201) {
        if (orderresults["success"] == true) {
          Get.snackbar(
            "Done",
            orderresults["message"],
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          isLoading.value = false;
          loadsuccess.value = false;

          numberController.clear();

          amountController.clear();

          placeingLoading.value = false;
        } else {
          Get.snackbar(
            "",
            orderresults["message"],
            backgroundColor: Colors.grey,
            colorText: Colors.black,
          );
          placeingLoading.value = false;

          Get.snackbar(
            "",
            orderresults["message"],
            backgroundColor: Colors.grey,
            colorText: Colors.black,
          );
          placeingLoading.value = false;
        }
      } else {
        Get.snackbar(
          "Error",
          orderresults["message"],
          backgroundColor: Colors.grey,
          colorText: Colors.black,
        );
        isLoading.value = false;

        numberController.clear();

        amountController.clear();

        numberController.clear();
        placeingLoading.value = false;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
