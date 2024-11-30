import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/controllers/bundles_controller.dart';
import 'package:watandaronline/controllers/categories_list_controller.dart';
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/controllers/custom_recharge_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/operator_controller.dart';
import 'package:watandaronline/controllers/reserve_digit_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';
import 'package:watandaronline/helpers/language_helper.dart';
import 'package:watandaronline/routes/routes.dart';

import 'package:watandaronline/screens/social_recharge.dart';
import 'package:watandaronline/utils/colors.dart';
import 'package:watandaronline/widgets/default_button.dart';

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
  final customrechargeController = Get.find<CustomRechargeController>();

  final box = GetStorage();

  String selected_country = "Select Country";

  String numberlength = '';
  bool isopen = false;
  @override
  void initState() {
    super.initState();
    // Check if countries list is not empty and set the first country's name
    final countries =
        countryListController.allcountryListData.value.data?.countries;
    if (countries != null && countries.isNotEmpty) {
      selected_country = countries.first.countryName.toString();
    }

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
              Get.back();
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
                                    print(box.read("country_id"));
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
                  height: 5,
                ),
                Obx(
                  () => categorisListController.isLoading.value == false
                      ? Expanded(
                          child: GridView.builder(
                            physics: BouncingScrollPhysics(),
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
                ),
                Visibility(
                  visible: isopen,
                  child: Container(
                    height: 220,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isopen = false;
                                });
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.close,
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 45,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xffECECEC),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/icons/phone.png",
                                            height: 25,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                            child: TextField(
                                              controller:
                                                  customrechargeController
                                                      .numberController,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Phone Number",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    height: 45,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xffECECEC),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/icons/money.png",
                                            height: 25,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                            child: TextField(
                                              controller:
                                                  customrechargeController
                                                      .amountController,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Amount",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // Container(
                                  //   height: 45,
                                  //   width: screenWidth,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     border: Border.all(
                                  //       width: 1,
                                  //       color: AppColors.borderColor,
                                  //     ),
                                  //   ),
                                  //   child: Padding(
                                  //     padding:
                                  //         EdgeInsets.only(left: 15, right: 10),
                                  //     child: Row(
                                  //       children: [
                                  //         Expanded(
                                  //           child: Text(
                                  //             selected_country,
                                  //             style: TextStyle(
                                  //               fontWeight: FontWeight.w300,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         GestureDetector(
                                  //           onTap: () {
                                  //             showDialog(
                                  //               context: context,
                                  //               builder: (context) {
                                  //                 return AlertDialog(
                                  //                   content: Container(
                                  //                     height: 150,
                                  //                     width: screenWidth,
                                  //                     color: Colors.white,
                                  //                     child: ListView.builder(
                                  //                       itemCount:
                                  //                           countryListController
                                  //                               .allcountryListData
                                  //                               .value
                                  //                               .data!
                                  //                               .countries
                                  //                               .length,
                                  //                       itemBuilder:
                                  //                           (context, index) {
                                  //                         final data =
                                  //                             countryListController
                                  //                                 .allcountryListData
                                  //                                 .value
                                  //                                 .data!
                                  //                                 .countries[index];
                                  //                         return GestureDetector(
                                  //                           onTap: () {
                                  //                             setState(() {
                                  //                               selected_country = data
                                  //                                   .countryName
                                  //                                   .toString();

                                  //                               box.write(
                                  //                                   "country_id",
                                  //                                   data.id
                                  //                                       .toString());
                                  //                               print(box.read(
                                  //                                   "country_id"));
                                  //                             });

                                  //                             Navigator.pop(
                                  //                                 context);
                                  //                           },
                                  //                           child: Container(
                                  //                             margin: EdgeInsets
                                  //                                 .only(
                                  //                                     bottom:
                                  //                                         8),
                                  //                             height: 40,
                                  //                             decoration:
                                  //                                 BoxDecoration(
                                  //                               border:
                                  //                                   Border.all(
                                  //                                 width: 1,
                                  //                                 color: Colors
                                  //                                     .grey,
                                  //                               ),
                                  //                             ),
                                  //                             child: Row(
                                  //                               children: [
                                  //                                 Image.network(
                                  //                                   data.countryFlagImageUrl
                                  //                                       .toString(),
                                  //                                   height: 40,
                                  //                                   width: 60,
                                  //                                   fit: BoxFit
                                  //                                       .cover,
                                  //                                 ),
                                  //                                 SizedBox(
                                  //                                   width: 10,
                                  //                                 ),
                                  //                                 Text(
                                  //                                   data.countryName
                                  //                                       .toString(),
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                           ),
                                  //                         );
                                  //                       },
                                  //                     ),
                                  //                   ),
                                  //                 );
                                  //               },
                                  //             );
                                  //           },
                                  //           child: Icon(
                                  //             FontAwesomeIcons.chevronDown,
                                  //             color: Colors.grey,
                                  //           ),
                                  //         ),
                                  //         SizedBox(
                                  //           width: 10,
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  // Container(
                                  //   height: 45,
                                  //   width: 100,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(5),
                                  //     border: Border.all(
                                  //       width: 1,
                                  //       color:
                                  //           Color.fromARGB(255, 209, 195, 195),
                                  //     ),
                                  //   ),
                                  //   child: Center(
                                  //     child: TextField(
                                  //       maxLength: 4,
                                  //       controller: customrechargeController
                                  //           .pinController,
                                  //       textAlign: TextAlign.center,
                                  //       keyboardType: TextInputType.phone,
                                  //       decoration: InputDecoration(
                                  //         counterText: "",
                                  //         border: InputBorder.none,
                                  //         hintText: "Pin",
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 4,
                                  // ),

                                  Obx(
                                    () => DefaultButton(
                                      buttonName: customrechargeController
                                                  .isLoading.value ==
                                              false
                                          ? "Recharge now"
                                          : "Please wait...",
                                      onPressed: () {
                                        if (customrechargeController
                                                .numberController
                                                .text
                                                .isNotEmpty &&
                                            customrechargeController
                                                .amountController
                                                .text
                                                .isNotEmpty) {
                                          customrechargeController.dorecharge();
                                        } else {
                                          Get.snackbar(
                                              "Error", "Fill box correctly");
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isopen = true;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "Direct Recharge",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
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
