import 'package:get/get.dart';

import '../models/country_list_model.dart';
import '../models/loan_balance_model.dart';
import '../services/loan_balance_service.dart';

class LoanlistController extends GetxController {
  var isLoading = false.obs;

  var allloanlist = LoanBalanceModel().obs;

  void fetchLoan() async {
    try {
      isLoading(true);
      await LoanBalanceApi().fetchbalance().then((value) {
        allloanlist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
