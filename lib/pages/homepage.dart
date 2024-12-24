import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watandaronline/controllers/bundles_controller.dart';
import 'package:watandaronline/controllers/categories_list_controller.dart';
import 'package:watandaronline/controllers/checker.dart';
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/controllers/dashboard_controller.dart';
import 'package:watandaronline/controllers/history_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/order_list_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';
import 'package:watandaronline/controllers/sign_in_controller.dart';
import 'package:watandaronline/controllers/slider_controller.dart';
import 'package:watandaronline/controllers/sub_reseller_controller.dart';
import 'package:watandaronline/controllers/time_zone_controller.dart';
import 'package:watandaronline/helpers/language_helper.dart';
import 'package:watandaronline/pages/orders.dart';
import 'package:watandaronline/routes/routes.dart';
import 'package:watandaronline/screens/order_details_screen.dart';
import 'package:watandaronline/screens/recharge_screen.dart';
import 'package:watandaronline/screens/sign_in_screen.dart';
import 'package:watandaronline/screens/social_recharge.dart';
import 'package:watandaronline/utils/colors.dart';
import 'package:watandaronline/widgets/drawer.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // final TimeZoneController timeZoneController = Get.put(TimeZoneController());

  final box = GetStorage();
  int currentindex = 0;

  bool _showEmptyState = false;
  String checkData = '';

  @override
  void initState() {
    super.initState();
    historyController.fetchHistory();
    categorisListController.nonsocialArray.clear();
    categorisListController.fetchcategories();

    scrollController.addListener(refresh);
    dashboardController.fetchDashboardData();
    // languageController.fetchlanData(box.read("isoCode"));

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  Future<void> refresh() async {
    final int totalPages =
        historyController.allorderlist.value.payload?.pagination.totalPages ??
            0;
    final int currentPage = historyController.initialpage;

    // Prevent loading more pages if we've reached the last page
    if (currentPage >= totalPages) {
      print(
          "End..........................................End.....................");
      return;
    }

    // Check if the scroll position is at the bottom
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      historyController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (historyController.initialpage <= totalPages) {
        print("Load More...................");
        historyController.fetchHistory();
      } else {
        historyController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  final dashboardController = Get.find<DashboardController>();
  final countryListController = Get.find<CountryListController>();
  final historyController = Get.find<HistoryController>();
  final languageController = Get.find<LanguageController>();
  final sliderController = Get.find<SliderController>();
  final categorisListController = Get.find<CategorisListController>();
  final bundleController = Get.find<BundleController>();

  final serviceController = Get.find<ServiceController>();

  final ScrollController scrollController = ScrollController();

  final AdvancedDrawerController advancedDrawerController =
      AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return AdvancedDrawer(
      drawer: DrawerWidget(),
      backdropColor: Colors.black,
      controller: advancedDrawerController,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          surfaceTintColor: Colors.white,
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
              onTap: () {
                drawerController();
              },
              child: Icon(
                Icons.sort,
                color: Colors.black,
              )),
          title: Obx(() => dashboardController.isLoading.value == false
              ? GestureDetector(
                  onTap: () {
                    // print(timeZoneController.myzone.toString());
                    print(box.read("customkey"));
                  },
                  child: Text(
                    dashboardController
                        .alldashboardData.value.data!.userInfo!.resellerName
                        .toString(),
                    style: GoogleFonts.rubik(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : SizedBox()),
        ),
        body: Container(
            height: screenHeight,
            width: screenWidth,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  height: 160,
                  width: screenWidth,
                  // color: Colors.red,
                  child: Obx(
                    () => sliderController.isLoading.value == false
                        ? Column(
                            children: [
                              CarouselSlider(
                                items: sliderController
                                    .allsliderlist.value.data!.advertisements
                                    .map((e) => Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                15.0), // Adjust the radius as needed
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  e.adSliderImageUrl.toString(),
                                              fit: BoxFit.fill,
                                              width: double.infinity,
                                              height: double.infinity,
                                              placeholder: (context, url) {
                                                print(
                                                    'Loading image: $url'); // Debug log
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Colors.grey,
                                                ));
                                              },
                                              errorWidget:
                                                  (context, url, error) {
                                                print(
                                                    'Error loading image: $url, error: $error'); // Debug log
                                                return Icon(Icons.error);
                                              },
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                options: CarouselOptions(
                                  height: 150,
                                  initialPage: 0,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 2),
                                  enlargeCenterPage: true,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ),
                ),

                SizedBox(
                  height: 5,
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 150,
                  width: screenWidth,
                  child: Obx(
                    () => dashboardController.isLoading.value == false
                        ? Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Card(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(
                                                          0.2), // shadow color
                                                  spreadRadius:
                                                      2, // spread radius
                                                  blurRadius: 2, // blur radius
                                                  offset: Offset(0,
                                                      0), // changes position of shadow
                                                ),
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 8,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/icons/balance-sheet.png",
                                                        height: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        getText("BALANCE",
                                                            defaultValue:
                                                                "Balance"),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        NumberFormat.currency(
                                                          locale: 'en_US',
                                                          symbol: '',
                                                          decimalDigits: 2,
                                                        ).format(
                                                          double.parse(
                                                            dashboardController
                                                                .alldashboardData
                                                                .value
                                                                .data!
                                                                .balance
                                                                .toString(),
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        "${box.read("currency_code")}",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Card(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(
                                                          0.2), // shadow color
                                                  spreadRadius:
                                                      2, // spread radius
                                                  blurRadius: 2, // blur radius
                                                  offset: Offset(0,
                                                      0), // changes position of shadow
                                                ),
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 8,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/icons/investment.png",
                                                        height: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        getText("LOAN_BALANCE",
                                                            defaultValue:
                                                                "Loan Balance"),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        NumberFormat.currency(
                                                          locale: 'en_US',
                                                          symbol: '',
                                                          decimalDigits: 2,
                                                        ).format(
                                                          double.parse(
                                                            dashboardController
                                                                .alldashboardData
                                                                .value
                                                                .data!
                                                                .loanBalance
                                                                .toString(),
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        "${box.read("currency_code")}",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Card(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(
                                                          0.2), // shadow color
                                                  spreadRadius:
                                                      2, // spread radius
                                                  blurRadius: 2, // blur radius
                                                  offset: Offset(0,
                                                      0), // changes position of shadow
                                                ),
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 8,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/icons/sales.png",
                                                        height: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        getText("SALE",
                                                            defaultValue:
                                                                "Sale"),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        getText("TODAY_SALE",
                                                            defaultValue:
                                                                "Today Sale : "),
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        NumberFormat.currency(
                                                          locale: 'en_US',
                                                          symbol: '',
                                                          decimalDigits: 2,
                                                        ).format(
                                                          double.parse(
                                                            dashboardController
                                                                .alldashboardData
                                                                .value
                                                                .data!
                                                                .todaySale
                                                                .toString(),
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        "${box.read("currency_code")}",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        getText("TOTAL_SALE",
                                                            defaultValue:
                                                                "Total Sale "),
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        NumberFormat.currency(
                                                          locale: 'en_US',
                                                          symbol: '',
                                                          decimalDigits: 2,
                                                        ).format(
                                                          double.parse(
                                                            dashboardController
                                                                .alldashboardData
                                                                .value
                                                                .data!
                                                                .totalSoldAmount
                                                                .toString(),
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        "${box.read("currency_code")}",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   width: 5,
                                      // ),
                                      Expanded(
                                        flex: 1,
                                        child: Card(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(
                                                          0.2), // shadow color
                                                  spreadRadius:
                                                      2, // spread radius
                                                  blurRadius: 2, // blur radius
                                                  offset: Offset(0,
                                                      0), // changes position of shadow
                                                ),
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 8,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                // crossAxisAlignment:
                                                //     CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/icons/profits.png",
                                                        height: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        getText("PROFIT",
                                                            defaultValue:
                                                                "Profit"),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        getText("TODAY_PROFIT",
                                                            defaultValue:
                                                                "Today Profit : "),
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        NumberFormat.currency(
                                                          locale: 'en_US',
                                                          symbol: '',
                                                          decimalDigits: 2,
                                                        ).format(
                                                          double.parse(
                                                            dashboardController
                                                                .alldashboardData
                                                                .value
                                                                .data!
                                                                .todayProfit
                                                                .toString(),
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        "${box.read("currency_code")}",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        getText("TOTAL_PROFIT",
                                                            defaultValue:
                                                                "Total Profit"),
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        NumberFormat.currency(
                                                          locale: 'en_US',
                                                          symbol: '',
                                                          decimalDigits: 2,
                                                        ).format(
                                                          double.parse(
                                                            dashboardController
                                                                .alldashboardData
                                                                .value
                                                                .data!
                                                                .totalRevenue
                                                                .toString(),
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        "${box.read("currency_code")}",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ),
                ),

                // Container(
                //     margin: EdgeInsets.only(left: 10, right: 10),
                //     height: 60,
                //     color: Colors.white,
                //     width: screenWidth,
                //     child: Obx(
                //       () => dashboardController.isLoading.value == false
                //           ? ListView(
                //               scrollDirection: Axis.horizontal,
                //               children: [
                //                 financialBox(
                //                   boxname: languageController.alllanguageData
                //                       .value.languageData!["BALANCE"]
                //                       .toString(),
                //                   balance: dashboardController
                //                       .alldashboardData.value.data!.balance
                //                       .toString(),
                //                 ),
                //                 SizedBox(
                //                   width: 5,
                //                 ),
                //                 financialBox(
                //                   boxname: languageController.alllanguageData
                //                       .value.languageData!["LOAN_BALANCE"]
                //                       .toString(),
                //                   balance: dashboardController
                //                       .alldashboardData.value.data!.loanBalance
                //                       .toString(),
                //                 ),
                //                 SizedBox(
                //                   width: 5,
                //                 ),
                //                 financialBox(
                //                   boxname: languageController.alllanguageData
                //                       .value.languageData!["TOTAL_SOLD_AMOUNT"]
                //                       .toString(),
                //                   balance: dashboardController.alldashboardData
                //                       .value.data!.totalSoldAmount
                //                       .toString(),
                //                 ),
                //                 SizedBox(
                //                   width: 5,
                //                 ),
                //                 financialBox(
                //                   boxname: languageController.alllanguageData
                //                       .value.languageData!["TOTAL_REVENUE"]
                //                       .toString(),
                //                   balance: dashboardController
                //                       .alldashboardData.value.data!.totalRevenue
                //                       .toString(),
                //                 ),
                //                 SizedBox(
                //                   width: 5,
                //                 ),
                //                 financialBox(
                //                   boxname: languageController.alllanguageData
                //                       .value.languageData!["TODAY_SALE"]
                //                       .toString(),
                //                   balance: dashboardController
                //                       .alldashboardData.value.data!.todaySale
                //                       .toString(),
                //                 ),
                //                 SizedBox(
                //                   width: 5,
                //                 ),
                //                 financialBox(
                //                   boxname: languageController.alllanguageData
                //                       .value.languageData!["TODAY_PROFIT"]
                //                       .toString(),
                //                   balance: dashboardController
                //                       .alldashboardData.value.data!.todayProfit
                //                       .toString(),
                //                 ),
                //               ],
                //             )
                //           : SizedBox(),
                //     )),

                SizedBox(
                  height: 5,
                ),
                Obx(
                  () => languageController.isLoading.value == false
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: GestureDetector(
                            onTap: () {
                              if (countryListController
                                  .finalCountryList.isNotEmpty) {
                                // Find the country where the name is "Afghanistan"
                                var afghanistan = countryListController
                                    .finalCountryList
                                    .firstWhere(
                                  (country) =>
                                      country['country_name'] == "Afghanistan",
                                  orElse: () =>
                                      null, // Return null if not found
                                );

                                if (afghanistan != null) {
                                  print(
                                      "The ID for Afghanistan is: ${afghanistan['id']}");
                                  box.write(
                                      "country_id", "${afghanistan['id']}");
                                  box.write("maxlength", "10");
                                } else {
                                  print("Afghanistan not found in the list");
                                }
                              } else {
                                print("Country list is empty.");
                              }

                              Get.toNamed(customrechargescreen);
                            },
                            child: Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.defaultColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Center(
                                  child: Text(
                                    getText("DIRECT_RECHARGE",
                                        defaultValue: "Direct Recharge"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ),
                SizedBox(
                  height: 5,
                ),
                Obx(
                  () => categorisListController.isLoading.value == false
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 3.0,
                            mainAxisSpacing: 3.0,
                            childAspectRatio: 0.9,
                          ),
                          itemCount:
                              categorisListController.nonsocialArray.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // Handle the extra fixed item
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
                                      builder: (context) =>
                                          SocialRechargeScreen(),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                            final data = categorisListController
                                .nonsocialArray[index - 1];

                            return GestureDetector(
                              onTap: () {
                                serviceController.reserveDigit.clear();
                                bundleController.finalList.clear();

                                box.write(
                                    "maxlength", data["phoneNumberLength"]);

                                box.write("validity_type", "");
                                box.write("company_id", "");
                                box.write("search_tag", "");
                                box.write("country_id", data["countryId"]);

                                box.write(
                                    "service_category_id", data["categoryId"]);
                                bundleController.initialpage = 1;
                                // print(data["phoneNumberLength"]);

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
                                        offset: Offset(0, 0),
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
                                        backgroundImage:
                                            NetworkImage(data["countryImage"]),
                                      ),
                                      Text(
                                        data["categoryName"],
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

                // SizedBox(
                //   height: 2,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 10, right: 10),
                //   child: Container(
                //     child: Obx(
                //       () => languageController.isLoading.value == false
                //           ? Row(
                //               children: [
                //                 Text(
                //                   getText("HISTORY", defaultValue: "History"),
                //                   style: GoogleFonts.rubik(
                //                     color: Colors.black,
                //                     fontSize: 15,
                //                     fontWeight: FontWeight.w600,
                //                   ),
                //                 ),
                //               ],
                //             )
                //           : SizedBox(),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: 400,
                      width: screenWidth,
                      child: Column(
                        children: [
                          Obx(
                            () => historyController.isLoading.value == false
                                ? Container(
                                    child: historyController.allorderlist.value
                                            .data!.orders.isNotEmpty
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
                            child: Obx(() => historyController
                                            .isLoading.value ==
                                        false &&
                                    languageController.isLoading.value ==
                                        false &&
                                    historyController.finalList.isNotEmpty
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
                                          historyController.finalList.length,
                                      itemBuilder: (context, index) {
                                        final data =
                                            historyController.finalList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderDetailsScreen(
                                                  createDate:
                                                      data.createdAt.toString(),
                                                  status:
                                                      data.status.toString(),
                                                  rejectReason: data
                                                      .rejectReason
                                                      .toString(),
                                                  companyName: data
                                                      .bundle!
                                                      .service!
                                                      .company!
                                                      .companyName
                                                      .toString(),
                                                  bundleTitle: data
                                                      .bundle!.bundleTitle!
                                                      .toString(),
                                                  rechargebleAccount: data
                                                      .rechargebleAccount!
                                                      .toString(),
                                                  validityType: data
                                                      .bundle!.validityType!
                                                      .toString(),
                                                  sellingPrice: data
                                                      .bundle!.sellingPrice
                                                      .toString(),
                                                  amount: data.bundle!.amount
                                                      .toString(),
                                                  buyingPrice: data
                                                      .bundle!.buyingPrice
                                                      .toString(),
                                                  orderID: data.id!.toString(),
                                                  resellerName:
                                                      dashboardController
                                                          .alldashboardData
                                                          .value
                                                          .data!
                                                          .userInfo!
                                                          .contactName
                                                          .toString(),
                                                  resellerPhone:
                                                      dashboardController
                                                          .alldashboardData
                                                          .value
                                                          .data!
                                                          .userInfo!
                                                          .phone
                                                          .toString(),
                                                  companyLogo: data
                                                      .bundle!
                                                      .service!
                                                      .company!
                                                      .companyLogo
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 60,
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              // border: Border.all(
                                              //   width: 1,
                                              //   color: Colors.grey,
                                              // ),
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
                                                  // Container(
                                                  //   height: 40,
                                                  //   width: 40,
                                                  //   decoration: BoxDecoration(
                                                  //     image: DecorationImage(
                                                  //       fit: BoxFit.fill,
                                                  //       image: NetworkImage(
                                                  //         data
                                                  //             .bundle!
                                                  //             .service!
                                                  //             .company!
                                                  //             .companyLogo
                                                  //             .toString(),
                                                  //       ),
                                                  //     ),
                                                  //     shape: BoxShape.circle,
                                                  //   ),
                                                  // ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Visibility(
                                                            visible: data
                                                                    .bundle!
                                                                    .bundleTitle
                                                                    .toString() !=
                                                                "",
                                                            child: Flexible(
                                                              child: Text(
                                                                data.bundle!
                                                                    .bundleTitle
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            data.rechargebleAccount
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
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: data.bundle.amount
                                                                  .toString() ==
                                                              "null"
                                                          ? Row(
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
                                                                      data.bundle!
                                                                          .sellingPrice
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Text(
                                                                  " " +
                                                                      box.read(
                                                                          "currency_code"),
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Center(
                                                              child: Text(
                                                                data.bundle
                                                                    .amount
                                                                    .toString(),
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            data.status.toString() ==
                                                                    "0"
                                                                ? languageController
                                                                    .alllanguageData
                                                                    .value
                                                                    .languageData![
                                                                        "PENDING"]
                                                                    .toString()
                                                                : data.status
                                                                            .toString() ==
                                                                        "1"
                                                                    ? languageController
                                                                        .alllanguageData
                                                                        .value
                                                                        .languageData![
                                                                            "CONFIRMED"]
                                                                        .toString()
                                                                    : languageController
                                                                        .alllanguageData
                                                                        .value
                                                                        .languageData![
                                                                            "REJECTED"]
                                                                        .toString(),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: Image.asset(
                                                        data.status.toString() ==
                                                                "0"
                                                            ? "assets/icons/pending.png"
                                                            : data.status
                                                                        .toString() ==
                                                                    "1"
                                                                ? "assets/icons/success.png"
                                                                : "assets/icons/reject.png",
                                                        height: 27,
                                                      ),
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
                                : historyController.finalList.isEmpty
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
                                          itemCount: historyController
                                              .finalList.length,
                                          itemBuilder: (context, index) {
                                            final data = historyController
                                                .finalList[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetailsScreen(
                                                      createDate: data.createdAt
                                                          .toString(),
                                                      status: data.status
                                                          .toString(),
                                                      rejectReason: data
                                                          .rejectReason
                                                          .toString(),
                                                      companyName: data
                                                          .bundle!
                                                          .service!
                                                          .company!
                                                          .companyName
                                                          .toString(),
                                                      bundleTitle: data
                                                          .bundle!.bundleTitle!
                                                          .toString(),
                                                      rechargebleAccount: data
                                                          .rechargebleAccount!
                                                          .toString(),
                                                      validityType: data
                                                          .bundle!.validityType!
                                                          .toString(),
                                                      sellingPrice: data
                                                          .bundle!.sellingPrice
                                                          .toString(),
                                                      amount: data
                                                          .bundle!.amount
                                                          .toString(),
                                                      buyingPrice: data
                                                          .bundle!.buyingPrice
                                                          .toString(),
                                                      orderID:
                                                          data.id!.toString(),
                                                      resellerName:
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .userInfo!
                                                              .contactName
                                                              .toString(),
                                                      resellerPhone:
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .userInfo!
                                                              .phone
                                                              .toString(),
                                                      companyLogo: data
                                                          .bundle!
                                                          .service!
                                                          .company!
                                                          .companyLogo
                                                          .toString(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 60,
                                                width: screenWidth,
                                                decoration: BoxDecoration(
                                                  // border: Border.all(
                                                  //   width: 1,
                                                  //   color: Colors.grey,
                                                  // ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors
                                                      .listbuilderboxColor,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      // Container(
                                                      //   height: 40,
                                                      //   width: 40,
                                                      //   decoration: BoxDecoration(
                                                      //     image: DecorationImage(
                                                      //       fit: BoxFit.fill,
                                                      //       image: NetworkImage(
                                                      //         data
                                                      //             .bundle!
                                                      //             .service!
                                                      //             .company!
                                                      //             .companyLogo
                                                      //             .toString(),
                                                      //       ),
                                                      //     ),
                                                      //     shape: BoxShape.circle,
                                                      //   ),
                                                      // ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Visibility(
                                                                visible: data
                                                                        .bundle!
                                                                        .bundleTitle
                                                                        .toString() !=
                                                                    "",
                                                                child: Flexible(
                                                                  child: Text(
                                                                    data.bundle!
                                                                        .bundleTitle
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                data.rechargebleAccount
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          child: data.bundle
                                                                      .amount
                                                                      .toString() ==
                                                                  "null"
                                                              ? Row(
                                                                  children: [
                                                                    Text(
                                                                      NumberFormat
                                                                          .currency(
                                                                        locale:
                                                                            'en_US',
                                                                        symbol:
                                                                            '',
                                                                        decimalDigits:
                                                                            2,
                                                                      ).format(
                                                                        double
                                                                            .parse(
                                                                          data.bundle!
                                                                              .sellingPrice
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                    Text(
                                                                      " " +
                                                                          box.read(
                                                                              "currency_code"),
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Center(
                                                                  child: Text(
                                                                    data.bundle
                                                                        .amount
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                data.status.toString() ==
                                                                        "0"
                                                                    ? languageController
                                                                        .alllanguageData
                                                                        .value
                                                                        .languageData![
                                                                            "PENDING"]
                                                                        .toString()
                                                                    : data.status.toString() ==
                                                                            "1"
                                                                        ? languageController
                                                                            .alllanguageData
                                                                            .value
                                                                            .languageData![
                                                                                "CONFIRMED"]
                                                                            .toString()
                                                                        : languageController
                                                                            .alllanguageData
                                                                            .value
                                                                            .languageData!["REJECTED"]
                                                                            .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          child: Image.asset(
                                                            data.status.toString() ==
                                                                    "0"
                                                                ? "assets/icons/pending.png"
                                                                : data.status
                                                                            .toString() ==
                                                                        "1"
                                                                    ? "assets/icons/success.png"
                                                                    : "assets/icons/reject.png",
                                                            height: 27,
                                                          ),
                                                        ),
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
                            () => historyController.isLoading.value == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.defaultColor,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void drawerController() {
    advancedDrawerController.showDrawer();
  }
}

class financialBox extends StatelessWidget {
  String? boxname;
  String? balance;
  Color? mycolor;

  financialBox({
    super.key,
    this.boxname,
    this.balance,
    this.mycolor,
  });

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Color of the shadow
            spreadRadius: 2, // How much the shadow spreads
            blurRadius: 2, // The blur radius of the shadow
            offset: Offset(0, 2), // The offset of the shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              boxname.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                Text(
                  "${box.read("currency_code")} : ",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    locale: 'en_US',
                    symbol: '',
                    decimalDigits: 2,
                  ).format(
                    double.parse(
                      balance.toString(),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 12,
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
  }
}
