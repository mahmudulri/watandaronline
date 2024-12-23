import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/controllers/bundles_controller.dart';
import 'package:watandaronline/controllers/categories_list_controller.dart';
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';
import 'package:watandaronline/mygridview.dart';
import 'package:watandaronline/screens/social_recharge.dart';
import 'package:watandaronline/utils/colors.dart';
import '../controllers/language_controller.dart';

class ANewServiceScreen extends StatelessWidget {
  ANewServiceScreen({super.key});

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
      // backgroundColor: Color(0xffEFF3F4),
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
        backgroundColor: Color(0xffEFF3F4),
        elevation: 0.0,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            // categorisListController.fetchcategories();
            Get.to(() => GridViewExample());
          },
          child: Text(
            languageController.alllanguageData.value.languageData!["SERVICES"]
                .toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Container(
        color: Color(0xffEFF3F4),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Obx(
            () => categorisListController.isLoading.value == false &&
                    countryListController.isLoading.value == false
                ? ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 3.0,
                          mainAxisSpacing: 3.0,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return GestureDetector(
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
                            child: Card(
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
                        },
                      ),

                      // Display Nonsocial Service Categories by Country
                      ...countryListController
                          .allcountryListData.value.data!.countries
                          .map((country) {
                        final nonsocialCategories = categorisListController
                            .allcategorieslist.value!.data!.servicecategories!
                            .where((category) => category.type == "nonsocial")
                            .toList();

                        final countries = countryListController
                            .allcountryListData.value.data?.countries;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 3.0,
                                mainAxisSpacing: 3.0,
                                childAspectRatio: 0.9,
                              ),
                              itemCount: nonsocialCategories.length,
                              itemBuilder: (context, catIndex) {
                                final category = nonsocialCategories[catIndex];

                                return GestureDetector(
                                  onTap: () {
                                    serviceController.reserveDigit.clear();

                                    box.write("maxlength",
                                        country.phoneNumberLength.toString());

                                    bundleController.finalList.clear();
                                    box.write("validity_type", "");
                                    box.write("company_id", "");
                                    box.write("search_tag", "");
                                    box.write(
                                        "country_id", country.id.toString());

                                    box.write("service_category_id",
                                        category.id.toString());
                                    bundleController.initialpage = 1;

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => RechargeScreen(),
                                    //   ),
                                    // );
                                  },
                                  child: Card(
                                    child: Container(
                                      // width: 140,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Text(
                                          //   "${country.id}",
                                          //   style: TextStyle(
                                          //     fontSize: 8,
                                          //     fontWeight: FontWeight.bold,
                                          //     color: Colors.black,
                                          //   ),
                                          // ),
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                              country.countryFlagImageUrl
                                                  .toString(),
                                            ),
                                          ),
                                          SizedBox(height: 5),

                                          Text(
                                            category.categoryName.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
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
                            ),
                          ],
                        );
                      }).toList(),

                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }
}
