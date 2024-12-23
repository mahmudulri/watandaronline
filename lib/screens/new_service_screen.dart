import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/controllers/bundles_controller.dart';
import 'package:watandaronline/controllers/categories_list_controller.dart';
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';
import 'package:watandaronline/screens/recharge_screen.dart';
import 'package:watandaronline/screens/social_recharge.dart';
import 'package:watandaronline/utils/colors.dart';

import '../controllers/language_controller.dart';

class NewServiceScreen extends StatelessWidget {
  NewServiceScreen({super.key});

  final languageController = Get.find<LanguageController>();
  final categorisListController = Get.find<CategorisListController>();

  final box = GetStorage();

  final countryListController = Get.find<CountryListController>();
  final bundleController = Get.find<BundleController>();

  final serviceController = Get.find<ServiceController>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.defaultColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xffEFF3F4),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          languageController.alllanguageData.value.languageData!["SERVICES"]
              .toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xffEFF3F4),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Obx(
            () => categorisListController.isLoading.value == false &&
                    countryListController.isLoading.value == false
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 0.9,
                    ),
                    itemCount:
                        categorisListController.nonsocialCategories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // The extra fixed item at the beginning
                        return Card(
                          child: GestureDetector(
                            onTap: () {
                              bundleController.finalList.clear();
                              // print(service.companyId.toString());
                              box.write("validity_type", "");
                              box.write("company_id", "");
                              box.write("search_tag", "");
                              box.write("country_id", "");

                              box.write("service_category_id", "3");
                              bundleController.initialpage = 1;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SocialRechargeScreen(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/social-media2.png",
                                    height: 60,
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    "Social Bundles",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      // Adjust the index for the remaining items
                      final category = categorisListController
                          .nonsocialCategories[index - 1];

                      // Get the first available country flag URL
                      String? countryLogo = category.services != null &&
                              category.services!.isNotEmpty &&
                              category.services!.first.company != null &&
                              category.services!.first.company!.country != null
                          ? category.services!.first.company!.country!
                              .countryFlagImageUrl
                          : null;

                      return GestureDetector(
                        onTap: () {
                          bundleController.finalList.clear();

                          // Get the country ID and service category ID
                          String? countryId = category.services != null &&
                                  category.services!.isNotEmpty &&
                                  category.services!.first.company != null &&
                                  category.services!.first.company!.country !=
                                      null
                              ? category.services!.first.company!.country!.id
                                  .toString()
                              : "";

                          String serviceCategoryId =
                              category.id != null ? category.id.toString() : "";

                          // Write the values to the box
                          box.write("country_id", countryId);
                          box.write("service_category_id", serviceCategoryId);

                          // Navigate to the RechargeScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RechargeScreen(),
                            ),
                          );
                        },
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  backgroundImage: countryLogo != null
                                      ? NetworkImage(countryLogo)
                                      : const AssetImage(
                                              "assets/images/placeholder.png")
                                          as ImageProvider,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  category.categoryName ?? "Unknown",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }
}
