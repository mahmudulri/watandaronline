import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/utils/api_endpoints.dart';

class SignInController extends GetxController {
  final box = GetStorage();
  // TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final CountryListController countryListController =
      Get.put(CountryListController());

  RxBool isLoading = false.obs;
  RxBool loginsuccess = false.obs;

  Future<void> signIn() async {
    try {
      isLoading.value = true;
      loginsuccess.value = true;

      // var headers = {'Content-Type': 'application/json'};
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.loginIink);
      // Map body = {
      //   'password': "test@2024",
      //   'username': "0700930683",
      // };

      Map body = {
        'username': usernameController.text,
        'password': passwordController.text,
      };
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );
      print(jsonEncode(body));
      print(response.body.toString());
      print(response.statusCode.toString());
      final results = jsonDecode(response.body);
      if (response.statusCode == 200) {
        box.write("userToken", jsonDecode(response.body)["data"]["api_token"]);
        box.write("currency_code",
            jsonDecode(response.body)["data"]["user_info"]["currency"]["code"]);
        box.write(
            "currencypreferenceID",
            jsonDecode(response.body)["data"]["user_info"]
                ["currency_preference_id"]);
        box.write("currencyName",
            jsonDecode(response.body)["data"]["user_info"]["currency"]["name"]);
        // print(box.read("userToken"));
        countryListController.fetchCountryData();

        if (results["success"] == true) {
          // box.write("userToken", results["access_token"]);

          Fluttertoast.showToast(
              msg: results["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          isLoading.value = false;
          loginsuccess.value = false;

          // Get.to(() => BaseScreen());
          // emailController.clear();
          // passwordController.clear();
        } else {
          Get.snackbar(
            "Opps !",
            results["message"],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          isLoading.value = false;
          loginsuccess.value = true;
        }
      } else {
        Get.snackbar(
          "Opps !",
          results["message"],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        loginsuccess.value = true;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
