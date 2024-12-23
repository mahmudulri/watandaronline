// import 'package:get/get.dart';
// import 'package:watandaronline/models/categories_service_model.dart';
// import 'package:watandaronline/services/categoris_service_list.dart';
// import 'package:watandaronline/services/country_list_service.dart';

// import '../models/country_list_model.dart';

// class CategorisListController extends GetxController {
//   @override
//   void onInit() {
//     fetchcategories();
//     super.onInit();
//   }

//   var isLoading = false.obs;

//   var allcategorieslist = CategoriesModel().obs;
//   var finalcatlist = [];

//   void fetchcategories() async {
//     try {
//       isLoading(true);
//       await CategoriesListApi().fetchcategoriesList().then((value) {
//         allcategorieslist.value = value;

//         print(allcategorieslist.toJson());

//         isLoading(false);
//       });

//       isLoading(false);
//     } catch (e) {
//       print(e.toString());
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:watandaronline/models/categories_service_model.dart';
import 'package:watandaronline/services/categoris_service_list.dart';

class CategorisListController extends GetxController {
  @override
  void onInit() {
    fetchcategories();
    super.onInit();
  }

  var isLoading = false.obs;

  // Complete list of categories
  var allcategorieslist = CategoriesModel().obs;

  // Filtered list for "type": "nonsocial"
  var nonsocialCategories = <Servicecategory>[].obs;

  void fetchcategories() async {
    try {
      isLoading(true);
      await CategoriesListApi().fetchcategoriesList().then((value) {
        allcategorieslist.value = value;

        // Filter "nonsocial" categories
        nonsocialCategories.value = allcategorieslist
            .value.data!.servicecategories
            .where((category) => category.type == "nonsocial")
            .toList();

        print(
            "Filtered Categories: ${nonsocialCategories.map((e) => e.toJson()).toList()}");

        isLoading(false);
      });
    } catch (e) {
      print("Error: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }
}
