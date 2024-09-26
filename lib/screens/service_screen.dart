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
import 'package:watandaronline/controllers/service_controller.dart';

import 'package:watandaronline/screens/social_recharge.dart';

import 'recharge_screen.dart';

class ServiceScreen extends StatefulWidget {
  ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List countryName = [
    "aAfganistan",
    "aBangladesh",
    "aTurkey",
  ];

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
  List<Map<String, dynamic>> buttonInfo = [
    {
      "name": "Internet",
      "icon": FontAwesomeIcons.wifi,
    },
    {
      "name": "Calls",
      "icon": FontAwesomeIcons.phoneVolume,
    },
    {
      "name": "Social Apps",
      "icon": FontAwesomeIcons.database,
    },
    {
      "name": "Mobile Charge",
      "icon": FontAwesomeIcons.globe,
    },
  ];

  final OperatorController operatorController = Get.put(OperatorController());
  final CountryListController countryListController =
      Get.put(CountryListController());

  final BundleController bundleController = Get.put(BundleController());

  final CategorisListController categorisListController =
      Get.put(CategorisListController());

  final box = GetStorage();
  final LanguageController languageController = Get.put(LanguageController());

  String numberlength = '';

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
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
          backgroundColor: Colors.white,
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
        body: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
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
                                    numberlength =
                                        data.phoneNumberLength.toString();
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
                                mycolor: mycolorlist[index],
                                onPressed: () {
                                  bundleController.finalList.clear();
                                  box.write("service_category_id", data.id);
                                  // box.write("service_id", "");
                                  box.write("validity_type", "");
                                  box.write("company_id", "");
                                  box.write("search_tag", "");

                                  bundleController.initialpage = 1;

                                  if (data.type == "social") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SocialRechargeScreen(),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RechargeScreen(
                                          numberlength: numberlength,
                                        ),
                                      ),
                                    );
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
  ServiceBox({
    super.key,
    this.boxName,
    this.onPressed,
    this.myicon,
    this.mycolor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: mycolor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Text(
              boxName.toString(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
