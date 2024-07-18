import 'package:get/get.dart';
import 'package:watandaronline/models/categories_service_model.dart';
import 'package:watandaronline/models/service_model.dart';
import 'package:watandaronline/services/categoris_service_list.dart';
import 'package:watandaronline/services/service_service.dart';

class ServiceController extends GetxController {
  @override
  void onInit() {
    fetchservices();
    super.onInit();
  }

  var isLoading = false.obs;

  var allserviceslist = ServiceModel().obs;

  void fetchservices() async {
    try {
      isLoading(true);
      await ServiceListApi().fetchservicelist().then((value) {
        allserviceslist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
