import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/controllers/bundles_controller.dart';
import 'package:watandaronline/controllers/categories_list_controller.dart';
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';
import 'package:watandaronline/routes/routes.dart';
import 'package:watandaronline/screens/recharge_screen.dart';
import 'package:watandaronline/screens/social_recharge.dart';
import 'package:watandaronline/utils/colors.dart';

import '../controllers/language_controller.dart';
import '../global controller/languages_controller.dart';
import 'social_recharge_screen.dart';

class NewServiceScreen extends StatefulWidget {
  NewServiceScreen({super.key});

  @override
  State<NewServiceScreen> createState() => _NewServiceScreenState();
}

class _NewServiceScreenState extends State<NewServiceScreen> {
  final languagesController = Get.find<LanguagesController>();

  final categorisListController = Get.find<CategorisListController>();

  final box = GetStorage();

  // final countryListController = Get.find<CountryListController>();

  final bundleController = Get.find<BundleController>();

  final serviceController = Get.find<ServiceController>();

  final List<String> imageList = [
    "assets/icons/social-media1.png",
    "assets/icons/intcall.jpeg",
    "assets/icons/social-media3.png",
    "assets/icons/social-media4.png",
    "assets/icons/social-media5.png",
    "assets/icons/social-media6.png",
    "assets/icons/social-media7.png",
  ];

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
          languagesController.tr("SERVICES"),
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
            () => categorisListController.isLoading.value == false
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: categorisListController.finalArrayCatList.length,
                    itemBuilder: (context, index) {
                      final data =
                          categorisListController.finalArrayCatList[index];

                      return GestureDetector(
                        onTap: () {
                          serviceController.reserveDigit.clear();
                          bundleController.finalList.clear();

                          box.write("maxlength", data["phoneNumberLength"]);

                          box.write("validity_type", "");
                          box.write("company_id", "");
                          box.write("search_tag", "");
                          box.write("country_id", data["countryId"]);

                          box.write("service_category_id", data["categoryId"]);
                          box.write("catName", data["categoryName"]);
                          bundleController.initialpage = 1;
                          print(data["type"]);

                          if (data["type"] == "social") {
                            // Get.toNamed(socialrechargescreen);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SocialRechargeScreen(),
                              ),
                            );
                          } else {
                            box.write("catName", data["categoryName"]);
                            Get.toNamed(rechargescreen);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => RechargeScreen(),
                            //   ),
                            // );
                          }
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
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: data["type"] == "nonsocial"
                                      ? Container(
                                          child: Center(
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.white,
                                              backgroundImage: NetworkImage(
                                                  data["countryImage"]),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: Center(
                                            child: Image.asset(
                                              imageList[index],
                                              height: 55,
                                            ),
                                          ),
                                        ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    data["categoryName"],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
