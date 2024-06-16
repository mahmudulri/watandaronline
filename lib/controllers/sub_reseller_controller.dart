import 'package:get/get.dart';
import 'package:watantelecom/services/dashboard_service.dart';
import 'package:watantelecom/services/sub_reseller_service.dart';

import '../models/dashboard_data_model.dart';
import '../models/sub_reseller_model.dart';

class SubresellerController extends GetxController {
  @override
  void onInit() {
    fetchSubReseller();
    super.onInit();
  }

  var isLoading = false.obs;

  var allsubresellerData = SubResellerModel().obs;

  void fetchSubReseller() async {
    try {
      isLoading(true);
      await SubResellerApi().fetchSubReseller().then((value) {
        allsubresellerData.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
