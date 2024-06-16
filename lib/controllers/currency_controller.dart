import 'package:get/get.dart';
import 'package:watantelecom/models/currency_model.dart';
import 'package:watantelecom/services/country_list_service.dart';
import 'package:watantelecom/services/currency_list_service.dart';

import '../models/country_list_model.dart';

class CurrencyListController extends GetxController {
  @override
  void onInit() {
    fetchCurrencyList();
    super.onInit();
  }

  var isLoading = false.obs;

  var allcurrencylist = CurrencyModel().obs;

  void fetchCurrencyList() async {
    try {
      isLoading(true);
      await CurrencyApi().fetchCurrency().then((value) {
        allcurrencylist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
