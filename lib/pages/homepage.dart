import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watandaronline/controllers/bundles_controller.dart';
import 'package:watandaronline/controllers/categories_list_controller.dart';
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/controllers/dashboard_controller.dart';
import 'package:watandaronline/controllers/history_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';
import 'package:watandaronline/controllers/slider_controller.dart';
import 'package:watandaronline/helpers/language_helper.dart';
import 'package:watandaronline/routes/routes.dart';
import 'package:watandaronline/screens/order_details_screen.dart';
import 'package:watandaronline/screens/recharge_screen.dart';
import 'package:watandaronline/screens/social_recharge_screen.dart';
import 'package:watandaronline/utils/colors.dart';
import 'package:watandaronline/widgets/drawer.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import '../controllers/company_controller.dart';
import '../controllers/currency_controller_new.dart';
import '../global controller/languages_controller.dart';

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

  final List<String> imageList = [
    "assets/icons/social-media1.png",
    "assets/icons/intcall.jpeg",
    "assets/icons/social-media3.png",
    "assets/icons/social-media4.png",
    "assets/icons/social-media5.png",
    "assets/icons/social-media6.png",
    "assets/icons/social-media7.png",
  ];
  bool _showEmptyState = false;
  String checkData = '';

  CompanyController companyController = Get.put(CompanyController());
  CurrencyController currencyController = Get.put(CurrencyController());

  @override
  void initState() {
    super.initState();
    currencyController.fetchCurrency();
    companyController.fetchCompany();
    historyController.fetchHistory();
    categorisListController.nonsocialArray.clear();
    categorisListController.fetchcategories();

    // scrollController.addListener(refresh);
    dashboardController.fetchDashboardData();
    // languageController.fetchlanData(box.read("isoCode"));

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  // Future<void> refresh() async {
  //   final int totalPages =
  //       historyController.allorderlist.value.payload?.pagination.totalPages ??
  //           0;
  //   final int currentPage = historyController.initialpage;

  //   // Prevent loading more pages if we've reached the last page
  //   if (currentPage >= totalPages) {
  //     print(
  //         "End..........................................End.....................");
  //     return;
  //   }

  //   // Check if the scroll position is at the bottom
  //   if (scrollController.position.pixels ==
  //       scrollController.position.maxScrollExtent) {
  //     historyController.initialpage++;

  //     // Prevent fetching if the next page exceeds total pages
  //     if (historyController.initialpage <= totalPages) {
  //       print("Load More...................");
  //       historyController.fetchHistory();
  //     } else {
  //       historyController.initialpage =
  //           totalPages; // Reset to the last valid page
  //       print("Already on the last page");
  //     }
  //   }
  // }

  final dashboardController = Get.find<DashboardController>();
  final countryListController = Get.find<CountryListController>();
  final historyController = Get.find<HistoryController>();
  final languagesController = Get.find<LanguagesController>();
  final sliderController = Get.find<SliderController>();
  final categorisListController = Get.find<CategorisListController>();
  final bundleController = Get.find<BundleController>();

  final serviceController = Get.find<ServiceController>();

  final ScrollController scrollController = ScrollController();

  final AdvancedDrawerController advancedDrawerController =
      AdvancedDrawerController();

  String myversion = "1.0.12";
  var maindata;
  var currentversion;
  String? checknow;

  fetchDate() {
    FirebaseFirestore.instance
        .collection("watandaronline")
        .doc("currentversion")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        maindata = documentSnapshot.data();
        checknow = maindata["permission"];
        currentversion = maindata["version"];
        print(maindata["permission"]);
        print("Current version from database: $currentversion");

        if (checknow == "yes") {
          if (myversion != currentversion) {
            _showUpdateDialog();
          } else {
            print("Not checking permission");
          }
        }
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) {
      print("Error fetching data: $error");
    });
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Available"),
          content: Text(
              "A new version of the app is available. Please update to version $currentversion."),
          actions: [
            TextButton(
              onPressed: () {
                _launchURL(
                    "https://play.google.com/store/apps/details?id=com.watandaronline.woosat");
              },
              child: Text("Update Now"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchDate();
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
                    fetchDate();
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
                                            errorWidget: (context, url, error) {
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
                                                color: Colors.grey.withOpacity(
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
                                                      languagesController
                                                          .tr("BALANCE"),
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
                                                color: Colors.grey.withOpacity(
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
                                                      languagesController
                                                          .tr("LOAN_BALANCE"),
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
                                                color: Colors.grey.withOpacity(
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
                                                      languagesController
                                                          .tr("SALE"),
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
                                                      languagesController
                                                          .tr("TODAY_SALE"),
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
                                                      languagesController
                                                          .tr("TOTAL_SALE"),
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
                                                color: Colors.grey.withOpacity(
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
                                                      languagesController
                                                          .tr("PROFIT"),
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
                                                      languagesController
                                                          .tr("TODAY_PROFIT"),
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
                                                      languagesController
                                                          .tr("TOTAL_PROFIT"),
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
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: GestureDetector(
                  onTap: () {
                    if (countryListController.finalCountryList.isNotEmpty) {
                      // Find the country where the name is "Afghanistan"
                      var afghanistan =
                          countryListController.finalCountryList.firstWhere(
                        (country) => country['country_name'] == "Afghanistan",
                        orElse: () => null, // Return null if not found
                      );

                      if (afghanistan != null) {
                        print(
                            "The ID for Afghanistan is: ${afghanistan['id']}");
                        box.write("country_id", "${afghanistan['id']}");
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
                          languagesController.tr("DIRECT_RECHARGE"),
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
              ),
              SizedBox(
                height: 5,
              ),
              Obx(
                () => categorisListController.isLoading.value == false
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: GridView.builder(
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
                              categorisListController.finalArrayCatList.length,
                          itemBuilder: (context, index) {
                            final data = categorisListController
                                .finalArrayCatList[index];

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
                                box.write("catName", data["categoryName"]);
                                bundleController.initialpage = 1;
                                print(data["type"]);

                                if (data["type"] == "social") {
                                  Get.toNamed(socialrechargescreen);
                                } else {
                                  box.write("catName", data["categoryName"]);
                                  box.write(
                                      "flagimageurl", data["countryImage"]);

                                  Get.toNamed(
                                    rechargescreen,
                                  );
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
                                        flex: 4,
                                        child: data["type"] == "nonsocial"
                                            ? Container(
                                                child: Center(
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage:
                                                        NetworkImage(data[
                                                            "countryImage"]),
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
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
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
