import 'package:get/get.dart';
import 'package:watandaronline/services/dashboard_service.dart';

import '../models/dashboard_data_model.dart';

class DashboardController extends GetxController {
  @override
  void onInit() {
    fetchDashboardData();
    super.onInit();
  }

  var isLoading = false.obs;

  var alldashboardData = DashboardDataModel().obs;

  void fetchDashboardData() async {
    try {
      isLoading(true);
      await DashboardApi().fetchDashboard().then((value) {
        alldashboardData.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
