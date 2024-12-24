import 'package:get/get.dart';
import 'package:watandaronline/models/categories_service_model.dart';
import 'package:watandaronline/services/categoris_service_list.dart';
import 'package:watandaronline/services/country_list_service.dart';

import '../models/country_list_model.dart';

// class CategorisListController extends GetxController {
//   @override
//   void onInit() {
//     fetchcategories();
//     super.onInit();
//   }

//   var isLoading = false.obs;

//   var allcategorieslist = CategoriesModel().obs;
//   var countrylist = <Map<String, dynamic>>[].obs;

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

class CategorisListController extends GetxController {
  @override
  void onInit() {
    fetchcategories();
    super.onInit();
  }

  var isLoading = false.obs;
  var allcategorieslist = CategoriesModel().obs;

  // Variables to store country and category data
  var countryList = [].obs;
  var categoryList = [].obs;

  // Variable to store combined data
  var combinedList = [].obs;

  // Sets to track unique IDs
  var countryIds = <int>{};
  var categoryIds = <int>{};

  void fetchcategories() async {
    try {
      isLoading(true);
      await CategoriesListApi().fetchcategoriesList().then((value) {
        allcategorieslist.value = value;

        // Clear previous data
        countryList.clear();
        categoryList.clear();
        countryIds.clear();
        categoryIds.clear();
        combinedList.clear();

        // Iterate through service categories
        for (var category in value.data!.servicecategories) {
          // Process for countries
          if (category.type == "nonsocial") {
            for (var service in category.services ?? []) {
              var company = service.company;
              if (company != null && company.country != null) {
                if (!countryIds.contains(company.country!.id)) {
                  countryList.add({
                    "id": company.country!.id,
                    "country_name": company.country!.countryName,
                    "country_flag_image_url":
                        company.country!.countryFlagImageUrl,
                    "phone_number_length": company.country!.phoneNumberLength,
                  });
                  countryIds.add(company.country!.id!); // Add unique country ID
                }
              }
            }

            // Process for categories
            if (category.services!.isNotEmpty &&
                category.id != null &&
                !categoryIds.contains(category.id!)) {
              categoryList.add({
                "id": category.id,
                "category_name": category.categoryName,
              });
              categoryIds.add(category.id!); // Add unique category ID
            }
          }
        }

        // Generate combinations
        for (var country in countryList) {
          for (var category in categoryList) {
            combinedList.add({
              "country_name": country["country_name"],
              "country_id": country["id"].toString(),
              "country_flag_image_url": country["country_flag_image_url"],
              "phone_number_length": country["phone_number_length"],
              "category_name": category["category_name"],
              "category_id": category["id"].toString(),
            });
          }
        }

        // Print results
        // print("Unique Country List: $countryList");
        // print("Unique Category List: $categoryList");
        print(combinedList.length);

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print("Error fetching categories: ${e.toString()}");
    }
  }
}

// import 'package:get/get.dart';
// import 'package:watandaronline/models/categories_service_model.dart';
// import 'package:watandaronline/services/categoris_service_list.dart';

// class CategorisListController extends GetxController {
//   @override
//   void onInit() {
//     fetchcategories();
//     super.onInit();
//   }

//   var isLoading = false.obs;

//   // Complete list of categories
//   var allcategorieslist = CategoriesModel().obs;

//   // Filtered list for "type": "nonsocial"
//   var nonsocialCategories = <Servicecategory>[].obs;

//   void fetchcategories() async {
//     try {
//       isLoading(true);
//       await CategoriesListApi().fetchcategoriesList().then((value) {
//         allcategorieslist.value = value;

//         // Filter "nonsocial" categories
//         nonsocialCategories.value = allcategorieslist
//             .value.data!.servicecategories
//             .where((category) => category.type == "nonsocial")
//             .toList();

//         print(
//             "Filtered Categories: ${nonsocialCategories.map((e) => e.toJson()).toList()}");

//         isLoading(false);
//       });
//     } catch (e) {
//       print("Error: ${e.toString()}");
//     } finally {
//       isLoading(false);
//     }
//   }
// }
