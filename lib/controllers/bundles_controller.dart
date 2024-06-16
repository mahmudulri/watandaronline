import 'package:get/get.dart';
import 'package:watantelecom/models/bundle_model.dart';
import 'package:watantelecom/models/categories_service_model.dart';
import 'package:watantelecom/models/service_model.dart';
import 'package:watantelecom/services/bundles_service.dart';
import 'package:watantelecom/services/categoris_service_list.dart';
import 'package:watantelecom/services/service_service.dart';

class BundleController extends GetxController {
  @override
  void onInit() {
    fetchbundles();
    super.onInit();
  }

  var isLoading = false.obs;

  var allbundleslist = BundleModel().obs;

  void fetchbundles() async {
    try {
      isLoading(true);
      await BundlesApi().fetchBundles().then((value) {
        allbundleslist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
