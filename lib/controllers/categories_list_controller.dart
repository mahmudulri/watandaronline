import 'package:get/get.dart';
import 'package:watandaronline/models/categories_service_model.dart';
import 'package:watandaronline/services/categoris_service_list.dart';

class CategorisListController extends GetxController {
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
  final List<Map<String, dynamic>> nonsocialArray = [];

  void fetchcategories() async {
    try {
      isLoading(true);
      await CategoriesListApi().fetchcategoriesList().then((value) {
        // allcategorieslist.value = value;

        final Map<String, dynamic> nonsocial = {};

        for (var category in value.data!.servicecategories ?? []) {
          final String? type = category.type;
          final int? categoryId = category.id;
          final String? categoryName = category.categoryName;

          // Ensure necessary values are not null
          if (type != null &&
              type != "social" &&
              categoryId != null &&
              categoryName != null) {
            for (var service in category.services ?? []) {
              final String? country = service.company?.country?.countryName;
              final int? countryId = service.company?.countryId;
              final String? countryImage =
                  service.company?.country?.countryFlagImageUrl;
              final String? phoneNumberLength =
                  service.company?.country?.phoneNumberLength;

              if (country != null && countryId != null) {
                nonsocial.putIfAbsent(country, () {
                  return {
                    'country_id': countryId,
                    'countryImage': countryImage,
                    'phone_number_length': phoneNumberLength,
                    'categories': <int,
                        dynamic>{}, // Ensure categories is Map<int, dynamic>
                  };
                });

                // Access and update categories map
                final categories =
                    nonsocial[country]['categories'] as Map<int, dynamic>;
                categories.putIfAbsent(categoryId, () {
                  return {
                    'categoryName': categoryName,
                    'country_id': countryId,
                    'countryImage': countryImage,
                    'phone_number_length': phoneNumberLength,
                  };
                });
              }
            }
          }
        }

        // Convert the nonsocial map to the desired array format
        nonsocial.entries.forEach((entry) {
          final String countryName = entry.key;
          final Map<String, dynamic> countryValue = entry.value;

          final int? countryId = countryValue['country_id'];
          final String? countryImage = countryValue['countryImage'];
          final String? phoneNumberLength = countryValue['phone_number_length'];
          final Map<int, dynamic> categories =
              countryValue['categories'] as Map<int, dynamic>;

          categories.forEach((categoryId, categoryValue) {
            nonsocialArray.add({
              'countryName': countryName,
              'countryId': countryId,
              'countryImage': countryImage,
              'phoneNumberLength': phoneNumberLength,
              'categoryId': categoryId,
              'categoryName': categoryValue['categoryName'],
            });
          });
        });

        // Print the result
        // print(nonsocialArray.length.toString());

        isLoading(false);
      });

      // isLoading(false);
    } catch (e) {
      print("Error fetching categories: \${e.toString()}");
    }
  }
}
