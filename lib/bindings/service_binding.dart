import 'package:get/get.dart';
import 'package:watandaronline/controllers/bundles_controller.dart';
import 'package:watandaronline/controllers/categories_list_controller.dart';
import 'package:watandaronline/controllers/custom_recharge_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';

import '../controllers/confirm_pin_controller.dart';

class ServiceBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BundleController>(() => BundleController());
    Get.lazyPut<CategorisListController>(() => CategorisListController());
    Get.lazyPut<ServiceController>(() => ServiceController());
    Get.lazyPut<CustomRechargeController>(() => CustomRechargeController());
    Get.lazyPut<ConfirmPinController>(() => ConfirmPinController());
  }
}
