import 'package:get/get.dart';
import 'package:watandaronline/controllers/change_pin_controller.dart';

class MyProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePinController>(() => ChangePinController());
  }
}
