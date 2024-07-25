import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:watandaronline/controllers/bundles_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/place_order_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';
import 'package:watandaronline/helpers/price.dart';
import 'package:watandaronline/screens/confirm_pin.dart';
import 'package:watandaronline/widgets/auth_textfield.dart';
import 'package:watandaronline/widgets/default_button.dart';
import 'package:watandaronline/widgets/rechange_number_box.dart';

import '../controllers/confirm_pin_controller.dart';
import '../controllers/operator_controller.dart';
import '../utils/colors.dart';

class RechargeScreen extends StatefulWidget {
  RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  int selectedIndex = -1;
  int duration_selectedIndex = -1;

  List mycolor = [
    Color(0xff74b9ff),
    Color(0xff2bcbba),
    Color(0xff009432),
    Color(0xff2d98da),
  ];

  List<Map<String, String>> duration = [
    {
      "Name": "All",
      "Value": "",
    },
    {
      "Name": "Monthly",
      "Value": "monthly",
    },
    {
      "Name": "Weekly",
      "Value": "weekly",
    },
    {
      "Name": "Daily",
      "Value": "daily",
    },
    {
      "Name": "Hourly",
      "Value": "hourly",
    },
    {
      "Name": "Nightly",
      "Value": "nightly",
    },
  ];

  final ServiceController serviceController = Get.put(ServiceController());

  final BundleController bundleController = Get.put(BundleController());
  final box = GetStorage();
  final ConfirmPinController confirmPinController =
      Get.put(ConfirmPinController());

  TextEditingController searchController = TextEditingController();
  final LanguageController languageController = Get.put(LanguageController());

  final ScrollController scrollController = ScrollController();

  String search = "";

