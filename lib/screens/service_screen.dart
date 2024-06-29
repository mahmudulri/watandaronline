import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watantelecom/controllers/categories_list_controller.dart';
import 'package:watantelecom/controllers/country_list_controller.dart';
import 'package:watantelecom/controllers/operator_controller.dart';
import 'package:watantelecom/controllers/service_controller.dart';

import 'package:watantelecom/screens/social_recharge.dart';

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

  final CategorisListController categorisListController =
      Get.put(CategorisListController());

  final box = GetStorage();

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
              // categorisListController.fetchcategories();
              print(box.read("country_id"));
            },
            child: Text(
              "Service",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: Obx(
          () => countryListController.isLoading.value ||
                  categorisListController.isLoading.value == false
              ? SizedBox(
                  height: screenHeight,
                  width: screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
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

                                    print(data.id);

                                    box.write("country_id", data.id);

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
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  2, // Number of columns in the grid
                              crossAxisSpacing: 5.0, // Spacing between columns
                              mainAxisSpacing: 5.0, // Spacing between rows
                              childAspectRatio: 3.0,
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
                                  box.write("service_category_id", data.id);
                                  // box.write("service_id", "");
                                  box.write("validity_type", "");
                                  box.write("company_id", "");
                                  print(data.id);
                                  print(data.type);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => RechargeScreen(),
                                  //   ),
                                  // );

                                  if (data.type == "social") {
                                    Get.to(() => SocialRechargeScreen());
                                    // MaterialPageRoute(
                                    //   builder: (context) =>
                                    //       SocialRechargeScreen(),
                                    // );
                                  } else {
                                    Get.to(() => RechargeScreen());
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
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
          child: Row(
            children: [
              FaIcon(
                myicon,
                color: Colors.white,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                boxName.toString(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}