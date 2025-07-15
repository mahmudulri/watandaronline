import 'package:get/get.dart';

import '../controllers/add_selling_price_controller.dart';
import '../controllers/delete_selling_price_controller.dart';

import '../controllers/only_cat_controller.dart';
import '../controllers/only_service_controller.dart';
import '../controllers/selling_price_controller.dart';

class SellingPriceBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellingPriceController>(() => SellingPriceController());
    Get.lazyPut<OnlyServiceController>(() => OnlyServiceController());
    Get.lazyPut<DeleteSellingPriceController>(
        () => DeleteSellingPriceController());
    Get.lazyPut<OnlyCatController>(() => OnlyCatController());
    Get.lazyPut<AddSellingPriceController>(() => AddSellingPriceController());
  }
}