  // @override
  // void initState() {
  //   serviceController.fetchservices();
  //   bundleController.fetchbundles();
  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();
    scrollController.addListener(refresh);
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fetchservices();
      bundleController.fetchallbundles();
    });
  }

  Future<void> refresh() async {
    if (bundleController.finalList.length >=
        (bundleController.allbundleslist.value.payload?.pagination.totalItems ??
            0)) {
      print(
          "End..........................................End.....................");
    } else {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        bundleController.initialpage++;
        print(bundleController.initialpage);
        print("Load More...................");
        bundleController.fetchallbundles();
        print(bundleController.initialpage);
      } else {
        // print("nothing");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.defaultColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            confirmPinController.numberController.clear();
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.defaultColor,
        elevation: 0.0,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            // print(bundleController.initialpage);
          },
          child: Text(
            languageController.alllanguageData.value.languageData!["RECHARGE"]
                .toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: ListView(
                    children: [
                      Container(
                        height: 45,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Colors.white,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: confirmPinController.numberController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: languageController.alllanguageData
                                      .value.languageData!["ENTER_YOUR_NUMBER"]
                                      .toString(),
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          height: 50,
                          width: screenWidth,
                          child: Obx(
                            () => serviceController.isLoading.value == false
                                ? Center(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          width: 5,
                                        );
                                      },
                                      scrollDirection: Axis.horizontal,
                                      itemCount: serviceController
                                          .allserviceslist
                                          .value
                                          .data!
                                          .services
                                          .length,
                                      itemBuilder: (context, index) {
                                        final data = serviceController
                                            .allserviceslist
                                            .value
                                            .data!
                                            .services[index];

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              bundleController.initialpage = 1;
                                              bundleController.finalList
                                                  .clear();
                                              selectedIndex = index;
                                              box.write(
                                                  "company_id", data.companyId);
                                              bundleController
                                                  .fetchallbundles();
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 65,
                                            decoration: BoxDecoration(
                                              color: selectedIndex == index
                                                  ? Color(0xff34495e)
                                                  : Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 5,
                                              ),
                                              child: Image.network(
                                                data.company!.companyLogo
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                      strokeWidth: 1.0,
                                    ),
                                  ),
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: duration.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  duration_selectedIndex = index;
                                  box.write("validity_type",
                                      duration[index]["Value"]);
                                  bundleController.initialpage = 1;
                                  bundleController.finalList.clear();
                                  bundleController.fetchallbundles();
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(),
                                height: 30,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    child: Text(
                                      duration[index]["Name"]!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: duration_selectedIndex == index
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(13.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          height: 45,
                          width: screenWidth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: TextField(
                              onChanged: (String? value) {
                                setState(() {
                                  search = value.toString();
                                });
                              },
                              controller: searchController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                                border: InputBorder.none,
                                hintText: languageController.alllanguageData
                                    .value.languageData!["SEARCH"]
                                    .toString(),
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: Obx(
                          () => bundleController.isLoading.value == false
                              ? RefreshIndicator(
                                  onRefresh: refresh,
                                  child: ListView.separated(
                                    shrinkWrap: false,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    controller: scrollController,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 5,
                                      );
                                    },
                                    itemCount:
                                        bundleController.finalList.length,
                                    itemBuilder: (context, index) {
                                      final data =
                                          bundleController.finalList[index];
                                      if (searchController.text.isEmpty) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (confirmPinController
                                                .numberController
                                                .text
                                                .isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg: "Enter Number ",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else {
                                              box.write("bundleID",
                                                  data.id.toString());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConfirmPinScreen(),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: 60,
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  AppColors.listbuilderboxColor,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                          (data
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString()),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data.bundleTitle
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          Text(
                                                            data.validityType
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      children: [
                                                        PriceTextView(
                                                          price: data
                                                              .sellingPrice
                                                              .toString(),
                                                        ),
                                                        // Text(
                                                        //   data.sellingPrice.toString(),
                                                        //   style: TextStyle(
                                                        //     fontWeight: FontWeight.w600,
                                                        //     fontSize: 12,
                                                        //   ),
                                                        // ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Text(
                                                          " ${box.read("currency_code")}",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content:
                                                                    Container(
                                                                  height: 160,
                                                                  width:
                                                                      screenWidth,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        languageController
                                                                            .alllanguageData
                                                                            .value
                                                                            .languageData!["BUNDLE_DETAILS"]
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            languageController.alllanguageData.value.languageData!["BUNDLE_TITLE"].toString(),
                                                                          ),
                                                                          Text(
                                                                              "${data.bundleTitle}"),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            languageController.alllanguageData.value.languageData!["VALIDITY"].toString(),
                                                                          ),
                                                                          Text(
                                                                              "${data.validityType}"),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            languageController.alllanguageData.value.languageData!["BUYING_PRICE"].toString(),
                                                                          ),
                                                                          Spacer(),
                                                                          Text(
                                                                            NumberFormat.currency(
                                                                              locale: 'en_US',
                                                                              symbol: '',
                                                                              decimalDigits: 2,
                                                                            ).format(
                                                                              double.parse(
                                                                                data.buyingPrice.toString(),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            " ${box.read("currency_code")}",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Text(
                                                          languageController
                                                              .alllanguageData
                                                              .value
                                                              .languageData![
                                                                  "VIEW_DETAILS"]
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (bundleController
                                          .allbundleslist
                                          .value
                                          .data!
                                          .bundles![index]
                                          .bundleTitle
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchController.text
                                              .toString()
                                              .toLowerCase())) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (confirmPinController
                                                .numberController
                                                .text
                                                .isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg: "Enter Number ",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else {
                                              box.write("bundleID",
                                                  data.id.toString());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConfirmPinScreen(),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: 60,
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  AppColors.listbuilderboxColor,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                          (data
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString()),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data.bundleTitle
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          Text(
                                                            data.validityType
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      children: [
                                                        PriceTextView(
                                                          price: data
                                                              .sellingPrice
                                                              .toString(),
                                                        ),
                                                        // Text(
                                                        //   data.sellingPrice.toString(),
                                                        //   style: TextStyle(
                                                        //     fontWeight: FontWeight.w600,
                                                        //     fontSize: 12,
                                                        //   ),
                                                        // ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Text(
                                                          " ${box.read("currency_code")}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content:
                                                                    Container(
                                                                  height: 160,
                                                                  width:
                                                                      screenWidth,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        languageController
                                                                            .alllanguageData
                                                                            .value
                                                                            .languageData!["BUNDLE_DETAILS"]
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            languageController.alllanguageData.value.languageData!["BUNDLE_TITLE"].toString(),
                                                                          ),
                                                                          Text(
                                                                              "${data.bundleTitle}"),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            languageController.alllanguageData.value.languageData!["VALIDITY"].toString(),
                                                                          ),
                                                                          Text(
                                                                              "${data.validityType}"),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            languageController.alllanguageData.value.languageData!["BUYING_PRICE"].toString(),
                                                                          ),
                                                                          Spacer(),
                                                                          Text(
                                                                            NumberFormat.currency(
                                                                              locale: 'en_US',
                                                                              symbol: '',
                                                                              decimalDigits: 2,
                                                                            ).format(
                                                                              double.parse(
                                                                                data.buyingPrice.toString(),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            " ${box.read("currency_code")}",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Text(
                                                          "Details",
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        print("object");
                                      }
                                    },
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: refresh,
                                  child: ListView.separated(
                                    shrinkWrap: false,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    controller: scrollController,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 5,
                                      );
                                    },
                                    itemCount:
                                        bundleController.finalList.length,
                                    itemBuilder: (context, index) {
                                      final data =
                                          bundleController.finalList[index];
                                      if (searchController.text.isEmpty) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (confirmPinController
                                                .numberController
                                                .text
                                                .isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg: "Enter Number ",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else {
                                              box.write("bundleID",
                                                  data.id.toString());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConfirmPinScreen(),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: 60,
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  AppColors.listbuilderboxColor,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                          (data
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString()),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data.bundleTitle
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          Text(
                                                            data.validityType
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      children: [
                                                        PriceTextView(
                                                          price: data
                                                              .sellingPrice
                                                              .toString(),
                                                        ),
                                                        // Text(
                                                        //   data.sellingPrice.toString(),
                                                        //   style: TextStyle(
                                                        //     fontWeight: FontWeight.w600,
                                                        //     fontSize: 12,
                                                        //   ),
                                                        // ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Text(
                                                          data.currency!.code
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content:
                                                                    Container(
                                                                  height: 160,
                                                                  width:
                                                                      screenWidth,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        languageController
                                                                            .alllanguageData
                                                                            .value
                                                                            .languageData!["BUNDLE_DETAILS"]
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            languageController.alllanguageData.value.languageData!["BUNDLE_TITLE"].toString(),
                                                                          ),
                                                                          Text(
                                                                              "${data.bundleTitle}"),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            languageController.alllanguageData.value.languageData!["VALIDITY"].toString(),
                                                                          ),
                                                                          Text(
                                                                              "${data.validityType}"),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            languageController.alllanguageData.value.languageData!["BUYING_PRICE"].toString(),
                                                                          ),
                                                                          Text(
                                                                              "${data.buyingPrice}   ${data.currency!.code.toString()}"),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Text(
                                                          languageController
                                                              .alllanguageData
                                                              .value
                                                              .languageData![
                                                                  "VIEW_DETAILS"]
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (bundleController
                                          .allbundleslist
                                          .value
                                          .data!
                                          .bundles![index]
                                          .bundleTitle
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchController.text
                                              .toString()
                                              .toLowerCase())) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (confirmPinController
                                                .numberController
                                                .text
                                                .isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg: "Enter Number ",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else {
                                              box.write("bundleID",
                                                  data.id.toString());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConfirmPinScreen(),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: 60,
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  AppColors.listbuilderboxColor,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                          (data
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString()),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data.bundleTitle
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          Text(
                                                            data.validityType
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      children: [
                                                        PriceTextView(
                                                          price: data
                                                              .sellingPrice
                                                              .toString(),
                                                        ),
                                                        // Text(
                                                        //   data.sellingPrice.toString(),
                                                        //   style: TextStyle(
                                                        //     fontWeight: FontWeight.w600,
                                                        //     fontSize: 12,
                                                        //   ),
                                                        // ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Text(
                                                          data.currency!.code
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content:
                                                                    Container(
                                                                  height: 160,
                                                                  width:
                                                                      screenWidth,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        "Bundle Details",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Bundle Title : ",
                                                                          ),
                                                                          Text(
                                                                              "${data.bundleTitle}"),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Validity : ",
                                                                          ),
                                                                          Text(
                                                                              "${data.validityType}"),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Buying Price : ",
                                                                          ),
                                                                          Text(
                                                                              "${data.buyingPrice}   ${data.currency!.code.toString()}"),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Text(
                                                          "Details",
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        print("object");
                                      }
                                    },
                                  ),
                                ),
                        )),
                        Obx(
                          () => bundleController.isLoading.value == true
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Loading.....",
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    CircularProgressIndicator(
                                      color: AppColors.defaultColor,
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
