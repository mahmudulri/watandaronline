import 'package:get/get.dart';
import 'package:watandaronline/models/categories_service_model.dart';
import 'package:watandaronline/services/categoris_service_list.dart';
import 'package:watandaronline/services/country_list_service.dart';

import '../models/country_list_model.dart';

class CategorisListController extends GetxController {
  @override
  void onInit() {
    fetchcategories();
    super.onInit();
  }

  var isLoading = false.obs;

  var allcategorieslist = CategoriesModel().obs;

  void fetchcategories() async {
    try {
      isLoading(true);
      await CategoriesListApi().fetchcategoriesList().then((value) {
        allcategorieslist.value = value;
        // print(allcategorieslist.toJson()['data']['vehicles']);

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
