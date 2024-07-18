import 'package:get/get.dart';
import 'package:watandaronline/services/dashboard_service.dart';
import 'package:watandaronline/services/sub_reseller_service.dart';

import '../models/dashboard_data_model.dart';
import '../models/sub_reseller_model.dart';
import '../models/subreseller_details_model.dart';
import '../services/subreseller_details_service.dart';

class SubresellerDetailsController extends GetxController {
  @override
  // void onInit() {
  //   fetchSubResellerDetails();
  //   super.onInit();
  // }

  var isLoading = false.obs;

  var allsubresellerDetailsData = SubresellerDetailsModel().obs;

  void fetchSubResellerDetails(String myid) async {
    try {
      isLoading(true);
      await SubResellerDetailsApi().fetchSubResellerDetails(myid).then((value) {
        allsubresellerDetailsData.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
