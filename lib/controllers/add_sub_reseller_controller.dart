import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:watandaronline/controllers/sub_reseller_controller.dart';
import 'package:watandaronline/models/transaction_model.dart';

import '../utils/api_endpoints.dart';

final subresellerController = Get.find<SubresellerController>();

class AddSubResellerController extends GetxController {
  var photoLink = ''.obs;

  var countryId = ''.obs;
  var provinceId = ''.obs;
  var districtID = ''.obs;
  var currencyID = ''.obs;

  TextEditingController resellerNameController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final box = GetStorage();
  var selectedImagePath = ''.obs;

  File? imageFile;

  RxBool isLoading = false.obs;

  Future<void> uploadImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImageFile != null) {
      selectedImagePath.value = pickedImageFile.path;
      imageFile = File(pickedImageFile.path);
      print(" before image tag   " + imageFile.toString());
    } else {
      print("No image selected");
    }
  }

  Future<void> addNow() async {
    try {
      isLoading.value = true;

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}',
      };

      Map<String, String> body = {
        'reseller_name': resellerNameController.text,
        'contact_name': contactNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'country_id': countryId.toString(),
        'province_id': provinceId.toString(),
        'districts_id': districtID.toString(),
        'currency_preference_id': box.read("currencypreferenceID").toString(),
      };

      var url = Uri.parse(
        "${ApiEndPoints.baseUrl}sub-resellers",
      );

      var request = http.MultipartRequest('POST', url);

      request.headers.addAll(headers);

      if (selectedImagePath.value.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_image_url', selectedImagePath.value.toString(),
            filename: "photo"));
      }

      request.fields.addAll(body);

      var responsed = await request.send();

      print(responsed.statusCode.toString());

      var response1 = await http.Response.fromStream(responsed);
      print(response1.body.toString());

      var response = jsonDecode(response1.body.toString());

      if (responsed.statusCode == 201) {
        Get.back();
        print("success");
        Fluttertoast.showToast(
            msg: "Successfully Created",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        subresellerController.fetchSubReseller();
        resellerNameController.clear();
        contactNameController.clear();
        emailController.clear();
        phoneController.clear();
        currencyID.value = '';
        countryId.value = '';
        provinceId.value = '';
        districtID.value = '';

        selectedImagePath.value = '';
        imageFile = null;

        isLoading.value = false;
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Wrong",
          "Something error",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print("Error");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
