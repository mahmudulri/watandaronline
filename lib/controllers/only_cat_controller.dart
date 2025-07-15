import 'package:get/get.dart';

import '../models/categories_service_model.dart';
import '../services/categoris_service_list.dart';

class OnlyCatController extends GetxController {
  @override
  void onInit() {
    fetchcategories();
    super.onInit();
  }

  var isLoading = false.obs;

  var onlycategorieslist = CategoriesModel().obs;

  // }

  void fetchcategories() async {
    try {
      isLoading(true);
      await CategoriesListApi().fetchcategoriesList().then((value) {
        // Filter to keep only categories that have services
        value.data!.servicecategories!.removeWhere((category) =>
            category.services == null || category.services!.isEmpty);

        // Assign filtered list to observable
        onlycategorieslist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
