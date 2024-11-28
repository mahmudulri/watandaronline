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

  TextEditingController pinController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool placeingLoading = false.obs;

  RxBool loadsuccess = false.obs;

  Future<void> dorecharge() async {
    try {
      isLoading.value = true;
      loadsuccess.value = true;

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      var url = Uri.parse(
          "${ApiEndPoints.baseUrl}confirm_pin?pin=${pinController.text.toString()}");
      print(url.toString());

      http.Response response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${box.read("userToken")}',
        },
      );

      final results = jsonDecode(response.body);

      if (response.statusCode == 200) {
        pinController.clear();
        // numberController.clear();
        if (results["success"] == true) {
          isLoading.value = false;

          try {
            placeingLoading.value == true;
            var headers = {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            };
            var url = Uri.parse(
                "${ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.customrecharge}");
            Map body = {
              'country_id': box.read("country_id"),
              'phone_number': numberController.text,
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
            if (response.statusCode == 201) {
              if (results["success"] == true) {
                loadsuccess.value = false;

                numberController.clear();
                pinController.clear();
                amountController.clear();

                placeingLoading.value = false;
              } else {
                pinController.clear();
                Get.snackbar(
                  "Done",
                  orderresults["message"],
                  backgroundColor: Colors.grey,
                  colorText: Colors.black,
                );
                placeingLoading.value = false;

                Get.snackbar(
                  "Done",
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
              pinController.clear();
              numberController.clear();

              amountController.clear();

              pinController.clear();
              numberController.clear();
              placeingLoading.value = false;
            }
          } catch (e) {
            print(e.toString());
          }
        } else {
          Get.snackbar(
            "Error !",
            results["message"],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          placeingLoading.value = false;
        }
      } else {
        // pinController.clear();
        // numberController.clear();
        Get.snackbar(
          "Error !",
          results["message"],
          backgroundColor: Colors.grey,
          colorText: Colors.black,
        );
        isLoading.value = false;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
