import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:watandaronline/controllers/reserve_digit_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';
import 'package:watandaronline/helpers/price.dart';
import 'package:watandaronline/routes/routes.dart';
import 'package:watandaronline/screens/confirm_pin.dart';
import 'package:watandaronline/widgets/auth_textfield.dart';
import 'package:watandaronline/widgets/default_button.dart';
import 'package:watandaronline/widgets/number_textfield.dart';
import 'package:watandaronline/widgets/rechange_number_box.dart';

import '../controllers/confirm_pin_controller.dart';
import '../controllers/operator_controller.dart';
import '../utils/colors.dart';

class RechargeScreen extends StatefulWidget {
  RechargeScreen({
    super.key,
  });

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  int selectedIndex = -1;
  int duration_selectedIndex = 0;

  List<Map<String, String>> duration = [];
  void initializeDuration() {
    duration = [
      {
        "Name": languageController.alllanguageData.value.languageData!["ALL"]
            .toString(),
        "Value": "",
      },
      {
        "Name": languageController
            .alllanguageData.value.languageData!["UNLIMITED"]
            .toString(),
        "Value": "unlimited",
      },
      {
        "Name": languageController
            .alllanguageData.value.languageData!["MONTHLY"]
            .toString(),
        "Value": "monthly",
      },
      {
        "Name": languageController.alllanguageData.value.languageData!["WEEKLY"]
            .toString(),
        "Value": "weekly",
      },
      {
        "Name": languageController.alllanguageData.value.languageData!["DAILY"]
            .toString(),
        "Value": "daily",
      },
      {
        "Name": languageController.alllanguageData.value.languageData!["HOURLY"]
            .toString(),
        "Value": "hourly",
      },
      {
        "Name": languageController
            .alllanguageData.value.languageData!["NIGHTLY"]
            .toString(),
        "Value": "nightly",
      },
    ];
  }

  final box = GetStorage();
  final serviceController = Get.find<ServiceController>();
  final bundleController = Get.find<BundleController>();
  final confirmPinController = Get.find<ConfirmPinController>();
  final languageController = Get.find<LanguageController>();

  TextEditingController searchController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  String search = "";

