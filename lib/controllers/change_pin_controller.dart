import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/utils/api_endpoints.dart';

class ChangePinController extends GetxController {
  final box = GetStorage();
  // TextEditingController nameController = TextEditingController();
  TextEditingController oldPinController = TextEditingController();
  TextEditingController newPinController = TextEditingController();
  TextEditingController confirmPinController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> change() async {
    try {
      isLoading.value = true;

      // var headers = {'Content-Type': 'application/json'};
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}'
      };
      var url = Uri.parse("${ApiEndPoints.baseUrl}change_pin");
      // Map body = {
      //   'current_pin': "2222",
      //   'new_pin': "1111",
      // };

      Map body = {
        'current_pin': oldPinController.text,
        'new_pin': newPinController.text,
      };
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      print("body" + response.body.toString());
      print("statuscode" + response.statusCode.toString());
      final results = jsonDecode(response.body);
      if (response.statusCode == 200) {
        oldPinController.clear();
        newPinController.clear();
        if (results["success"] == true) {
          Fluttertoast.showToast(
              msg: results["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          isLoading.value = false;
        } else {
          Get.snackbar(
            "Opps !",
            results["message"],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
          "Opps !",
          results["message"],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setpin(id) async {
    try {
      isLoading.value = true;

      // var headers = {'Content-Type': 'application/json'};
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}'
      };
      var url = Uri.parse(
          "${ApiEndPoints.baseUrl}sub-resellers/set-sub-reseller-pin");
      print(url);

      Map body = {
        'sub_reseller_id': id.toString(),
        'new_pin': newPinController.text,
      };
      print(body);
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      print("body" + response.body.toString());
      print("statuscode" + response.statusCode.toString());
      final results = jsonDecode(response.body);
      if (response.statusCode == 200) {
        newPinController.clear();
        confirmPinController.clear();
        if (results["success"] == true) {
          Fluttertoast.showToast(
              msg: results["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          isLoading.value = false;
        } else {
          Get.snackbar(
            "Opps !",
            results["message"],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
          "Opps !",
          results["message"],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
