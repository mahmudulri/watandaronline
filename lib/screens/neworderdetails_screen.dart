import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/language_controller.dart';
import '../controllers/time_zone_controller.dart';
import '../global controller/languages_controller.dart';
import '../helpers/capture_image_helper.dart';
import '../helpers/language_helper.dart';
import '../helpers/localtime_helper.dart';
import '../helpers/share_image_helper.dart';

class OrderSuccessScreen extends StatefulWidget {
  OrderSuccessScreen({
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
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  final TimeZoneController timeZoneController = Get.put(TimeZoneController());

  final languagesController = Get.find<LanguagesController>();

  bool showSelling = true;
  bool showBuying = false;

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF2C2C2C), // dark gray
              Color.fromARGB(255, 83, 82, 82), // lighter gray
            ],
          ),
        ),
        height: screenHeight,
        width: screenWidth,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RepaintBoundary(
                  key: catpureKey,
                  child: RepaintBoundary(
                    key: shareKey,
                    child: Container(
                      height: 450,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffE8F4FF),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    child: Container(
                                      height: 70,
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(
                                            "assets/icons/logo.png",
                                            height: 50,
                                          ),
                                          CircleAvatar(
                                            radius: 26,
                                            backgroundColor:
                                                widget.status.toString() == "0"
                                                    ? Colors.grey
                                                    : widget.status
                                                                .toString() ==
                                                            "1"
                                                        ? Colors.green
                                                        : Colors.red,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: CircleAvatar(
                                                radius: 24,
                                                backgroundColor: Colors.white,
                                                child: Padding(
                                                  padding: EdgeInsets.all(3.0),
                                                  child: Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: widget.status
                                                                  .toString() ==
                                                              "0"
                                                          ? Colors.grey
                                                          : widget.status
                                                                      .toString() ==
                                                                  "1"
                                                              ? Colors.green
                                                              : Colors.red,
                                                    ),
                                                    child: Icon(
                                                      widget.status
                                                                  .toString() ==
                                                              "0"
                                                          ? Icons.pending
                                                          : widget.status
                                                                      .toString() ==
                                                                  "1"
                                                              ? Icons.check
                                                              : Icons.close,
                                                      size: 30,
                                                      color: widget.status
                                                                  .toString() ==
                                                              "0"
                                                          ? Colors.white
                                                          : widget.status
                                                                      .toString() ==
                                                                  "1"
                                                              ? Colors.white
                                                              : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
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
                                    ),
                                  ),
                                  Text(
                                    widget.status.toString() == "0"
                                        ? languagesController.tr("PENDING")
                                        : widget.status.toString() == "1"
                                            ? languagesController.tr("SUCCESS")
                                            : languagesController
                                                .tr("REJECTED"),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Iranyekanregular",
                                      color: widget.status.toString() == "0"
                                          ? Colors.black
                                          : widget.status.toString() == "1"
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.status.toString() == "2",
                                    child: Text(
                                      widget.rejectReason.toString(),
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 35,
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
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          widget.bundleTitle.toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff212B36),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Spacer(),
                                        Visibility(
                                          visible:
                                              widget.validityType.toString() !=
                                                  "",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Text(
                                              //   languagesController
                                              //       .tr("VALIDITY_TYPE"),
                                              //   style: TextStyle(
                                              //     fontSize: 14,
                                              //     color: Colors.black,
                                              //   ),
                                              // ),
                                              Text(
                                                widget.validityType.toString() ==
                                                        "yearly"
                                                    ? languagesController
                                                        .tr("YEARLY")
                                                    : widget.validityType
                                                                .toString() ==
                                                            "unlimited"
                                                        ? languagesController
                                                            .tr("UNLIMITED")
                                                        : widget.validityType
                                                                    .toString() ==
                                                                "monthly"
                                                            ? languagesController
                                                                .tr("MONTHLY")
                                                            : widget.validityType
                                                                        .toString() ==
                                                                    "weekly"
                                                                ? languagesController
                                                                    .tr(
                                                                        "WEEKLY")
                                                                : widget.validityType
                                                                            .toString() ==
                                                                        "daily"
                                                                    ? languagesController.tr(
                                                                        "DAILY")
                                                                    : widget.validityType.toString() ==
                                                                            "hourly"
                                                                        ? languagesController.tr(
                                                                            "HOURLY")
                                                                        : widget.validityType.toString() ==
                                                                                "nightly"
                                                                            ? languagesController.tr("NIGHTLY")
                                                                            : "",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr("ORDER_ID"),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Iranyekanregular",
                                          ),
                                        ),
                                        Text(
                                          "WT#- " + widget.orderID.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff212B36),
                                            fontFamily: "Iranyekanregular",
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr("DATE"),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Iranyekanregular",
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        convertToDate(
                                          widget.createDate.toString(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr("TIME"),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Iranyekanregular",
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        convertToLocalTime(
                                          widget.createDate.toString(),
                                        ),
                                      ],
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
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                ),
                                color: Color(0xffE8F4FF),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController
                                              .tr("PHONE_NUMBER"),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Iranyekanregular",
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            widget.rechargebleAccount
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff212B36),
                                              fontFamily: "Iranyekanregular",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr("SENDER"),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Iranyekanregular",
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            widget.resellerName.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff212B36),
                                              fontFamily: "Iranyekanregular",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                              languagesController
                                                  .tr("BUYING_PRICE"),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff637381),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Iranyekanregular",
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
                                                  NumberFormat.currency(
                                                    locale: 'en_US',
                                                    symbol: '',
                                                    decimalDigits: 2,
                                                  ).format(
                                                    double.parse(
                                                      widget.buyingPrice
                                                          .toString(),
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily:
                                                        "Iranyekanregular",
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
                                              languagesController
                                                  .tr("SELLING_PRICE"),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff637381),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Iranyekanregular",
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
                                                  NumberFormat.currency(
                                                    locale: 'en_US',
                                                    symbol: '',
                                                    decimalDigits: 2,
                                                  ).format(
                                                    double.parse(
                                                      widget.sellingPrice
                                                          .toString(),
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily:
                                                        "Iranyekanregular",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(
                                    //       languagesController.tr("PRICE"),
                                    //       style: TextStyle(
                                    //         fontSize: 14,
                                    //         color: Color(0xff637381),
                                    //         fontWeight: FontWeight.w400,
                                    //         fontFamily: "Iranyekanregular",
                                    //       ),
                                    //     ),
                                    //     Row(
                                    //       children: [
                                    //         Text(
                                    //           box.read("currency_code"),
                                    //           style: TextStyle(
                                    //             fontSize: 14,
                                    //             color: Colors.grey,
                                    //             fontWeight: FontWeight.w600,
                                    //             fontFamily: "Iranyekanregular",
                                    //           ),
                                    //         ),
                                    //         SizedBox(
                                    //           width: 8,
                                    //         ),
                                    //         Text(
                                    //           NumberFormat.currency(
                                    //             locale: 'en_US',
                                    //             symbol: '',
                                    //             decimalDigits: 2,
                                    //           ).format(
                                    //             double.parse(
                                    //               widget.sellingPrice.toString(),
                                    //             ),
                                    //           ),
                                    //           style: TextStyle(
                                    //             color: Color(0xff212B36),
                                    //             fontSize: 14,
                                    //             fontWeight: FontWeight.w600,
                                    //             fontFamily: "Iranyekanregular",
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
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
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              languagesController.tr("SELLING_PRICE"),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showSelling = !showSelling;
                                });
                              },
                              child: Icon(
                                showSelling
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              languagesController.tr("BUYING_PRICE"),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showBuying = !showBuying;
                                });
                              },
                              child: Icon(
                                showBuying
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: double.maxFinite,
                          // color: Colors.red,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () async {
                                    capturePng();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xff2196F3),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        languagesController.tr("SAVE_AS_IMAGE"),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff2196F3),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Iranyekanregular",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () async {
                                    captureImageFromWidgetAsFile(shareKey);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff2196F3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        languagesController.tr("SHARE"),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Iranyekanregular",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                languagesController.tr("CLOSE"),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Iranyekanregular",
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
            ),
          ),
        ),
      ),
    );
  }
}
