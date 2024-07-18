import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:watandaronline/screens/result_screen.dart';
import 'package:watandaronline/utils/api_endpoints.dart';

class ConfirmPinController extends GetxController {
  TextEditingController numberController = TextEditingController();
  final box = GetStorage();

  TextEditingController pinController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool placeingLoading = false.obs;

  Future<void> verify() async {
    try {
      isLoading.value = true;

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      var url = Uri.parse(
          "${ApiEndPoints.baseUrl}confirm_pin?pin=${pinController.text}");

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
            var url = Uri.parse("${ApiEndPoints.baseUrl}place_order");
            Map body = {
              'bundle_id': box.read("bundleID"),
              'rechargeble_account': numberController.text,
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
                Get.to(() => ResultScreen());
                numberController.clear();
                pinController.clear();

                box.remove("bundleID");

                placeingLoading.value = false;
              } else {
                pinController.clear();

                box.remove("bundleID");
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
              box.remove("bundleID");

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
