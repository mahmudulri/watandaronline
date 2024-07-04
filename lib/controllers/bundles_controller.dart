import 'package:get/get.dart';
import 'package:watantelecom/models/bundle_model.dart';
import 'package:watantelecom/models/categories_service_model.dart';
import 'package:watantelecom/models/service_model.dart';
import 'package:watantelecom/services/bundles_service.dart';
import 'package:watantelecom/services/categoris_service_list.dart';
import 'package:watantelecom/services/service_service.dart';

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
