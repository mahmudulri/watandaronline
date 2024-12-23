import 'package:get/get.dart';
import 'package:watandaronline/controllers/bundles_controller.dart';
import 'package:watandaronline/controllers/categories_list_controller.dart';
import 'package:watandaronline/controllers/confirm_pin_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';

class NewServiceBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BundleController>(() => BundleController());
    Get.lazyPut<CategorisListController>(() => CategorisListController());
    Get.lazyPut<ServiceController>(() => ServiceController());
    // Get.lazyPut<ReserveDigitController>(() => ReserveDigitController());
    Get.lazyPut<ConfirmPinController>(() => ConfirmPinController());
  }
}
