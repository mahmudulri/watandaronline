import 'package:get/get.dart';
import 'package:watantelecom/models/currency_model.dart';
import 'package:watantelecom/models/district_model.dart';
import 'package:watantelecom/models/province_model.dart';
import 'package:watantelecom/services/country_list_service.dart';
import 'package:watantelecom/services/currency_list_service.dart';
import 'package:watantelecom/services/district_service.dart';
import 'package:watantelecom/services/province_service.dart';

import '../models/country_list_model.dart';

class DistrictController extends GetxController {
  @override
  void onInit() {
    fetchDistrict();
    super.onInit();
  }

  var isLoading = false.obs;

  var alldistrictList = DistrictModel().obs;

  void fetchDistrict() async {
    try {
      isLoading(true);
      await DistrictApi().fetchDistrict().then((value) {
        alldistrictList.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
