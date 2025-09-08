import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watandaronline/models/categories_service_model.dart';
import 'package:watandaronline/services/categoris_service_list.dart';

class CategorisListController extends GetxController {
  var isLoading = false.obs;
  var allcategorieslist = CategoriesModel().obs;

  var countryList = [].obs;
  var categoryList = [].obs;

  final List<Map<String, dynamic>> nonsocialArray = [];
  final List<Map<String, dynamic>> socialArray = [];
  final List<Map<String, dynamic>> finalArrayCatList = [];

  void fetchcategories() async {
    try {
      isLoading(true);
      await CategoriesListApi().fetchcategoriesList().then((value) {
        // Clear old data
        nonsocialArray.clear();
        socialArray.clear();
        finalArrayCatList.clear();

        final Map<String, dynamic> nonsocial = {};
        final Map<String, dynamic> social = {};

        // Build social array directly
        List<Map<String, dynamic>> socialCategoriesWithServices = value
            .data!.servicecategories
            .where((category) =>
                category.type == 'social' &&
                (category.services as List).isNotEmpty)
            .map((category) {
          final firstService = (category.services as List).isNotEmpty
              ? category.services!.first
              : null;
          final country = firstService?.company?.country;

          return {
            'countryName': country?.countryName ?? "",
            'countryId': country?.id ?? null,
            'countryImage': country?.countryFlagImageUrl ?? "",
            'phoneNumberLength': country?.phoneNumberLength ?? "",
            'categoryId': category.id?.toString(),
            'categoryName': category.categoryName.toString(),
            "type": "social",
          };
        }).toList();

        socialArray.addAll(socialCategoriesWithServices);

        // Process nonsocial categories
        for (var category in value.data!.servicecategories ?? []) {
          final String? type = category.type;
          final String? categoryId = category.id?.toString();
          final String? categoryName = category.categoryName;

          if (type != null && categoryId != null && categoryName != null) {
            for (var service in category.services ?? []) {
              final String? country = service.company?.country?.countryName;

              final int? countryId = service.company?.countryId != null
                  ? int.tryParse(service.company!.countryId!)
                  : null;

              final String? countryImage =
                  service.company?.country?.countryFlagImageUrl;
              final String? phoneNumberLength =
                  service.company?.country?.phoneNumberLength;

              if (country != null && countryId != null) {
                if (type == "nonsocial") {
                  nonsocial.putIfAbsent(country, () {
                    return {
                      'country_id': countryId,
                      'countryImage': countryImage,
                      'phone_number_length': phoneNumberLength,
                      'categories': <String, dynamic>{},
                    };
                  });

                  // Safe cast using Map<String, dynamic>.from
                  final Map<String, dynamic> categories =
                      Map<String, dynamic>.from(
                          nonsocial[country]['categories']);

                  categories.putIfAbsent(categoryId, () {
                    return {
                      'categoryName': categoryName,
                      'country_id': countryId,
                      'countryImage': countryImage,
                      'phone_number_length': phoneNumberLength,
                    };
                  });

                  // Update the categories map back
                  nonsocial[country]['categories'] = categories;
                }
              }
            }
          }
        }

        // Convert nonsocial map to array
        nonsocial.forEach((countryName, countryValue) {
          final Map<String, dynamic> valueMap =
              Map<String, dynamic>.from(countryValue);

          final int? countryId = valueMap['country_id'];
          final String? countryImage = valueMap['countryImage'];
          final String? phoneNumberLength = valueMap['phone_number_length'];

          final Map<String, dynamic> categories =
              Map<String, dynamic>.from(valueMap['categories']);

          categories.forEach((categoryId, categoryValue) {
            nonsocialArray.add({
              'countryName': countryName,
              'countryId': countryId,
              'countryImage': countryImage,
              'phoneNumberLength': phoneNumberLength,
              'categoryId': categoryId,
              'categoryName': categoryValue['categoryName'],
              'type': 'nonsocial',
            });
          });
        });

        // If you ever build social from `Map` (not needed here), fix casting too

        // Combine both
        finalArrayCatList.addAll(socialArray);
        finalArrayCatList.addAll(nonsocialArray);

        // print("Nonsocial Categories: $nonsocialArray");
        isLoading(false);
      });
    } catch (e) {
      print("Error fetching categories: ${e.toString()}");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading(false); // ✅ এটি এখন নিরাপদ
      });
    }
  }
}
