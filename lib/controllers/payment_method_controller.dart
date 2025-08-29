import 'package:get/get.dart';
import '../models/payment_method_model.dart';
import '../services/payment_method_service.dart';

class PaymentMethodController extends GetxController {
  var isLoading = false.obs;

  var allmethods = PaymentMethodModel().obs;

  void fetchmethods() async {
    try {
      isLoading(true);
      await PaymentMethodSApi().fetchmethod().then((value) {
        allmethods.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
