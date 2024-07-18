import 'package:get/get.dart';
import 'package:watandaronline/models/bundle_model.dart';
import 'package:watandaronline/models/categories_service_model.dart';
import 'package:watandaronline/models/service_model.dart';
import 'package:watandaronline/services/bundles_service.dart';
import 'package:watandaronline/services/categoris_service_list.dart';
import 'package:watandaronline/services/service_service.dart';

class BundleController extends GetxController {
  // @override
  // void onInit() {
  //   fetchbundles();
  //   super.onInit();
  // }
  int initialpage = 1;

  RxList<Bundle> finalList = <Bundle>[].obs;
  var isLoading = false.obs;

  var allbundleslist = BundleModel().obs;

  void fetchallbundles() async {
    try {
      isLoading(true);
      await BundlesApi().fetchBundles(initialpage).then((value) {
        allbundleslist.value = value;

        if (allbundleslist.value.data != null &&
            allbundleslist.value.data!.bundles != null) {
          finalList.addAll(allbundleslist.value.data!.bundles!);
        }

        // print(finalList.length.toString());
        // finalList.forEach((order) {
        //   print(order.id.toString());
        // });

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
