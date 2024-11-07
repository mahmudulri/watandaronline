import 'package:get/get.dart';
import 'package:watandaronline/controllers/bundles_controller.dart';
import 'package:watandaronline/controllers/confirm_pin_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';

class RechargeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceController>(() => ServiceController());
    Get.lazyPut<BundleController>(() => BundleController());
    Get.lazyPut<ConfirmPinController>(() => ConfirmPinController());
  }
}
