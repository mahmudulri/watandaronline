import 'package:get/get.dart';
import 'package:watandaronline/models/categories_service_model.dart';
import 'package:watandaronline/services/categoris_service_list.dart';

class CategorisListController extends GetxController {
  var isLoading = false.obs;
  var allcategorieslist = CategoriesModel().obs;

  // Variables to store country and category data
  var countryList = [].obs;
  var categoryList = [].obs;

  // Variables to store nonsocial and social arrays
  final List<Map<String, dynamic>> nonsocialArray = [];
  final List<Map<String, dynamic>> socialArray = [];

  // Variable to store final combined data
  final List<Map<String, dynamic>> finalArrayCatList = [];

  // final List<String> imageList = [
  //   "assets/icons/social-media2.png",
  //   "assets/icons/social-media2.png",
  //   "assets/icons/social-media2.png",
  //   "assets/icons/social-media2.png",
  //   "assets/icons/social-media2.png",
  // ];

  void fetchcategories() async {
    try {
      isLoading(true);
      await CategoriesListApi().fetchcategoriesList().then((value) {
        // Clear previous data
        nonsocialArray.clear();
        socialArray.clear();
        finalArrayCatList.clear();

        final Map<String, dynamic> nonsocial = {};
        final Map<String, dynamic> social = {};

        List<Map<String, dynamic>> socialCategoriesWithServices = value
            .data!.servicecategories
            .where((category) =>
                category.type == 'social' &&
                (category.services as List).isNotEmpty)
            .map((category) {
          // Get the first service or handle null explicitly
          final firstService = (category.services as List).isNotEmpty
              ? category.services!.first
              : null;

          // Extract country details if the service and company exist
          final country = firstService?.company?.country;

          return {
            'countryName': country?.countryName ?? "",
            'countryId': country?.id ?? null,
            'countryImage': country?.countryFlagImageUrl ?? "",
            'phoneNumberLength': country?.phoneNumberLength ?? "",
            'categoryId': category.id,
            'categoryName': category.categoryName.toString(),
            "type": "social",
          };
        }).toList();

        socialArray.addAll(socialCategoriesWithServices);

        // print("result" + socialArray.toList().toString());

        for (var category in value.data!.servicecategories ?? []) {
          final String? type = category.type;
          final int? categoryId = category.id;
          final String? categoryName = category.categoryName;

          // Ensure necessary values are not null
          if (type != null && categoryId != null && categoryName != null) {
            for (var service in category.services ?? []) {
              final String? country = service.company?.country?.countryName;
              final int? countryId = service.company?.countryId;
              final String? countryImage =
                  service.company?.country?.countryFlagImageUrl;
              final String? phoneNumberLength =
                  service.company?.country?.phoneNumberLength;

              if (country != null && countryId != null) {
                // Handle nonsocial categories
                if (type == "nonsocial") {
                  nonsocial.putIfAbsent(country, () {
                    return {
                      'country_id': countryId,
                      'countryImage': countryImage,
                      'phone_number_length': phoneNumberLength,
                      'categories': <int, dynamic>{},
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
              "type": "nonsocial",
            });
          });
        });

        // Convert the social map to the desired array format
        social.entries.forEach((entry) {
          final String countryName = entry.key;
          final Map<String, dynamic> countryValue = entry.value;

          final int? countryId = countryValue['country_id'];
          final String? countryImage = countryValue['countryImage'];
          final String? phoneNumberLength = countryValue['phone_number_length'];
          final Map<int, dynamic> categories =
              countryValue['categories'] as Map<int, dynamic>;

          categories.forEach((categoryId, categoryValue) {
            socialArray.add({
              'countryName': countryName,
              'countryId': countryId,
              'countryImage': countryImage,
              'phoneNumberLength': phoneNumberLength,
              'categoryId': categoryId,
              'categoryName': categoryValue['categoryName'],
            });
          });
        });

        // Combine nonsocialArray and socialArray into finalArrayCatList

        finalArrayCatList.addAll(socialArray);
        finalArrayCatList.addAll(nonsocialArray);

        // Print finalArrayCatList length for verification

        print("Nonsocial Categories: ${nonsocialArray}");

        isLoading(false);
      });
    } catch (e) {
      print("Error fetching categories: ${e.toString()}");
      isLoading(false);
    }
  }
}
