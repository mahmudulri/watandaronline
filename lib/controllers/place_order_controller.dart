// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:yaktelecom/bottom_nav_screen.dart';
// import 'package:yaktelecom/controllers/confirm_pin_controller.dart';
// import 'package:yaktelecom/controllers/country_list_controller.dart';
// import 'package:yaktelecom/utils/api_endpoints.dart';

// final ConfirmPinController controller = Get.put(ConfirmPinController());

// class PlaceOrderController extends GetxController {
//   TextEditingController numberController = TextEditingController();

//   RxBool isLoading = false.obs;
//   RxBool loginsuccess = false.obs;
//   final box = GetStorage();

//   Future<void> placeOrder() async {
//     try {
//       isLoading.value = true;
//       loginsuccess.value = true;

//       // var headers = {'Content-Type': 'application/json'};
//       var headers = {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       };
//       var url = Uri.parse("${ApiEndPoints.baseUrl}place_order");
//       Map body = {
//         'bundle_id': box.read("bundleID"),
//         'rechargeble_account': numberController.text,
//       };
//       // print(url);

//       // Map body = {
//       //   'username': usernameController.text,
//       //   'password': passwordController.text,
//       // };
//       http.Response response = await http.post(
//         url,
//         body: body,
//         headers: {
//           'Authorization': 'Bearer ${box.read("userToken")}',
//         },
//       );
//       // print(box.read("userToken"));
//       print("body" + body.toString());

//       // print(response.body.toString());
//       print("statuscode" + response.statusCode.toString());
//       final results = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         controller.pinController.clear();
//         if (results["success"] == true) {
//           controller.pinController.clear();
//           numberController.clear();
//           box.remove("bundleID");
//           Fluttertoast.showToast(
//               msg: results["message"],
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.green,
//               textColor: Colors.white,
//               fontSize: 16.0);

//           isLoading.value = false;
//           loginsuccess.value = false;

//           // emailController.clear();
//           // passwordController.clear();
//         } else {
//           controller.pinController.clear();
//           numberController.clear();
//           box.remove("bundleID");
//           Get.snackbar(
//             "",
//             results["message"],
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//           isLoading.value = false;
//           loginsuccess.value = true;
//         }
//       } else {
//         controller.pinController.clear();
//         numberController.clear();
//         box.remove("bundleID");

//         Get.snackbar(
//           "",
//           results["message"],
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//         isLoading.value = false;
//         loginsuccess.value = true;
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }
// }
