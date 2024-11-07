import 'package:get/get.dart';
import 'package:watandaronline/controllers/add_sub_reseller_controller.dart';
import 'package:watandaronline/controllers/currency_controller.dart';
import 'package:watandaronline/controllers/district_controller.dart';
import 'package:watandaronline/controllers/province_controller.dart';

class AddSubResellerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProvinceController>(() => ProvinceController());

    Get.lazyPut<CurrencyListController>(() => CurrencyListController());

    Get.lazyPut<DistrictController>(() => DistrictController());

    Get.lazyPut<AddSubResellerController>(() => AddSubResellerController());
  }
}