  @override
  void initState() {
    super.initState();
    bundleController.finalList.clear();
    bundleController.initialpage = 1;

    confirmPinController.numberController.addListener(oncleared);
    initializeDuration();
    bundleController.fetchallbundles();
    scrollController.addListener(refresh);
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fetchservices();
    });
  }

  void oncleared() {
    if (confirmPinController.numberController.text.isEmpty) {
      setState(() {});
    } else {}
  }

  Future<void> refresh() async {
    final int totalPages =
        bundleController.allbundleslist.value.payload?.pagination!.totalPages ??
            0;
    final int currentPage = bundleController.initialpage;

    // Prevent loading more pages if we've reached the last page
    if (currentPage >= totalPages) {
      print(
          "End..........................................End.....................");
      return;
    }

    // Check if the scroll position is at the bottom
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      bundleController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (bundleController.initialpage <= totalPages) {
        print("Load More...................");
        bundleController.fetchallbundles();
      } else {
        bundleController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        confirmPinController.numberController.clear();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff2980b9),
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
          backgroundColor: Color(0xff2980b9),
          elevation: 0.0,
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              print(box.read("permission"));
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
                    color: Color(0xff2980b9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextField(
                          confirmPinController:
                              confirmPinController.numberController,
                          languageData: languageController.alllanguageData.value
                              .languageData!["ENTER_YOUR_NUMBER"]
                              .toString(),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 50,
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          child: Obx(
                            () {
                              // Get all services
                              final services = serviceController
                                      .allserviceslist.value.data?.services ??
                                  [];

                              // Filter services based on input text
                              final filteredServices = confirmPinController
                                      .numberController.text.isEmpty
                                  ? services
                                  : services.where((service) {
                                      return service.company?.companycodes
                                              ?.any((code) {
                                            final reservedDigit =
                                                code.reservedDigit ?? '';
                                            return confirmPinController
                                                .numberController.text
                                                .startsWith(reservedDigit);
                                          }) ??
                                          false;
                                    }).toList();

                              // Use filteredServices or fallback to all services
                              final displayServices = filteredServices.isEmpty
                                  ? services
                                  : filteredServices;

                              // Check if services are loading
                              if (serviceController.isLoading.value) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.grey,
                                    strokeWidth: 1.0,
                                  ),
                                );
                              }

                              // Render the services
                              return Center(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(width: 5);
                                  },
                                  scrollDirection: Axis.horizontal,
                                  itemCount: displayServices.length,
                                  itemBuilder: (context, index) {
                                    final data = displayServices[index];

                                    return GestureDetector(
                                      onTap: () {
                                        bundleController.initialpage = 1;
                                        bundleController.finalList.clear();
                                        box.write("company_id", data.companyId);
                                        bundleController.fetchallbundles();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 65,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                data.company?.companyLogo ?? '',
                                            placeholder: (context, url) {
                                              print('Loading image: $url');
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                            errorWidget: (context, url, error) {
                                              print(
                                                  'Error loading image: $url, error: $error');
                                              return Icon(Icons.error);
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          width: screenWidth,
                          height: 25,
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return VerticalDivider();
                            },
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
                                  decoration: BoxDecoration(),
                                  height: 30,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      child: Text(
                                        duration[index]["Name"]!,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: duration_selectedIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w400,
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
                flex: 10,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      color: Colors.white.withOpacity(0.8),
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
                            height: 50,
                            width: screenWidth,
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: TextField(
                                onChanged: (value) {
                                  bundleController.finalList.clear();
                                  bundleController.initialpage = 1;
                                  box.write("search_tag", value.toString());
                                  bundleController.fetchallbundles();
                                  print(value.toString());
                                },
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      // bundleController.finalList.clear();
                                      // box.write("search_tag", "1.5");
                                      // bundleController.fetchallbundles();
                                    },
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
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
                          Obx(
                            () => bundleController.isLoading.value == false
                                ? Container(
                                    child: bundleController.allbundleslist.value
                                            .data!.bundles!.isNotEmpty
                                        ? SizedBox()
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/empty.png",
                                                  height: 80,
                                                ),
                                                Text("No Data found"),
                                              ],
                                            ),
                                          ),
                                  )
                                : SizedBox(),
                          ),
                          Expanded(
                            child: Obx(() => bundleController.isLoading.value ==
                                        false &&
                                    bundleController.finalList.isNotEmpty
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
                                        return GestureDetector(
                                          onTap: () {
                                            if (confirmPinController
                                                .numberController
                                                .text
                                                .isEmpty) {
                                              Fluttertoast.showToast(
                                                msg: "Enter Number ",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            } else {
                                              if (box.read("permission") ==
                                                      "no" ||
                                                  confirmPinController
                                                          .numberController
                                                          .text
                                                          .length
                                                          .toString() !=
                                                      box
                                                          .read("maxlength")
                                                          .toString()) {
                                                Fluttertoast.showToast(
                                                  msg: "Enter Correct Number ",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                                // Stop further execution if permission is "no"
                                              } else {
                                                box.write("bundleID",
                                                    data.id.toString());

                                                Get.toNamed(confirmpinscreen);
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 45,
                                                    width: 45,
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
                                                  SizedBox(
                                                    width: 5,
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
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                          Text(
                                                            data.validityType
                                                                        .toString() ==
                                                                    "unlimited"
                                                                ? languageController
                                                                    .alllanguageData
                                                                    .value
                                                                    .languageData![
                                                                        "UNLIMITED"]
                                                                    .toString()
                                                                : data.validityType
                                                                            .toString() ==
                                                                        "monthly"
                                                                    ? languageController
                                                                        .alllanguageData
                                                                        .value
                                                                        .languageData![
                                                                            "MONTHLY"]
                                                                        .toString()
                                                                    : data.validityType.toString() ==
                                                                            "weekly"
                                                                        ? languageController
                                                                            .alllanguageData
                                                                            .value
                                                                            .languageData![
                                                                                "WEEKLY"]
                                                                            .toString()
                                                                        : data.validityType.toString() ==
                                                                                "daily"
                                                                            ? languageController.alllanguageData.value.languageData!["DAILY"].toString()
                                                                            : data.validityType.toString() == "hourly"
                                                                                ? languageController.alllanguageData.value.languageData!["HOURLY"].toString()
                                                                                : data.validityType.toString() == "nightly"
                                                                                    ? languageController.alllanguageData.value.languageData!["NIGHTLY"].toString()
                                                                                    : "",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              languageController
                                                                  .alllanguageData
                                                                  .value
                                                                  .languageData![
                                                                      "SELL"]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 8,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            PriceTextView(
                                                              price: data
                                                                  .sellingPrice
                                                                  .toString(),
                                                            ),
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                              " ${box.read("currency_code")}",
                                                              style: TextStyle(
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              languageController
                                                                  .alllanguageData
                                                                  .value
                                                                  .languageData![
                                                                      "BUY"]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 8,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              NumberFormat
                                                                  .currency(
                                                                locale: 'en_US',
                                                                symbol: '',
                                                                decimalDigits:
                                                                    2,
                                                              ).format(
                                                                double.parse(
                                                                  data.buyingPrice
                                                                      .toString(),
                                                                ),
                                                              ),
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            Text(
                                                              " ${box.read("currency_code")}",
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : bundleController.finalList.isEmpty
                                    ? SizedBox()
                                    : RefreshIndicator(
                                        onRefresh: refresh,
                                        child: ListView.separated(
                                          shrinkWrap: false,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          controller: scrollController,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(
                                              height: 5,
                                            );
                                          },
                                          itemCount:
                                              bundleController.finalList.length,
                                          itemBuilder: (context, index) {
                                            final data = bundleController
                                                .finalList[index];
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
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                } else {
                                                  if (box.read("permission") ==
                                                          "no" ||
                                                      confirmPinController
                                                              .numberController
                                                              .text
                                                              .length
                                                              .toString() !=
                                                          box
                                                              .read("maxlength")
                                                              .toString()) {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Enter Correct Number ",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.black,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0,
                                                    );
                                                    // Stop further execution if permission is "no"
                                                  } else {
                                                    box.write("bundleID",
                                                        data.id.toString());
                                                    Get.toNamed(
                                                        confirmpinscreen);
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: screenWidth,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  color: Colors.white,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 45,
                                                        width: 45,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
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
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
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
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                              Text(
                                                                data.validityType
                                                                            .toString() ==
                                                                        "unlimited"
                                                                    ? languageController
                                                                        .alllanguageData
                                                                        .value
                                                                        .languageData![
                                                                            "UNLIMITED"]
                                                                        .toString()
                                                                    : data.validityType.toString() ==
                                                                            "monthly"
                                                                        ? languageController
                                                                            .alllanguageData
                                                                            .value
                                                                            .languageData![
                                                                                "MONTHLY"]
                                                                            .toString()
                                                                        : data.validityType.toString() ==
                                                                                "weekly"
                                                                            ? languageController.alllanguageData.value.languageData!["WEEKLY"].toString()
                                                                            : data.validityType.toString() == "daily"
                                                                                ? languageController.alllanguageData.value.languageData!["DAILY"].toString()
                                                                                : data.validityType.toString() == "hourly"
                                                                                    ? languageController.alllanguageData.value.languageData!["HOURLY"].toString()
                                                                                    : data.validityType.toString() == "nightly"
                                                                                        ? languageController.alllanguageData.value.languageData!["NIGHTLY"].toString()
                                                                                        : "",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  languageController
                                                                      .alllanguageData
                                                                      .value
                                                                      .languageData![
                                                                          "SELL"]
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: 8,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                PriceTextView(
                                                                  price: data
                                                                      .sellingPrice
                                                                      .toString(),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Text(
                                                                  " ${box.read("currency_code")}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: 9,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  languageController
                                                                      .alllanguageData
                                                                      .value
                                                                      .languageData![
                                                                          "BUY"]
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: 8,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  NumberFormat
                                                                      .currency(
                                                                    locale:
                                                                        'en_US',
                                                                    symbol: '',
                                                                    decimalDigits:
                                                                        2,
                                                                  ).format(
                                                                    double
                                                                        .parse(
                                                                      data.buyingPrice
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                Text(
                                                                  " ${box.read("currency_code")}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )),
                          ),
                          Obx(
                            () => bundleController.isLoading.value == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
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
      ),
    );
  }
}
