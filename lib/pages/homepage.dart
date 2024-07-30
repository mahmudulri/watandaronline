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
import 'package:watandaronline/controllers/checker.dart';
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/controllers/dashboard_controller.dart';
import 'package:watandaronline/controllers/history_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/order_list_controller.dart';
import 'package:watandaronline/controllers/sign_in_controller.dart';
import 'package:watandaronline/controllers/sub_reseller_controller.dart';
import 'package:watandaronline/pages/orders.dart';
import 'package:watandaronline/screens/sign_in_screen.dart';
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

  List<String> assets = [
    'assets/images/img1.png',
    'assets/images/img2.png',
    'assets/images/img4.png',
    'assets/images/img5.png'
  ];

  final box = GetStorage();
  int currentindex = 0;

  @override
  void initState() {
    super.initState();
    fetchTimeData();
    scrollController.addListener(refresh);
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardController.fetchDashboardData();
      subresellerController.fetchSubReseller();
      historyController.fetchHistory();
    });
  }

  Future<void> refresh() async {
    if (historyController.finalList.length >=
        (historyController.allorderlist.value.payload?.pagination.totalItems ??
            0)) {
      print(
          "End..........................................End.....................");
    } else {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        historyController.initialpage++;
        print("Load More...................");
        historyController.fetchHistory();
      } else {
        // print("nothing");
      }
    }
  }

  final DashboardController dashboardController =
      Get.put(DashboardController());
  final CountryListController countryListController =
      Get.put(CountryListController());
  final SubresellerController subresellerController =
      Get.put(SubresellerController());

  // final OrderlistController orderlistController =
  //     Get.put(OrderlistController());

  final HistoryController historyController = Get.put(HistoryController());

  GlobalKey _globalKey = GlobalKey();

  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      if (boundary != null) {
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          Uint8List pngBytes = byteData.buffer.asUint8List();

          // Save to gallery
          final result = await ImageGallerySaver.saveImage(pngBytes,
              quality: 100, name: "screenshot");
          print(result);
          Get.snackbar(
            languageController.alllanguageData.value.languageData!["SUCCESS"]
                .toString(),
            languageController
                .alllanguageData.value.languageData!["SAVED_IMAGE_TO_GALLERY"]
                .toString(),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  final LanguageController languageController = Get.put(LanguageController());

  final SignInController signInController = Get.put(SignInController());
  final ScrollController scrollController = ScrollController();

  String sign = '';
  String hour = '';
  String minute = '';
  Future<void> fetchTimeData() async {
    final response = await http.get(Uri.parse(
        'https://worldtimeapi.org/api/timezone/${box.read("timezone")}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final utcOffset = data['utc_offset'];

      setState(() {
        sign = utcOffset[0];
        hour = utcOffset.substring(1, 3);
        minute = utcOffset.substring(4, 6);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Text convertToLocalTime(
    String utcTimeString,
  ) {
    String localTimeString;
    try {
      // Parse the UTC time
      DateTime utcTime = DateTime.parse(utcTimeString);

      // Calculate the offset duration
      Duration offset = Duration(
          hours: int.parse(hour.toString()),
          minutes: int.parse(minute.toString()));

      // Apply the offset (subtracting for negative)

      if (sign == "+") {
        DateTime localTime = utcTime.add(offset);
        String formattedTime =
            DateFormat('yyyy-MM-dd    hh:mm:ss a').format(localTime);
        localTimeString = '$formattedTime';
      } else {
        DateTime localTime = utcTime.subtract(offset);
        String formattedTime =
            DateFormat('yyyy-MM-dd    hh:mm:ss a').format(localTime);
        localTimeString = '$formattedTime';
      }
    } catch (e) {
      localTimeString = '';
    }
    return Text(
      localTimeString,
      style: TextStyle(fontSize: 12),
    );
  }

  final GlobalKey _hglobalKey = GlobalKey();
  Future<void> captureImageFromWidgetAsFile(GlobalKey _hglobalKey) async {
    RenderRepaintBoundary boundary =
        _hglobalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List unit8list = byteData!.buffer.asUint8List();

    Directory tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/image.png';
    File(path).writeAsBytesSync(unit8list);
    await Share.shareFiles([path]);
  }

  final AdvancedDrawerController advancedDrawerController =
      AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return AdvancedDrawer(
        controller: advancedDrawerController,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            scrolledUnderElevation: 0.0,
            elevation: 0.0,
            // backgroundColor: AppColors.defaultColor,
            leading: GestureDetector(
                onTap: () {
                  drawerController();
                },
                child: Icon(Icons.sort)),
            title: Obx(() => dashboardController.isLoading.value == false &&
                    countryListController.isLoading.value == false
                ? Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            dashboardController.alldashboardData.value.data!
                                .userInfo!.resellerName
                                .toString(),
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "-" +
                                  countryListController.finalCountryList
                                      .firstWhere((element) =>
                                          element['id'].toString() ==
                                          dashboardController
                                              .alldashboardData
                                              .value
                                              .data!
                                              .userInfo!
                                              .countryId)["country_name"],
                              style: GoogleFonts.rubik(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                : SizedBox()),
          ),
          body: Container(
              height: screenHeight,
              width: screenWidth,
              child: Obx(
                () => dashboardController.isLoading.value == false
                    ? ListView(
                        children: [
                          Container(
                            height: 160,
                            width: screenWidth,
                            // color: Colors.red,
                            child: Column(
                              children: [
                                CarouselSlider(
                                  items: dashboardController.alldashboardData
                                      .value.data!.advertisementSliders!
                                      .map((e) => Center(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                  15.0), // Adjust the radius as needed
                                              child: CachedNetworkImage(
                                                imageUrl: e.adSliderImageUrl
                                                    .toString(),
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
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  languageController.alllanguageData.value
                                      .languageData!["FINANCIAL_INQUIRY"]
                                      .toString(),
                                  style: GoogleFonts.rubik(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            width: screenWidth,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: financialBox(
                                    boxname: languageController.alllanguageData
                                        .value.languageData!["BALANCE"]
                                        .toString(),
                                    balance: dashboardController
                                        .alldashboardData.value.data!.balance
                                        .toString(),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: financialBox(
                                    boxname: languageController.alllanguageData
                                        .value.languageData!["LOAN_BALANCE"]
                                        .toString(),
                                    balance: dashboardController
                                        .alldashboardData
                                        .value
                                        .data!
                                        .loanBalance
                                        .toString(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            width: screenWidth,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: financialBox(
                                    boxname: languageController
                                        .alllanguageData
                                        .value
                                        .languageData!["TOTAL_SOLD_AMOUNT"]
                                        .toString(),
                                    balance: dashboardController
                                        .alldashboardData
                                        .value
                                        .data!
                                        .totalSoldAmount
                                        .toString(),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: financialBox(
                                    boxname: languageController.alllanguageData
                                        .value.languageData!["TOTAL_REVENUE"]
                                        .toString(),
                                    balance: dashboardController
                                        .alldashboardData
                                        .value
                                        .data!
                                        .totalRevenue
                                        .toString(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            width: screenWidth,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: financialBox(
                                    boxname: languageController.alllanguageData
                                        .value.languageData!["TODAY_SALE"]
                                        .toString(),
                                    balance: dashboardController
                                        .alldashboardData.value.data!.todaySale
                                        .toString(),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: financialBox(
                                    boxname: languageController.alllanguageData
                                        .value.languageData!["TODAY_PROFIT"]
                                        .toString(),
                                    balance: dashboardController
                                        .alldashboardData
                                        .value
                                        .data!
                                        .todayProfit
                                        .toString(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text(
                                  languageController.alllanguageData.value
                                      .languageData!["HISTORY"]
                                      .toString(),
                                  style: GoogleFonts.rubik(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    child: Obx(
                                  () =>
                                      historyController.isLoading.value == true
                                          ? Text(
                                              "Loading.......",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            )
                                          : SizedBox(),
                                )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 400,
                              width: screenWidth,
                              child: Column(
                                children: [
                                  Expanded(
                                    child:
                                        Obx(
                                            () =>
                                                historyController
                                                            .isLoading.value ==
                                                        false
                                                    ? RefreshIndicator(
                                                        onRefresh: refresh,
                                                        child:
                                                            ListView.separated(
                                                          shrinkWrap: false,
                                                          physics:
                                                              AlwaysScrollableScrollPhysics(),
                                                          controller:
                                                              scrollController,
                                                          separatorBuilder:
                                                              (context, index) {
                                                            return SizedBox(
                                                              height: 5,
                                                            );
                                                          },
                                                          itemCount:
                                                              historyController
                                                                  .finalList
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final data =
                                                                historyController
                                                                        .finalList[
                                                                    index];
                                                            return GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        insetPadding:
                                                                            EdgeInsets.all(0),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          height:
                                                                              screenHeight,
                                                                          width:
                                                                              screenWidth,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(
                                                                              horizontal: 25,
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                RepaintBoundary(
                                                                                  key: _hglobalKey,
                                                                                  child: Container(
                                                                                    height: 420,
                                                                                    width: screenWidth,
                                                                                    decoration: BoxDecoration(
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          color: Colors.grey.withOpacity(0.2), // shadow color
                                                                                          spreadRadius: 4, // spread radius
                                                                                          blurRadius: 4, // blur radius
                                                                                          offset: Offset(0, 3), // changes position of shadow
                                                                                        ),
                                                                                        BoxShadow(
                                                                                          color: Colors.grey.withOpacity(0.2), // shadow color
                                                                                          spreadRadius: 4, // spread radius
                                                                                          blurRadius: 4, // blur radius
                                                                                          offset: Offset(3, 0), // changes position of shadow
                                                                                        ),
                                                                                      ],
                                                                                      color: Colors.white,
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            height: 15,
                                                                                          ),
                                                                                          Row(
                                                                                            children: [
                                                                                              Expanded(
                                                                                                flex: 1,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                  children: [
                                                                                                    GestureDetector(
                                                                                                      onTap: () async {
                                                                                                        captureImageFromWidgetAsFile(_hglobalKey);

                                                                                                        print("done");
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        width: 90,
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: AppColors.defaultColor,
                                                                                                          borderRadius: BorderRadius.circular(5),
                                                                                                        ),
                                                                                                        child: Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: [
                                                                                                            Padding(
                                                                                                              padding: EdgeInsets.symmetric(
                                                                                                                horizontal: 5,
                                                                                                                vertical: 3,
                                                                                                              ),
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  languageController.alllanguageData.value.languageData!["SHARE"].toString(),
                                                                                                                  style: TextStyle(
                                                                                                                    color: Colors.white,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                flex: 1,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      height: 40,
                                                                                                      width: 50,
                                                                                                      decoration: BoxDecoration(
                                                                                                        shape: BoxShape.circle,
                                                                                                        image: DecorationImage(
                                                                                                          fit: BoxFit.fill,
                                                                                                          image: AssetImage(
                                                                                                            "assets/icons/logo.png",
                                                                                                          ),
                                                                                                        ),
                                                                                                        // color: Colors.red,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                flex: 1,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                                  children: [
                                                                                                    GestureDetector(
                                                                                                      onTap: () {
                                                                                                        Navigator.pop(context);
                                                                                                      },
                                                                                                      child: Icon(
                                                                                                        Icons.close,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 15,
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              convertToLocalTime(
                                                                                                data.createdAt.toString(),
                                                                                              ),
                                                                                              // Text(
                                                                                              //   DateFormat('dd MMM yyyy')
                                                                                              //       .format(
                                                                                              //     DateTime
                                                                                              //         .parse(
                                                                                              //       data.createdAt.toString(),
                                                                                              //     ),
                                                                                              //   ),
                                                                                              //   style:
                                                                                              //       TextStyle(
                                                                                              //     color:
                                                                                              //         Colors.grey,
                                                                                              //     fontSize:
                                                                                              //         12,
                                                                                              //   ),
                                                                                              // ),
                                                                                              // SizedBox(
                                                                                              //   width:
                                                                                              //       15,
                                                                                              // ),
                                                                                              // Text(
                                                                                              //   DateFormat('hh:mm a')
                                                                                              //       .format(
                                                                                              //     DateTime
                                                                                              //         .parse(
                                                                                              //       data.createdAt.toString(),
                                                                                              //     ),
                                                                                              //   ),
                                                                                              //   style:
                                                                                              //       TextStyle(
                                                                                              //     color:
                                                                                              //         Colors.grey,
                                                                                              //     fontSize:
                                                                                              //         12,
                                                                                              //   ),
                                                                                              // ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 25,
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.symmetric(
                                                                                              horizontal: 0,
                                                                                            ),
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      languageController.alllanguageData.value.languageData!["ORDER_STATUS"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.green,
                                                                                                        fontSize: 17,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      data.status.toString() == "0"
                                                                                                          ? languageController.alllanguageData.value.languageData!["PENDING"].toString()
                                                                                                          : data.status.toString() == "1"
                                                                                                              ? languageController.alllanguageData.value.languageData!["CONFIRMED"].toString()
                                                                                                              : languageController.alllanguageData.value.languageData!["REJECTED"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 17,
                                                                                                        fontWeight: FontWeight.w400,
                                                                                                        color: data.status.toString() == "0"
                                                                                                            ? Colors.grey
                                                                                                            : data.status.toString() == "1"
                                                                                                                ? Colors.green
                                                                                                                : Colors.red,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                Visibility(
                                                                                                  visible: data.status.toString() == "2",
                                                                                                  child: Text(
                                                                                                    data.rejectReason.toString(),
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.red,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 3,
                                                                                                ),
                                                                                                dotline(),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      languageController.alllanguageData.value.languageData!["NETWORK_TYPE"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      data.bundle!.service!.company!.companyName.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      languageController.alllanguageData.value.languageData!["BUNDLE_TYPE"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      data.bundle!.bundleTitle!.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      languageController.alllanguageData.value.languageData!["PHONE_NUMBER"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      data.rechargebleAccount!.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      languageController.alllanguageData.value.languageData!["VALIDITY_TYPE"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      data.bundle!.validityType!.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      languageController.alllanguageData.value.languageData!["ORDER_ID"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      data.id!.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                dotline(),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 30,
                                                                                          ),
                                                                                          // GestureDetector(
                                                                                          //   onTap: () {
                                                                                          //     _capturePng();
                                                                                          //   },
                                                                                          //   child: Container(
                                                                                          //     height: 35,
                                                                                          //     width: 100,
                                                                                          //     decoration:
                                                                                          //         BoxDecoration(
                                                                                          //       color:
                                                                                          //           Colors.blue,
                                                                                          //       borderRadius:
                                                                                          //           BorderRadius
                                                                                          //               .circular(
                                                                                          //                   8),
                                                                                          //     ),
                                                                                          //     child: Center(
                                                                                          //       child: Text(
                                                                                          //         "Save PNG",
                                                                                          //         style:
                                                                                          //             TextStyle(
                                                                                          //           color: Colors
                                                                                          //               .white,
                                                                                          //           fontWeight:
                                                                                          //               FontWeight
                                                                                          //                   .w500,
                                                                                          //         ),
                                                                                          //       ),
                                                                                          //     ),
                                                                                          //   ),
                                                                                          // ),

                                                                                          // Row(
                                                                                          //   mainAxisAlignment:
                                                                                          //       MainAxisAlignment
                                                                                          //           .end,
                                                                                          //   children: [
                                                                                          //     GestureDetector(
                                                                                          //       onTap: () {
                                                                                          //         _capturePng();
                                                                                          //       },
                                                                                          //       child: Icon(
                                                                                          //         FontAwesomeIcons
                                                                                          //             .fileArrowDown,
                                                                                          //         color: Colors
                                                                                          //             .grey,
                                                                                          //       ),
                                                                                          //     ),
                                                                                          //   ],
                                                                                          // ),
                                                                                          SizedBox(
                                                                                            height: 10,
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              Container(
                                                                                                height: 55,
                                                                                                width: 140,
                                                                                                child: Column(
                                                                                                  children: [
                                                                                                    Divider(
                                                                                                      thickness: 1,
                                                                                                      color: Colors.black,
                                                                                                    ),
                                                                                                    Container(
                                                                                                      child: Text(
                                                                                                        dashboardController.alldashboardData.value.data!.userInfo!.contactName.toString(),
                                                                                                        style: GoogleFonts.josefinSans(
                                                                                                          color: Colors.black,
                                                                                                          fontSize: 13,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Divider(
                                                                                                      thickness: 1,
                                                                                                      color: Colors.black,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                              child: Container(
                                                                height: 60,
                                                                width:
                                                                    screenWidth,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  // border: Border.all(
                                                                  //   width: 1,
                                                                  //   color: Colors.grey,
                                                                  // ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: AppColors
                                                                      .listbuilderboxColor,
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            40,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            image:
                                                                                NetworkImage(
                                                                              data.bundle!.service!.company!.companyLogo.toString(),
                                                                            ),
                                                                          ),
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 5),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Flexible(
                                                                                child: Text(
                                                                                  data.bundle!.bundleTitle.toString(),
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: 14,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                data.rechargebleAccount.toString(),
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 12,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              NumberFormat.currency(
                                                                                locale: 'en_US',
                                                                                symbol: '',
                                                                                decimalDigits: 2,
                                                                              ).format(
                                                                                double.parse(
                                                                                  data.bundle!.sellingPrice.toString(),
                                                                                ),
                                                                              ),
                                                                              style: TextStyle(
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 2,
                                                                            ),
                                                                            Text(
                                                                              " " + box.read("currency_code"),
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 11,
                                                                                color: Colors.grey,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              // Icon(
                                                                              //   Icons.check,
                                                                              //   color: Colors.green,
                                                                              //   size: 14,
                                                                              // ),
                                                                              Text(
                                                                                data.status.toString() == "0"
                                                                                    ? languageController.alllanguageData.value.languageData!["PENDING"].toString()
                                                                                    : data.status.toString() == "1"
                                                                                        ? languageController.alllanguageData.value.languageData!["CONFIRMED"].toString()
                                                                                        : languageController.alllanguageData.value.languageData!["REJECTED"].toString(),
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  color: Colors.black,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                              // Text(
                                                                              //   "2 days ago",
                                                                              //   style: TextStyle(
                                                                              //     color: Colors.green,
                                                                              //     fontSize: 10,
                                                                              //     fontWeight:
                                                                              //         FontWeight.w600,
                                                                              //   ),
                                                                              // ),
                                                                            ],
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
                                                    : RefreshIndicator(
                                                        onRefresh: refresh,
                                                        child:
                                                            ListView.separated(
                                                          shrinkWrap: false,
                                                          physics:
                                                              AlwaysScrollableScrollPhysics(),
                                                          controller:
                                                              scrollController,
                                                          separatorBuilder:
                                                              (context, index) {
                                                            return SizedBox(
                                                              height: 5,
                                                            );
                                                          },
                                                          itemCount:
                                                              historyController
                                                                  .finalList
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final data =
                                                                historyController
                                                                        .finalList[
                                                                    index];
                                                            return GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        insetPadding:
                                                                            EdgeInsets.all(0),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          height:
                                                                              screenHeight,
                                                                          width:
                                                                              screenWidth,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(
                                                                              horizontal: 25,
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                RepaintBoundary(
                                                                                  key: _hglobalKey,
                                                                                  child: Container(
                                                                                    height: 420,
                                                                                    width: screenWidth,
                                                                                    decoration: BoxDecoration(
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          color: Colors.grey.withOpacity(0.2), // shadow color
                                                                                          spreadRadius: 4, // spread radius
                                                                                          blurRadius: 4, // blur radius
                                                                                          offset: Offset(0, 3), // changes position of shadow
                                                                                        ),
                                                                                        BoxShadow(
                                                                                          color: Colors.grey.withOpacity(0.2), // shadow color
                                                                                          spreadRadius: 4, // spread radius
                                                                                          blurRadius: 4, // blur radius
                                                                                          offset: Offset(3, 0), // changes position of shadow
                                                                                        ),
                                                                                      ],
                                                                                      color: Colors.white,
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            height: 15,
                                                                                          ),
                                                                                          Row(
                                                                                            children: [
                                                                                              Expanded(
                                                                                                flex: 1,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                  children: [
                                                                                                    GestureDetector(
                                                                                                      onTap: () async {
                                                                                                        captureImageFromWidgetAsFile(_hglobalKey);

                                                                                                        print("done");
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        width: 90,
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: AppColors.defaultColor,
                                                                                                          borderRadius: BorderRadius.circular(5),
                                                                                                        ),
                                                                                                        child: Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: [
                                                                                                            Padding(
                                                                                                              padding: EdgeInsets.symmetric(
                                                                                                                horizontal: 5,
                                                                                                                vertical: 3,
                                                                                                              ),
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  languageController.alllanguageData.value.languageData!["SHARE"].toString(),
                                                                                                                  style: TextStyle(
                                                                                                                    color: Colors.white,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                flex: 1,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      height: 40,
                                                                                                      width: 50,
                                                                                                      decoration: BoxDecoration(
                                                                                                        shape: BoxShape.circle,
                                                                                                        image: DecorationImage(
                                                                                                          fit: BoxFit.fill,
                                                                                                          image: AssetImage(
                                                                                                            "assets/icons/logo.png",
                                                                                                          ),
                                                                                                        ),
                                                                                                        // color: Colors.red,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                flex: 1,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                                  children: [
                                                                                                    GestureDetector(
                                                                                                      onTap: () {
                                                                                                        Navigator.pop(context);
                                                                                                      },
                                                                                                      child: Icon(
                                                                                                        Icons.close,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 15,
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              convertToLocalTime(
                                                                                                data.createdAt.toString(),
                                                                                              ),
                                                                                              // Text(
                                                                                              //   DateFormat('dd MMM yyyy')
                                                                                              //       .format(
                                                                                              //     DateTime
                                                                                              //         .parse(
                                                                                              //       data.createdAt.toString(),
                                                                                              //     ),
                                                                                              //   ),
                                                                                              //   style:
                                                                                              //       TextStyle(
                                                                                              //     color:
                                                                                              //         Colors.grey,
                                                                                              //     fontSize:
                                                                                              //         12,
                                                                                              //   ),
                                                                                              // ),
                                                                                              // SizedBox(
                                                                                              //   width:
                                                                                              //       15,
                                                                                              // ),
                                                                                              // Text(
                                                                                              //   DateFormat('hh:mm a')
                                                                                              //       .format(
                                                                                              //     DateTime
                                                                                              //         .parse(
                                                                                              //       data.createdAt.toString(),
                                                                                              //     ),
                                                                                              //   ),
                                                                                              //   style:
                                                                                              //       TextStyle(
                                                                                              //     color:
                                                                                              //         Colors.grey,
                                                                                              //     fontSize:
                                                                                              //         12,
                                                                                              //   ),
                                                                                              // ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 25,
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.symmetric(
                                                                                              horizontal: 0,
                                                                                            ),
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      languageController.alllanguageData.value.languageData!["ORDER_STATUS"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.green,
                                                                                                        fontSize: 17,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      data.status.toString() == "0"
                                                                                                          ? languageController.alllanguageData.value.languageData!["PENDING"].toString()
                                                                                                          : data.status.toString() == "1"
                                                                                                              ? languageController.alllanguageData.value.languageData!["CONFIRMED"].toString()
                                                                                                              : languageController.alllanguageData.value.languageData!["REJECTED"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 17,
                                                                                                        fontWeight: FontWeight.w400,
                                                                                                        color: data.status.toString() == "0"
                                                                                                            ? Colors.grey
                                                                                                            : data.status.toString() == "1"
                                                                                                                ? Colors.green
                                                                                                                : Colors.red,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                Visibility(
                                                                                                  visible: data.status.toString() == "2",
                                                                                                  child: Text(
                                                                                                    data.rejectReason.toString(),
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.red,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 3,
                                                                                                ),
                                                                                                dotline(),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      languageController.alllanguageData.value.languageData!["NETWORK_TYPE"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      data.bundle!.service!.company!.companyName.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      languageController.alllanguageData.value.languageData!["BUNDLE_TYPE"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      data.bundle!.bundleTitle!.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      languageController.alllanguageData.value.languageData!["PHONE_NUMBER"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      data.rechargebleAccount!.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      languageController.alllanguageData.value.languageData!["VALIDITY_TYPE"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      data.bundle!.validityType!.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      languageController.alllanguageData.value.languageData!["ORDER_ID"].toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      data.id!.toString(),
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        color: AppColors.borderColor,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                                dotline(),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 30,
                                                                                          ),
                                                                                          // GestureDetector(
                                                                                          //   onTap: () {
                                                                                          //     _capturePng();
                                                                                          //   },
                                                                                          //   child: Container(
                                                                                          //     height: 35,
                                                                                          //     width: 100,
                                                                                          //     decoration:
                                                                                          //         BoxDecoration(
                                                                                          //       color:
                                                                                          //           Colors.blue,
                                                                                          //       borderRadius:
                                                                                          //           BorderRadius
                                                                                          //               .circular(
                                                                                          //                   8),
                                                                                          //     ),
                                                                                          //     child: Center(
                                                                                          //       child: Text(
                                                                                          //         "Save PNG",
                                                                                          //         style:
                                                                                          //             TextStyle(
                                                                                          //           color: Colors
                                                                                          //               .white,
                                                                                          //           fontWeight:
                                                                                          //               FontWeight
                                                                                          //                   .w500,
                                                                                          //         ),
                                                                                          //       ),
                                                                                          //     ),
                                                                                          //   ),
                                                                                          // ),

                                                                                          // Row(
                                                                                          //   mainAxisAlignment:
                                                                                          //       MainAxisAlignment
                                                                                          //           .end,
                                                                                          //   children: [
                                                                                          //     GestureDetector(
                                                                                          //       onTap: () {
                                                                                          //         _capturePng();
                                                                                          //       },
                                                                                          //       child: Icon(
                                                                                          //         FontAwesomeIcons
                                                                                          //             .fileArrowDown,
                                                                                          //         color: Colors
                                                                                          //             .grey,
                                                                                          //       ),
                                                                                          //     ),
                                                                                          //   ],
                                                                                          // ),
                                                                                          SizedBox(
                                                                                            height: 10,
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              Container(
                                                                                                height: 55,
                                                                                                width: 140,
                                                                                                child: Column(
                                                                                                  children: [
                                                                                                    Divider(
                                                                                                      thickness: 1,
                                                                                                      color: Colors.black,
                                                                                                    ),
                                                                                                    Container(
                                                                                                      child: Text(
                                                                                                        dashboardController.alldashboardData.value.data!.userInfo!.contactName.toString(),
                                                                                                        style: GoogleFonts.josefinSans(
                                                                                                          color: Colors.black,
                                                                                                          fontSize: 13,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Divider(
                                                                                                      thickness: 1,
                                                                                                      color: Colors.black,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                              child: Container(
                                                                height: 60,
                                                                width:
                                                                    screenWidth,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  // border: Border.all(
                                                                  //   width: 1,
                                                                  //   color: Colors.grey,
                                                                  // ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: AppColors
                                                                      .listbuilderboxColor,
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            40,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            image:
                                                                                NetworkImage(
                                                                              data.bundle!.service!.company!.companyLogo.toString(),
                                                                            ),
                                                                          ),
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 5),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Flexible(
                                                                                child: Text(
                                                                                  data.bundle!.bundleTitle.toString(),
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: 14,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                data.rechargebleAccount.toString(),
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 12,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              NumberFormat.currency(
                                                                                locale: 'en_US',
                                                                                symbol: '',
                                                                                decimalDigits: 2,
                                                                              ).format(
                                                                                double.parse(
                                                                                  data.bundle!.sellingPrice.toString(),
                                                                                ),
                                                                              ),
                                                                              style: TextStyle(
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 2,
                                                                            ),
                                                                            Text(
                                                                              " " + box.read("currency_code"),
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 11,
                                                                                color: Colors.grey,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              // Icon(
                                                                              //   Icons.check,
                                                                              //   color: Colors.green,
                                                                              //   size: 14,
                                                                              // ),
                                                                              Text(
                                                                                data.status.toString() == "0"
                                                                                    ? languageController.alllanguageData.value.languageData!["PENDING"].toString()
                                                                                    : data.status.toString() == "1"
                                                                                        ? languageController.alllanguageData.value.languageData!["CONFIRMED"].toString()
                                                                                        : languageController.alllanguageData.value.languageData!["REJECTED"].toString(),
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  color: Colors.black,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                              // Text(
                                                                              //   "2 days ago",
                                                                              //   style: TextStyle(
                                                                              //     color: Colors.green,
                                                                              //     fontSize: 10,
                                                                              //     fontWeight:
                                                                              //         FontWeight.w600,
                                                                              //   ),
                                                                              // ),
                                                                            ],
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
                                    () => historyController.isLoading.value ==
                                            true
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Loading....."),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Center(
                                                child:
                                                    CircularProgressIndicator(
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
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      ),
              )),
        ),
        drawer: DrawerWidget());
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Color of the shadow
            spreadRadius: 4, // How much the shadow spreads
            blurRadius: 5, // The blur radius of the shadow
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
