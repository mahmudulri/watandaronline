import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:watantelecom/controllers/language_controller.dart';
import 'package:watantelecom/controllers/order_list_controller.dart';
import 'package:watantelecom/screens/order_details.dart';
import 'package:watantelecom/utils/colors.dart';
import 'package:watantelecom/widgets/default_button.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final OrderlistController orderlistController =
      Get.put(OrderlistController());

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
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

  final LanguageController languageController = Get.put(LanguageController());

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
              print(orderlistController.initialpage);
              print(orderlistController.finalList.length);
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
                        height: 45,
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
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
                Expanded(
                  child: Obx(() => orderlistController.isLoading.value == false
                      ? RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.builder(
                            shrinkWrap: false,
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            itemCount: orderlistController.finalList.length,
                            itemBuilder: (context, index) {
                              final data = orderlistController.finalList[index];

                              if (searchController.text.isEmpty) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            insetPadding: EdgeInsets.all(0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              height: screenHeight,
                                              width: screenWidth,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 25,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    RepaintBoundary(
                                                      key: _globalKey,
                                                      child: Container(
                                                        height: 420,
                                                        width: screenWidth,
                                                        decoration:
                                                            BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.2), // shadow color
                                                              spreadRadius:
                                                                  4, // spread radius
                                                              blurRadius:
                                                                  4, // blur radius
                                                              offset: Offset(0,
                                                                  3), // changes position of shadow
                                                            ),
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.2), // shadow color
                                                              spreadRadius:
                                                                  4, // spread radius
                                                              blurRadius:
                                                                  4, // blur radius
                                                              offset: Offset(3,
                                                                  0), // changes position of shadow
                                                            ),
                                                          ],
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 10),
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
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            // _capturePng();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                90,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child:
                                                                                Row(
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
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              40,
                                                                          width:
                                                                              50,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            // shape:
                                                                            //     BoxShape.circle,
                                                                            image:
                                                                                DecorationImage(
                                                                              fit: BoxFit.fill,
                                                                              image: NetworkImage(
                                                                                data.bundle!.service!.company!.companyLogo.toString(),
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
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Icon(
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
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    DateFormat(
                                                                            'dd MMM yyyy')
                                                                        .format(
                                                                      DateTime
                                                                          .parse(
                                                                        data.createdAt
                                                                            .toString(),
                                                                      ),
                                                                    ),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Text(
                                                                    DateFormat(
                                                                            'hh:mm a')
                                                                        .format(
                                                                      DateTime
                                                                          .parse(
                                                                        data.createdAt
                                                                            .toString(),
                                                                      ),
                                                                    ),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 25,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal: 0,
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          languageController
                                                                              .alllanguageData
                                                                              .value
                                                                              .languageData!["ORDER_STATUS"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                            fontSize:
                                                                                17,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data.status.toString() == "0"
                                                                              ? languageController.alllanguageData.value.languageData!["PENDING"].toString()
                                                                              : data.status.toString() == "1"
                                                                                  ? languageController.alllanguageData.value.languageData!["CONFIRMED"].toString()
                                                                                  : languageController.alllanguageData.value.languageData!["REJECTED"].toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    dotline(),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          languageController
                                                                              .alllanguageData
                                                                              .value
                                                                              .languageData!["NETWORK_TYPE"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data
                                                                              .bundle!
                                                                              .service!
                                                                              .company!
                                                                              .companyName
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          languageController
                                                                              .alllanguageData
                                                                              .value
                                                                              .languageData!["BUNDLE_TYPE"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data.bundle!
                                                                              .bundleTitle!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          languageController
                                                                              .alllanguageData
                                                                              .value
                                                                              .languageData!["PRICE"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data.bundle!.sellingPrice.toString() +
                                                                              " " +
                                                                              box.read("currency_code"),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          languageController
                                                                              .alllanguageData
                                                                              .value
                                                                              .languageData!["PHONE_NUMBER"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data.rechargebleAccount!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          languageController
                                                                              .alllanguageData
                                                                              .value
                                                                              .languageData!["VALIDITY_TYPE"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data.bundle!
                                                                              .validityType!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          languageController
                                                                              .alllanguageData
                                                                              .value
                                                                              .languageData!["ORDER_ID"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data.id!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
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

                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      _capturePng();
                                                                    },
                                                                    child: Icon(
                                                                      FontAwesomeIcons
                                                                          .fileArrowDown,
                                                                      color: Colors
                                                                          .grey,
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
                                  child: Card(
                                    child: Container(
                                      height: 200,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                          // color: Colors.grey,
                                          ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .listbuilderboxColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
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
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      "#${data.id} ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey,
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
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          data.rechargebleAccount
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                            child: Container(
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
                                                                        .languageData![
                                                                            "TITLE"]
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
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
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    languageController
                                                                        .alllanguageData
                                                                        .value
                                                                        .languageData![
                                                                            "SALE"]
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    box.read(
                                                                            "currency_code") +
                                                                        " " +
                                                                        data.bundle!
                                                                            .sellingPrice
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
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
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    box.read(
                                                                            "currency_code") +
                                                                        " " +
                                                                        data.bundle!
                                                                            .buyingPrice
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
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
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                              } else if (orderlistController.allorderlist.value
                                  .data!.orders[index].rechargebleAccount
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchController.text
                                      .toString()
                                      .toLowerCase())) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetailsScreen(
                                          status: data.status,
                                          orderID: data.id.toString(),
                                          date: DateFormat('dd MMM yyyy')
                                              .format(DateTime.parse(
                                                  data.createdAt.toString())),
                                          number: data.rechargebleAccount,
                                          company: data.bundle!.service!
                                              .company!.companyName,
                                          validity: data.bundle!.validityType,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    child: Container(
                                      height: 200,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                          // color: Colors.grey,
                                          ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .listbuilderboxColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
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
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "Order ID: ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      "#${data.id} ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey,
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
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Rechargeable Account",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                              ? "pending"
                                                              : data.status
                                                                          .toString() ==
                                                                      "1"
                                                                  ? "confirmed"
                                                                  : "rejected",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          data.rechargebleAccount
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Title",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
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
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Sale",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    data.bundle!.currency!
                                                                            .symbol
                                                                            .toString() +
                                                                        data.bundle!
                                                                            .sellingPrice
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Buy",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    data.bundle!.currency!
                                                                            .symbol
                                                                            .toString() +
                                                                        data.bundle!
                                                                            .buyingPrice
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
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
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                              } else {
                                return Container();
                              }
                            },
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.builder(
                            shrinkWrap: false,
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            // itemCount: orderlistController
                            //     .allorderlist.value.data!.orders.length,
                            itemCount: orderlistController.finalList.length,
                            itemBuilder: (context, index) {
                              // final data = orderlistController
                              //     .allorderlist.value.data!.orders[index];
                              final data = orderlistController.finalList[index];

                              if (searchController.text.isEmpty) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            insetPadding: EdgeInsets.all(0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              height: screenHeight,
                                              width: screenWidth,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 25,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    RepaintBoundary(
                                                      key: _globalKey,
                                                      child: Container(
                                                        height: 400,
                                                        width: screenWidth,
                                                        decoration:
                                                            BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.2), // shadow color
                                                              spreadRadius:
                                                                  4, // spread radius
                                                              blurRadius:
                                                                  4, // blur radius
                                                              offset: Offset(0,
                                                                  3), // changes position of shadow
                                                            ),
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.2), // shadow color
                                                              spreadRadius:
                                                                  4, // spread radius
                                                              blurRadius:
                                                                  4, // blur radius
                                                              offset: Offset(3,
                                                                  0), // changes position of shadow
                                                            ),
                                                          ],
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 10),
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
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            // _capturePng();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                70,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.symmetric(
                                                                                    horizontal: 5,
                                                                                    vertical: 3,
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "Share",
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
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              40,
                                                                          width:
                                                                              50,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            // shape:
                                                                            //     BoxShape.circle,
                                                                            image:
                                                                                DecorationImage(
                                                                              fit: BoxFit.fill,
                                                                              image: NetworkImage(
                                                                                data.bundle!.service!.company!.companyLogo.toString(),
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
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Icon(
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
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    DateFormat(
                                                                            'dd MMM yyyy')
                                                                        .format(
                                                                      DateTime
                                                                          .parse(
                                                                        data.createdAt
                                                                            .toString(),
                                                                      ),
                                                                    ),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Text(
                                                                    DateFormat(
                                                                            'hh:mm a')
                                                                        .format(
                                                                      DateTime
                                                                          .parse(
                                                                        data.createdAt
                                                                            .toString(),
                                                                      ),
                                                                    ),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 25,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal: 0,
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Status : ",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                            fontSize:
                                                                                17,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data.status == "0"
                                                                              ? "Pending"
                                                                              : data.status == "1"
                                                                                  ? "Confirmed"
                                                                                  : "Rejected",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    dotline(),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Network type : ",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data
                                                                              .bundle!
                                                                              .service!
                                                                              .company!
                                                                              .companyName
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Bundle type : ",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data.bundle!
                                                                              .bundleTitle!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Price : ",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data.bundle!.sellingPrice.toString() +
                                                                              " " +
                                                                              box.read("currency_code"),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Phone no : ",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data.rechargebleAccount!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Valitidy type : ",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data.bundle!
                                                                              .validityType!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Order ID : ",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          data.id!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.borderColor,
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

                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      _capturePng();
                                                                    },
                                                                    child: Icon(
                                                                      FontAwesomeIcons
                                                                          .fileArrowDown,
                                                                      color: Colors
                                                                          .grey,
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

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => OrderDetailsScreen(
                                    //       status: data.status,
                                    //       orderID: data.id.toString(),
                                    //       date: DateFormat('dd MMM yyyy').format(
                                    //           DateTime.parse(
                                    //               data.createdAt.toString())),
                                    //       number: data.rechargebleAccount,
                                    //       company: data.bundle!.service!.company!
                                    //           .companyName,
                                    //       validity: data.bundle!.validityType,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Card(
                                    child: Container(
                                      height: 200,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                          // color: Colors.grey,
                                          ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .listbuilderboxColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
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
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "Order ID: ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      "#${data.id} ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey,
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
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Rechargeable Account",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                              ? "pending"
                                                              : data.status
                                                                          .toString() ==
                                                                      "1"
                                                                  ? "confirmed"
                                                                  : "rejected",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          data.rechargebleAccount
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Title",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
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
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Sale",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    box.read(
                                                                            "currency_code") +
                                                                        " " +
                                                                        data.bundle!
                                                                            .sellingPrice
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Buy",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    box.read(
                                                                            "currency_code") +
                                                                        " " +
                                                                        data.bundle!
                                                                            .buyingPrice
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
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
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                              } else if (orderlistController.allorderlist.value
                                  .data!.orders[index].rechargebleAccount
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchController.text
                                      .toString()
                                      .toLowerCase())) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetailsScreen(
                                          status: data.status,
                                          orderID: data.id.toString(),
                                          date: DateFormat('dd MMM yyyy')
                                              .format(DateTime.parse(
                                                  data.createdAt.toString())),
                                          number: data.rechargebleAccount,
                                          company: data.bundle!.service!
                                              .company!.companyName,
                                          validity: data.bundle!.validityType,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    child: Container(
                                      height: 200,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                          // color: Colors.grey,
                                          ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .listbuilderboxColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
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
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "Order ID: ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      "#${data.id} ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey,
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
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Rechargeable Account",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                              ? "pending"
                                                              : data.status
                                                                          .toString() ==
                                                                      "1"
                                                                  ? "confirmed"
                                                                  : "rejected",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          data.rechargebleAccount
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Title",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
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
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Sale",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    data.bundle!.currency!
                                                                            .symbol
                                                                            .toString() +
                                                                        data.bundle!
                                                                            .sellingPrice
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Buy",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    data.bundle!.currency!
                                                                            .symbol
                                                                            .toString() +
                                                                        data.bundle!
                                                                            .buyingPrice
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
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
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                              } else {
                                return Container();
                              }
                            },
                          ),
                        )),
                ),

                Obx(
                  () => orderlistController.isLoading.value == true
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
                SizedBox(
                  height: 20,
                ),
                // MyContainerList(
                //   itemCount: int.parse(
                //     orderlistController
                //         .allorderlist.value.payload!.pagination.totalPages
                //         .toString(),
                //   ),
                // ),
                // SizedBox(
                //   height: 25,
                // ),
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
