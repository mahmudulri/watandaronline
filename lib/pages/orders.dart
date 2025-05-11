import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:watandaronline/controllers/dashboard_controller.dart';
import 'package:watandaronline/controllers/history_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/order_list_controller.dart';
import 'package:watandaronline/controllers/time_zone_controller.dart';
import 'package:watandaronline/screens/order_details_screen.dart';

import 'package:watandaronline/utils/colors.dart';
import 'package:watandaronline/widgets/default_button.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

import '../screens/neworderdetails_screen.dart';

class OrderPage extends StatefulWidget {
  OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final languageController = Get.find<LanguageController>();
  final dashboardController = Get.find<DashboardController>();
  final orderlistController = Get.find<OrderlistController>();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // orderlistController.fetchOrderlistdata();
    orderlistController.initialpage = 1;
    // orderlistController.fetchOrderlistdata();

    super.initState();

    scrollController.addListener(refresh);
  }

  final box = GetStorage();

  bool isvisible = false;

  List orderStatus = [
    {
      "title": "Pending",
      "value": "order_status=0",
    },
    {
      "title": "Confirmed",
      "value": "order_status=1",
    },
    {
      "title": "Rejected",
      "value": "order_status=2",
    },
  ];
  String defaultValue = "";
  String secondDropDown = "";

  // String selectedStatus = "Select Status";

  TextEditingController searchController = TextEditingController();

  String search = "";

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

  Future<void> refresh() async {
    if (orderlistController.finalList.length >=
        (orderlistController
                .allorderlist.value.payload?.pagination.totalItems ??
            0)) {
      print(
          "End..........................................End.....................");
    } else {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        orderlistController.initialpage++;
        // print(orderlistController.initialpage);
        print("Load More...................");
        orderlistController.fetchOrderlistdata();
      } else {
        // print("nothing");
      }
    }
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

  final TimeZoneController timeZoneController = Get.put(TimeZoneController());

  Text convertToLocalTime(
    String utcTimeString,
  ) {
    String localTimeString;
    try {
      // Parse the UTC time
      DateTime utcTime = DateTime.parse(utcTimeString);

      // Calculate the offset duration
      Duration offset = Duration(
        hours: int.parse(timeZoneController.hour),
        minutes: int.parse(timeZoneController.minute),
      );

      // Apply the offset (subtracting for negative)

      if (timeZoneController.sign == "+") {
        DateTime localTime = utcTime.add(offset);
        String formattedTime =
            DateFormat('yyyy-MM-dd hh:mm:ss a', 'en_US').format(localTime);
        localTimeString = '$formattedTime';
      } else {
        DateTime localTime = utcTime.subtract(offset);
        String formattedTime =
            DateFormat('yyyy-MM-dd hh:mm:ss a', 'en_US').format(localTime);

        localTimeString = '$formattedTime';
      }
    } catch (e) {
      localTimeString = '';
    }
    return Text(
      localTimeString,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // orderlistController.fetchOrderlistdata();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColors.backgroundColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              // print(orderlistController.initialpage);
              // print(orderlistController.finalList.length);
              // Get.to(() => OrderSuccessScreen());
            },
            child: Text(
              languageController.alllanguageData.value.languageData!["ORDERS"]
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
          height: screenHeight,
          width: screenWidth,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: TextField(
                                  onChanged: (String? value) {
                                    setState(() {
                                      search = value.toString();
                                    });
                                  },
                                  controller: searchController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: languageController
                                        .alllanguageData
                                        .value
                                        .languageData!["ENTER_YOUR_NUMBER"]
                                        .toString(),
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Icon(
                            //   Icons.search,
                            //   color: Colors.grey,
                            //   size: 30,
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isvisible = !isvisible;
                          print(isvisible);
                        });
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          // color: Color(0xff46558A),
                          color: AppColors.defaultColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Text(
                                languageController.alllanguageData.value
                                    .languageData!["FILTER"]
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                FontAwesomeIcons.filter,
                                color: Colors.white,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0,
                ),
                Visibility(
                  visible: isvisible,
                  child: Container(
                    height: 120,
                    width: screenWidth,
                    decoration: BoxDecoration(
                        // border: Border.all(
                        //     width: 1,
                        //     color: Colors.grey), // color: Colors.black12,
                        ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    languageController.alllanguageData.value
                                        .languageData!["ORDER_STATUS"]
                                        .toString(),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                            isDense: true,
                                            value: defaultValue,
                                            isExpanded: true,
                                            items: [
                                              DropdownMenuItem(
                                                value: "",
                                                child: Text(
                                                  languageController
                                                      .alllanguageData
                                                      .value
                                                      .languageData![
                                                          "SELECT_STATUS"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              ...orderStatus.map<
                                                      DropdownMenuItem<String>>(
                                                  (data) {
                                                return DropdownMenuItem(
                                                  value: data['value'],
                                                  child: Text(
                                                    data['title'],
                                                  ),
                                                );
                                              }).toList(),
                                            ],
                                            onChanged: (value) {
                                              box.write("orderstatus", value);
                                              // print(
                                              //     "selected Value $value");
                                              setState(() {
                                                defaultValue = value!;
                                              });
                                            }),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    languageController.alllanguageData.value
                                        .languageData!["SELECTED_DATE"]
                                        .toString(),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              languageController
                                                  .alllanguageData
                                                  .value
                                                  .languageData![
                                                      "SELECTED_DATE"]
                                                  .toString(),
                                            ),
                                          ),
                                          Icon(Icons.arrow_downward),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    orderlistController.initialpage = 1;
                                    orderlistController.finalList.clear();
                                    orderlistController.fetchOrderlistdata();
                                    print(box.read("orderstatus"));
                                  },
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: AppColors.defaultColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      child: Center(
                                        child: Text(
                                          languageController
                                              .alllanguageData
                                              .value
                                              .languageData!["APPLY_FILTER"]
                                              .toString(),
                                          style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    box.write("orderstatus", "");

                                    orderlistController.initialpage = 1;
                                    orderlistController.finalList.clear();

                                    orderlistController.fetchOrderlistdata();

                                    defaultValue = "";
                                    setState(() {
                                      isvisible = !isvisible;
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: AppColors.defaultColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      child: Center(
                                        child: Text(
                                          languageController
                                              .alllanguageData
                                              .value
                                              .languageData!["CLEAR_FILTER"]
                                              .toString(),
                                          style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Obx(
                  () => orderlistController.isLoading.value == false
                      ? Container(
                          child: orderlistController
                                  .allorderlist.value.data!.orders.isNotEmpty
                              ? SizedBox()
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                  child: Obx(
                    () =>
                        orderlistController.isLoading.value == false &&
                                languageController.isLoading.value == false &&
                                orderlistController.finalList.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.builder(
                                  shrinkWrap: false,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  itemCount:
                                      orderlistController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        orderlistController.finalList[index];

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderSuccessScreen(
                                              createDate:
                                                  data.createdAt.toString(),
                                              status: data.status.toString(),
                                              rejectReason:
                                                  data.rejectReason.toString(),
                                              companyName: data.bundle!.service!
                                                  .company!.companyName
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
                                              buyingPrice: data
                                                  .bundle!.buyingPrice
                                                  .toString(),
                                              orderID: data.id!.toString(),
                                              resellerName: dashboardController
                                                  .alldashboardData
                                                  .value
                                                  .data!
                                                  .userInfo!
                                                  .contactName
                                                  .toString(),
                                              resellerPhone: dashboardController
                                                  .alldashboardData
                                                  .value
                                                  .data!
                                                  .userInfo!
                                                  .phone
                                                  .toString(),
                                              companyLogo: data.bundle!.service!
                                                  .company!.companyLogo
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        child: Container(
                                          height: 218,
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: AppColors.defaultColor,
                                            ),
                                            // color: Colors.grey,
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.defaultColor,
                                                    // borderRadius: BorderRadius.only(
                                                    //   topLeft: Radius.circular(8),
                                                    //   topRight: Radius.circular(8),
                                                    // ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              DateFormat(
                                                                      'dd MMM yyyy')
                                                                  .format(DateTime
                                                                      .parse(data
                                                                          .createdAt
                                                                          .toString())),
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          languageController
                                                                  .alllanguageData
                                                                  .value
                                                                  .languageData![
                                                                      "ORDER_ID"]
                                                                  .toString() +
                                                              " ",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          "#${data.id} ",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              languageController
                                                                  .alllanguageData
                                                                  .value
                                                                  .languageData![
                                                                      "RECHARGEABLE_ACCOUNT"]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            // Icon(
                                                            //   Icons.check,
                                                            //   color: Colors.green,
                                                            // ),
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
                                                            SizedBox(
                                                              width:
                                                                  250, // Define fixed width
                                                              child: Text(
                                                                data.rechargebleAccount
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        Container(
                                                          height: 52,
                                                          width: screenWidth,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        languageController
                                                                            .alllanguageData
                                                                            .value
                                                                            .languageData!["TITLE"]
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        data.bundle!
                                                                            .bundleTitle
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.grey,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        languageController
                                                                            .alllanguageData
                                                                            .value
                                                                            .languageData!["SALE"]
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            box.read("currency_code"),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
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
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        languageController
                                                                            .alllanguageData
                                                                            .value
                                                                            .languageData!["BUY"]
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            box.read("currency_code"),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            NumberFormat.currency(
                                                                              locale: 'en_US',
                                                                              symbol: '',
                                                                              decimalDigits: 2,
                                                                            ).format(
                                                                              double.parse(
                                                                                data.bundle!.buyingPrice.toString(),
                                                                              ),
                                                                            ),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              data.bundle!
                                                                  .validityType
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                  },
                                ),
                              )
                            : orderlistController.finalList.isEmpty
                                ? SizedBox()
                                : RefreshIndicator(
                                    onRefresh: refresh,
                                    child: ListView.builder(
                                      shrinkWrap: false,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      controller: scrollController,
                                      itemCount:
                                          orderlistController.finalList.length,
                                      itemBuilder: (context, index) {
                                        final data = orderlistController
                                            .finalList[index];

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderSuccessScreen(
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
                                          child: Card(
                                            child: Container(
                                              height: 218,
                                              width: screenWidth,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: AppColors.defaultColor,
                                                ),
                                                // color: Colors.grey,
                                              ),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .defaultColor,
                                                        // borderRadius: BorderRadius.only(
                                                        //   topLeft: Radius.circular(8),
                                                        //   topRight: Radius.circular(8),
                                                        // ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 15),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                  DateFormat(
                                                                          'dd MMM yyyy')
                                                                      .format(DateTime.parse(data
                                                                          .createdAt
                                                                          .toString())),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              languageController
                                                                      .alllanguageData
                                                                      .value
                                                                      .languageData![
                                                                          "ORDER_ID"]
                                                                      .toString() +
                                                                  " ",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Text(
                                                              "#${data.id} ",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 15),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  languageController
                                                                      .alllanguageData
                                                                      .value
                                                                      .languageData![
                                                                          "RECHARGEABLE_ACCOUNT"]
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                // Icon(
                                                                //   Icons.check,
                                                                //   color: Colors.green,
                                                                // ),
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
                                                                    fontSize:
                                                                        12,
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
                                                                SizedBox(
                                                                  width:
                                                                      250, // Define fixed width
                                                                  child: Text(
                                                                    data.rechargebleAccount
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            Container(
                                                              height: 52,
                                                              width:
                                                                  screenWidth,
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            languageController.alllanguageData.value.languageData!["TITLE"].toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 11,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            data.bundle!.bundleTitle.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 11,
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            languageController.alllanguageData.value.languageData!["SALE"].toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                box.read("currency_code"),
                                                                                style: TextStyle(
                                                                                  fontSize: 10,
                                                                                  color: Colors.grey,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
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
                                                                                  fontSize: 10,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            languageController.alllanguageData.value.languageData!["BUY"].toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                box.read("currency_code"),
                                                                                style: TextStyle(
                                                                                  fontSize: 10,
                                                                                  color: Colors.grey,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                NumberFormat.currency(
                                                                                  locale: 'en_US',
                                                                                  symbol: '',
                                                                                  decimalDigits: 2,
                                                                                ).format(
                                                                                  double.parse(
                                                                                    data.bundle!.buyingPrice.toString(),
                                                                                  ),
                                                                                ),
                                                                                style: TextStyle(
                                                                                  fontSize: 10,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  data.bundle!
                                                                      .validityType
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                      },
                                    ),
                                  ),
                  ),
                ),
                Obx(
                  () => orderlistController.isLoading.value == true
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
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}

class dotline extends StatelessWidget {
  const dotline({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DottedLine(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: Colors.black,
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.white,
      dashGapRadius: 0.0,
    );
  }
}

class MyContainerList extends StatefulWidget {
  final int itemCount;

  MyContainerList({required this.itemCount});

  @override
  _MyContainerListState createState() => _MyContainerListState();
}

class _MyContainerListState extends State<MyContainerList> {
  int selectedIndex = 0;
  final box = GetStorage();
  final OrderlistController orderlistController =
      Get.put(OrderlistController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 40,
      width: screenWidth,
      decoration: BoxDecoration(
          // color: Colors.red,
          ),
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            int myindex = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  box.write("pageNo", "${myindex}");
                  print(box.read("pageNo"));
                  orderlistController.fetchOrderlistdata();
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 5),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: selectedIndex == index ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    myindex.toString(),
                    style: TextStyle(
                      color:
                          selectedIndex == index ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
