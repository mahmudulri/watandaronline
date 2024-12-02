import 'package:get/get.dart';
import 'package:watandaronline/controllers/custom_recharge_controller.dart';

class CustomRechargeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomRechargeController>(() => CustomRechargeController());
  }
}
