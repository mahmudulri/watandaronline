import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/hawala_cancel_controller.dart';
import '../controllers/hawala_list_controller.dart';
import '../global controller/languages_controller.dart';
import '../helpers/capture_image_helper.dart';
import '../helpers/share_image_helper.dart';
import '../utils/colors.dart';
import 'create_hawala_screen.dart';

class HawalaListScreen extends StatefulWidget {
  HawalaListScreen({super.key});

  @override
  State<HawalaListScreen> createState() => _HawalaListScreenState();
}

class _HawalaListScreenState extends State<HawalaListScreen> {
  final box = GetStorage();

  HawalaListController hawalalistController = Get.put(HawalaListController());

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    hawalalistController.fetchhawala();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: Text(
          languagesController.tr("HAWALA_ORDER_LIST"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(
                height: 7,
              ),
              Container(
                height: 50,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: languagesController.tr("SEARCH"),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenHeight * 0.020,
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
                      flex: 4,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HawalaScreen(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("NEW_ORDER"),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
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
              Expanded(
                  child: Obx(
                () => hawalalistController.isLoading.value == false
                    ? ListView.separated(
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 5,
                          );
                        },
                        itemCount: hawalalistController
                            .allhawalalist.value.data!.orders!.length,
                        itemBuilder: (context, index) {
                          final data = hawalalistController
                              .allhawalalist.value.data!.orders![index];
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        17,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(0),
                                    content: HawalaDetailsDialog(
                                      id: data.id.toString(),
                                      hawalaNumber: data.hawalaNumber,
                                      status: data.status,
                                      branchID: data.hawalaBranchId,
                                      senderName: data.senderName,
                                      receiverName: data.receiverName,
                                      fatherName: data.receiverFatherName,
                                      idcardnumber: data.receiverIdCardNumber,
                                      amount: data.hawalaAmount,
                                      hawalacurrencyRate:
                                          data.hawalaAmountCurrencyRate,
                                      hawalacurrencyCode:
                                          data.hawalaAmountCurrencyCode,
                                      resellercurrencyCode:
                                          data.resellerPreferedCurrencyCode,
                                      resellCurrencyRate:
                                          data.resellerPreferedCurrencyRate,
                                      paidbysender: data.commissionPaidBySender
                                          .toString(),
                                      paidbyreceiver: data
                                          .commissionPaidByReceiver
                                          .toString(),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 1,
                                  color: data.status.toString() == "pending"
                                      ? Color(0xffFFC107)
                                      : data.status.toString() == "confirmed"
                                          ? Colors.green
                                          : Color(0xffFF4842),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: data.status.toString() == "pending"
                                          ? Color(0xffFFC107)
                                          : data.status.toString() ==
                                                  "confirmed"
                                              ? Colors.green
                                              : Color(0xffFF4842),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            languagesController
                                                    .tr("HAWALA_NUMBER") +
                                                " - " +
                                                data.hawalaNumber.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            data.status.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languagesController
                                                  .tr("SENDER_NAME"),
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              data.senderName.toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languagesController
                                                  .tr("RECEIVER_NAME"),
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              data.receiverName.toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languagesController
                                                  .tr("HAWALA_AMOUNT"),
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              data.hawalaAmount.toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languagesController
                                                  .tr("PAYABLE_AMOUNT"),
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              data.hawalaAmountCurrencyRate
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class HawalaDetailsDialog extends StatelessWidget {
  HawalaDetailsDialog({
    super.key,
    this.id,
    this.hawalaNumber,
    this.status,
    this.branchID,
    this.senderName,
    this.receiverName,
    this.fatherName,
    this.idcardnumber,
    this.amount,
    this.hawalacurrencyRate,
    this.hawalacurrencyCode,
    this.resellercurrencyCode,
    this.resellCurrencyRate,
    this.paidbysender,
    this.paidbyreceiver,
  });
  String? id;
  String? hawalaNumber;
  String? status;
  String? branchID;
  String? senderName;
  String? receiverName;
  String? fatherName;
  String? idcardnumber;
  String? amount;
  String? hawalacurrencyRate;
  String? hawalacurrencyCode;
  String? resellercurrencyCode;
  String? resellCurrencyRate;
  String? paidbysender;
  String? paidbyreceiver;

  LanguagesController languagesController = Get.put(LanguagesController());

  final box = GetStorage();

  CancelHawalaController cancelHawalaController =
      Get.put(CancelHawalaController());

  RxBool isopen = true.obs;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 630,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: SizedBox(
          child: Column(
            children: [
              RepaintBoundary(
                key: catpureKey,
                child: RepaintBoundary(
                  key: shareKey,
                  child: Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: status.toString() == "pending"
                            ? Color(0xffFFC107)
                            : status.toString() == "approved"
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(
                              status.toString() == "pending"
                                  ? "assets/icons/pending.png"
                                  : status.toString() == "approved"
                                      ? "assets/icons/successful.png"
                                      : "assets/icons/rejected.png",
                              height: 60,
                            ),
                          ),
                          Text(
                            status.toString() == "pending"
                                ? languagesController.tr("PENDING")
                                : status.toString() == "approved"
                                    ? languagesController.tr("CONFIRMED")
                                    : languagesController.tr("REJECTED"),
                            style: TextStyle(
                              color: status.toString() == "pending"
                                  ? Color(0xffFFC107)
                                  : status.toString() == "approved"
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languagesController.tr("HAWALA_NUMBER"),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                hawalaNumber.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languagesController.tr("HAWALA_AMOUNT"),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                amount.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
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
                                languagesController.tr("SENDER_NAME"),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                senderName.toString(),
                                style: TextStyle(
                                  fontSize: 14,
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
                                languagesController.tr("RECEIVER_NAME"),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                receiverName.toString(),
                                style: TextStyle(
                                  fontSize: 14,
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
                              Flexible(
                                child: Text(
                                  languagesController
                                      .tr("RECEIVER_ID_CARD_NUMBER"),
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Text(
                                idcardnumber.toString(),
                                style: TextStyle(
                                  fontSize: 14,
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
                                languagesController.tr("RECEIVER_FATHERS_NAME"),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                fatherName.toString(),
                                style: TextStyle(
                                  fontSize: 14,
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
                                languagesController.tr("HAWALA_CURRENCY_RATE"),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                hawalacurrencyRate.toString(),
                                style: TextStyle(
                                  fontSize: 14,
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
                                languagesController.tr("HAWALA_CURRENCY_CODE"),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                hawalacurrencyCode.toString(),
                                style: TextStyle(
                                  fontSize: 14,
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
                                languagesController
                                    .tr("RESELLER_CURRENCY_RATE"),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                resellCurrencyRate.toString(),
                                style: TextStyle(
                                  fontSize: 14,
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
                                languagesController
                                    .tr("RESELLER_CURRENCY_CODE"),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                resellercurrencyCode.toString(),
                                style: TextStyle(
                                  fontSize: 14,
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
                                languagesController.tr("COMMISSION_PAID_BY"),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                paidbysender.toString() == "true"
                                    ? languagesController.tr("SENDER")
                                    : languagesController.tr("RECEIVER"),
                                style: TextStyle(
                                  fontSize: 14,
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
              SizedBox(
                height: 8,
              ),
              Container(
                height: 40,
                width: screenWidth,
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
                              color: AppColors.defaultColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("SAVE_TO_GALLERY"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.defaultColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          captureImageFromWidgetAsFile(shareKey);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.defaultColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("SHARE"),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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
                height: 8,
              ),
              Obx(() => isopen.value
                  ? Visibility(
                      visible: status.toString() == "pending",
                      child: GestureDetector(
                        onTap: () {
                          isopen.value = false; // This will trigger rebuild
                        },
                        child: Container(
                          height: 45,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("CANCEL_ORDER"),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 45,
                      width: screenWidth,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                isopen.value = true; // Go back to cancel button
                                // Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    languagesController.tr("NO"),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                cancelHawalaController.cancelnow(id);
                                print(id.toString());
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    languagesController.tr("YES"),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade600,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      languagesController.tr("CLOSE"),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
