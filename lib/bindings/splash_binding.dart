import 'package:get/get.dart';
import 'package:watandaronline/controllers/iso_code_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/slider_controller.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageController>(() => LanguageController());
    Get.lazyPut<IscoCodeController>(() => IscoCodeController());
    Get.lazyPut<SliderController>(() => SliderController());
  }
}
