import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/controllers/bundles_controller.dart';
import 'package:watandaronline/controllers/categories_list_controller.dart';
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/operator_controller.dart';
import 'package:watandaronline/controllers/reserve_digit_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';
import 'package:watandaronline/routes/routes.dart';

import 'package:watandaronline/screens/social_recharge.dart';

import 'recharge_screen.dart';

class ServiceScreen extends StatefulWidget {
  ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  int selectedIndex = 0;
  List mycolorlist = [
    Color(0xff74b9ff),
    Color(0xff2bcbba),
    Color(0xff009432),
    Color(0xff2d98da),
    Color(0xff2c3e50),
    Color(0xff16a085),
    Color(0xff3498db),
    Color(0xfff39c12),
    Color(0xff74b9ff),
    Color(0xff2bcbba),
    Color(0xff009432),
    Color(0xff2d98da),
    Color(0xff2c3e50),
    Color(0xff16a085),
    Color(0xff3498db),
    Color(0xfff39c12),
    Color(0xff74b9ff),
    Color(0xff2bcbba),
    Color(0xff009432),
    Color(0xff2d98da),
    Color(0xff2c3e50),
    Color(0xff16a085),
    Color(0xff3498db),
    Color(0xfff39c12),
    Color(0xff74b9ff),
    Color(0xff2bcbba),
    Color(0xff009432),
    Color(0xff2d98da),
    Color(0xff2c3e50),
    Color(0xff16a085),
    Color(0xff3498db),
    Color(0xfff39c12),
    Color(0xff74b9ff),
    Color(0xff2bcbba),
    Color(0xff009432),
    Color(0xff2d98da),
    Color(0xff2c3e50),
    Color(0xff16a085),
    Color(0xff3498db),
    Color(0xfff39c12),
    Color(0xff74b9ff),
    Color(0xff2bcbba),
    Color(0xff009432),
    Color(0xff2d98da),
    Color(0xff2c3e50),
    Color(0xff16a085),
    Color(0xff3498db),
    Color(0xfff39c12),
  ];

  final OperatorController operatorController = Get.put(OperatorController());

  final categorisListController = Get.find<CategorisListController>();
  final languageController = Get.find<LanguageController>();
  final countryListController = Get.find<CountryListController>();
  final serviceController = Get.find<ServiceController>();

  final box = GetStorage();

  String numberlength = '';
  @override
  void initState() {
    super.initState();

    // Check if country data is available and print the first country name
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (countryListController.allcountryListData.value.data != null &&
          countryListController
              .allcountryListData.value.data!.countries.isNotEmpty) {
        box.write(
            "maxlength",
            countryListController
                .allcountryListData.value.data!.countries[0].phoneNumberLength);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xff2980b9),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white.withOpacity(0.8),
          elevation: 0.0,
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              // print(box.read("country_id"));
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
          color: Colors.white.withOpacity(0.8),
          height: screenHeight,
          width: screenWidth,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () => countryListController.isLoading.value == false
                      ? Container(
                          height: 40,
                          width: screenWidth,
                          // color: Colors.grey,
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 20,
                              );
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: countryListController.allcountryListData
                                .value.data!.countries.length,
                            itemBuilder: (context, index) {
                              final data = countryListController
                                  .allcountryListData
                                  .value
                                  .data!
                                  .countries[index];
                              bool isSelected = index == selectedIndex;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;

                                    box.write("country_id", data.id);
                                    box.write("maxlength",
                                        data.phoneNumberLength.toString());
                                    // numberlength =
                                    //     data.phoneNumberLength.toString();
                                    print(numberlength.toString());

                                    if (index == 0) {
                                      operatorController.currentOperators =
                                          operatorController.afganoperator;
                                    } else if (index == 1) {
                                      operatorController.currentOperators =
                                          operatorController.banglaoperator;
                                    } else {
                                      operatorController.currentOperators =
                                          operatorController.turkeyoperator;
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Color(0xff34495e)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                data.countryFlagImageUrl
                                                    .toString(),
                                              ),
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          data.countryName.toString(),
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14,
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
                        )
                      : SizedBox(),
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () => categorisListController.isLoading.value == false
                      ? Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  2, // Number of columns in the grid
                              crossAxisSpacing: 5.0, // Spacing between columns
                              mainAxisSpacing: 5.0, // Spacing between rows
                              childAspectRatio: 2.0,
                            ),
                            itemCount: categorisListController.allcategorieslist
                                .value.data!.servicecategories.length,
                            itemBuilder: (context, index) {
                              final data = categorisListController
                                  .allcategorieslist
                                  .value
                                  .data!
                                  .servicecategories[index];
                              return ServiceBox(
                                boxName: data.categoryName,
                                serviceType: data.type,
                                onPressed: () {
                                  // reserveDigitController.companyName =
                                  //     data.categoryName.toString();

                                  serviceController.reserveDigit.clear();

                                  box.write("service_category_id", data.id);
                                  // box.write("service_id", "");
                                  box.write("validity_type", "");
                                  box.write("company_id", "");
                                  box.write("search_tag", "");

                                  if (data.type == "social") {
                                    Get.toNamed(socialrechargescreen);
                                  } else {
                                    Get.toNamed(rechargescreen);
                                  }
                                },
                              );
                            },
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        ),
                )
              ],
            ),
          ),
        ));
  }
}

class ServiceBox extends StatelessWidget {
  String? boxName;
  final VoidCallback? onPressed;
  final IconData? myicon;
  final Color? mycolor;
  final String? serviceType;
  ServiceBox({
    super.key,
    this.boxName,
    this.onPressed,
    this.myicon,
    this.mycolor,
    this.serviceType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                serviceType.toString() == "social"
                    ? "assets/icons/social-media.png"
                    : "assets/icons/recharge.png",
                height: 25,
              ),
              Text(
                boxName.toString(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
