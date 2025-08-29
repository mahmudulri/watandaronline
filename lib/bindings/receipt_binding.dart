import 'package:get/get.dart';

import '../controllers/payments_controller.dart';

class ReceiptBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentsController>(() => PaymentsController());
  }
}
