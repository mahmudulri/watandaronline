import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:ui' as ui;

import 'package:watandaronline/controllers/dashboard_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/time_zone_controller.dart';
import 'package:watandaronline/helpers/capture_image_helper.dart';
import 'package:watandaronline/helpers/language_helper.dart';
import 'package:watandaronline/helpers/localtime_helper.dart';
import 'package:watandaronline/helpers/share_image_helper.dart';
import 'package:watandaronline/pages/orders.dart';
import 'package:watandaronline/utils/colors.dart';

class CustomOrderDetails extends StatefulWidget {
  CustomOrderDetails({
    super.key,
    this.createDate,
    this.status,
    this.rejectReason,
    this.companyName,
    this.bundleTitle,
    this.rechargebleAccount,
    this.validityType,
    this.sellingPrice,
    this.buyingPrice,
    this.orderID,
    this.resellerName,
    this.resellerPhone,
    this.companyLogo,
    this.amount,
  });
  String? createDate;
  String? status;
  String? rejectReason;
  String? companyName;
  String? bundleTitle;
  String? rechargebleAccount;
  String? validityType;
  String? sellingPrice;
  String? buyingPrice;
  String? orderID;
  String? resellerName;
  String? resellerPhone;
  String? companyLogo;
  String? amount;

  @override
  State<CustomOrderDetails> createState() => _CustomOrderDetailsState();
}

class _CustomOrderDetailsState extends State<CustomOrderDetails> {
  final DashboardController dashboardController =
      Get.put(DashboardController());

  final TimeZoneController timeZoneController = Get.put(TimeZoneController());

  final LanguageController languageController = Get.put(LanguageController());

  final box = GetStorage();

  // final GlobalKey _shareKey = GlobalKey();

  bool showSelling = true;
  bool showBuying = false;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            RepaintBoundary(
              key: catpureKey,
              child: RepaintBoundary(
                key: shareKey,
                child: Container(
                  height: 450,
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
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            child: Image.asset(
                                              widget.status.toString() == "0"
                                                  ? "assets/icons/pending.png"
                                                  : widget.status.toString() ==
                                                          "1"
                                                      ? "assets/icons/success.png"
                                                      : "assets/icons/reject.png",
                                              height: 40,
                                            ),
                                          ),
                                          // Container(
                                          //   height: 55,
                                          //   width: 55,
                                          //   decoration: BoxDecoration(
                                          //     // border: Border.all(
                                          //     //   width: 2,
                                          //     //   color: Colors.black.withOpacity(0.2),
                                          //     // ),
                                          //     shape: BoxShape.circle,
                                          //     image: DecorationImage(
                                          //       fit: BoxFit.fill,
                                          //       image: AssetImage(
                                          //         "assets/icons/logo.png",
                                          //       ),
                                          //     ),
                                          //     // color: Colors.red,
                                          //   ),
                                          // ),
                                          Text(
                                            widget.status.toString() == "0"
                                                ? getText("PENDING",
                                                    defaultValue: "Pending")
                                                : widget.status.toString() ==
                                                        "1"
                                                    ? getText("SUCCESS",
                                                        defaultValue: "Success")
                                                    : getText("FAIL",
                                                        defaultValue:
                                                            "Rejected"),
                                            style: GoogleFonts.aBeeZee(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     Navigator.pop(context);
                                      //   },
                                      //   child: Icon(
                                      //     Icons.close,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     convertToLocalTime(
                            //       widget.createDate.toString(),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    opacity: 0.2,
                                    image: AssetImage(
                                      "assets/icons/logo.png",
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(
                                    //       languageController.alllanguageData.value
                                    //           .languageData!["ORDER_STATUS"]
                                    //           .toString(),
                                    //       style: TextStyle(
                                    //         color: Colors.green,
                                    //         fontSize: 17,
                                    //       ),
                                    //     ),
                                    //     Text(
                                    //       widget.status.toString() == "0"
                                    //           ? languageController.alllanguageData
                                    //               .value.languageData!["PENDING"]
                                    //               .toString()
                                    //           : widget.status.toString() == "1"
                                    //               ? languageController
                                    //                   .alllanguageData
                                    //                   .value
                                    //                   .languageData!["CONFIRMED"]
                                    //                   .toString()
                                    //               : languageController.alllanguageData
                                    //                   .value.languageData!["REJECTED"]
                                    //                   .toString(),
                                    //       style: TextStyle(
                                    //         fontSize: 17,
                                    //         fontWeight: FontWeight.w400,
                                    //         color: widget.status.toString() == "0"
                                    //             ? Colors.grey
                                    //             : widget.status.toString() == "1"
                                    //                 ? Colors.green
                                    //                 : Colors.red,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    Visibility(
                                      visible: widget.status.toString() == "2",
                                      child: Text(
                                        widget.rejectReason.toString(),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languageController
                                              .alllanguageData
                                              .value
                                              .languageData!["NETWORK_TYPE"]
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          widget.companyName.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),

                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languageController
                                              .alllanguageData
                                              .value
                                              .languageData!["PHONE_NUMBER"]
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          widget.rechargebleAccount.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),

                                    // SizedBox(
                                    //   height: 5,
                                    // ),

                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 0,
                                      ),
                                      child: Visibility(
                                        visible: showBuying,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              getText("BUYING_PRICE",
                                                  defaultValue: "Buying Price"),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  box.read("currency_code"),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  widget.buyingPrice.toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 0,
                                      ),
                                      child: Visibility(
                                        visible: showSelling,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              getText("SELLING_PRICE",
                                                  defaultValue:
                                                      "Selling Price"),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  box.read("currency_code"),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  widget.sellingPrice
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                // Text(
                                                //   NumberFormat.currency(
                                                //     locale: 'en_US',
                                                //     symbol: '',
                                                //     decimalDigits: 2,
                                                //   ).format(
                                                //     double.parse(
                                                //       widget.sellingPrice
                                                //           .toString(),
                                                //     ),
                                                //   ),
                                                //   style: TextStyle(
                                                //     color: Colors.black,
                                                //     fontSize: 14,
                                                //     fontWeight: FontWeight.w600,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getText("AMOUNT",
                                              defaultValue: "Amount"),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          widget.amount.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languageController.alllanguageData
                                              .value.languageData!["ORDER_ID"]
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "WT#- " + widget.orderID.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // dotline(),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            ),
                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       widget.resellerName.toString(),
                            //       style: GoogleFonts.oswald(
                            //         color: Colors.black,
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.w500,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  getText("DATE", defaultValue: "Date"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(" :"),
                                SizedBox(
                                  width: 5,
                                ),
                                convertToLocalTime(
                                  widget.createDate.toString(),
                                ),
                                Spacer(),
                                Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                        widget.companyLogo.toString(),
                                      ),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            dotline(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Selling Price"),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showSelling = !showSelling;
                    });
                  },
                  child: Icon(
                    showSelling ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Buying Price"),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showBuying = !showBuying;
                    });
                  },
                  child: Icon(
                    showBuying ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: screenWidth,
              decoration: BoxDecoration(
                color: AppColors.defaultColor.withOpacity(0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () async {
                        captureImageFromWidgetAsFile(shareKey);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.defaultColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              child: Center(
                                child: Text(
                                  getText("SHARE", defaultValue: "Share"),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () async {
                        capturePng();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.defaultColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              child: Center(
                                child: Text(
                                  getText("SAVE_AS_IMAGE",
                                      defaultValue: "Save as image"),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.defaultColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              child: Center(
                                child: Text(
                                  getText("CLOSE", defaultValue: "Close"),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
