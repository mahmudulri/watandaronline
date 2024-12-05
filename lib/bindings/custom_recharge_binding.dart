import 'package:get/get.dart';
import 'package:watandaronline/controllers/custom_history_controller.dart';
import 'package:watandaronline/controllers/custom_recharge_controller.dart';
import 'package:watandaronline/controllers/history_controller.dart';

class CustomRechargeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomRechargeController>(() => CustomRechargeController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<CustomHistoryController>(() => CustomHistoryController());
  }
}
