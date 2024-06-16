import 'package:get/get.dart';
import 'package:watantelecom/models/currency_model.dart';
import 'package:watantelecom/models/province_model.dart';
import 'package:watantelecom/services/country_list_service.dart';
import 'package:watantelecom/services/currency_list_service.dart';
import 'package:watantelecom/services/province_service.dart';

import '../models/country_list_model.dart';

class ProvinceController extends GetxController {
  @override
  void onInit() {
    fetchProvince();
    super.onInit();
  }

  var isLoading = false.obs;

  var allprovincelist = ProvincesModel().obs;

  void fetchProvince() async {
    try {
      isLoading(true);
      await ProvinceApi().fetchProvince().then((value) {
        allprovincelist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
