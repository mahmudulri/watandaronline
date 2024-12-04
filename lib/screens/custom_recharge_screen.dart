import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/controllers/custom_recharge_controller.dart';
import 'package:watandaronline/controllers/history_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/operator_controller.dart';
import 'package:watandaronline/helpers/language_helper.dart';
import 'package:watandaronline/screens/order_details_screen.dart';
import 'package:watandaronline/utils/colors.dart';
import 'package:watandaronline/widgets/default_button.dart';

class CustomRechargeScreen extends StatefulWidget {
  CustomRechargeScreen({super.key});

  @override
  State<CustomRechargeScreen> createState() => _CustomRechargeScreenState();
}

class _CustomRechargeScreenState extends State<CustomRechargeScreen> {
  final languageController = Get.find<LanguageController>();

  final countryListController = Get.find<CountryListController>();
  final customrechargeController = Get.find<CustomRechargeController>();

  final OperatorController operatorController = Get.put(OperatorController());

  final historyController = Get.find<HistoryController>();
  final ScrollController scrollController = ScrollController();

  int selectedIndex = 0;
  final box = GetStorage();

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

  @override
  void initState() {
    super.initState();

    // historyController.initialpage = 1;
    // historyController.fetchHistory();

    scrollController.addListener(refresh);

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        box.write("customkey", "");
        // Return true if you want to allow the back action, false to prevent it.
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              box.write("customkey", "");
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              print(box.read("customkey"));
              historyController.fetchHistory();
            },
            child: Text(
              getText("DIRECT_RECHARGE", defaultValue: "Direct Recharge"),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              children: [
                Obx(
                  () => countryListController.isLoading.value == false
                      ? Container(
                          height: 40,
                          width: screenWidth,
                          // color: Colors.grey,
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 10,
                              );
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: countryListController.allcountryListData
                                .value.data!.countries.length,
                            itemBuilder: (context, index) {
                              final data = countryListController
                                  .allcountryListData
                                  .value
                                  .data!
                                  .countries[index];
                              bool isSelected = index == selectedIndex;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;

                                    box.write("country_id", data.id);
                                    print(box.read("country_id"));
                                    box.write("maxlength",
                                        data.phoneNumberLength.toString());
                                    print(box.read("maxlength"));
                                    // numberlength =
                                    //     data.phoneNumberLength.toString();

                                    if (index == 0) {
                                      operatorController.currentOperators =
                                          operatorController.afganoperator;
                                    } else if (index == 1) {
                                      operatorController.currentOperators =
                                          operatorController.banglaoperator;
                                    } else {
                                      operatorController.currentOperators =
                                          operatorController.turkeyoperator;
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.defaultColor
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                data.countryFlagImageUrl
                                                    .toString(),
                                              ),
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          data.countryName.toString(),
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
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
                      : SizedBox(),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: 220,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.defaultColor.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Container(
                          height: 55,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: AppColors.defaultColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/phone.png",
                                  height: 25,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: customrechargeController
                                        .numberController,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                          int.parse(box.read(
                                              "maxlength"))), // Limit input length
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Allow only numeric input
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      border: InputBorder.none,
                                      hintText: getText("PHONE_NUMBER",
                                          defaultValue: "Amount "),
                                    ),
                                    // onChanged: (value) {
                                    //   // Enforce starting with 0
                                    //   if (!value.startsWith('0')) {
                                    //     customrechargeController
                                    //         .numberController.text = '0' + value;
                                    //     customrechargeController
                                    //             .numberController.selection =
                                    //         TextSelection.fromPosition(
                                    //             TextPosition(
                                    //       offset: customrechargeController
                                    //           .numberController.text.length,
                                    //     ));
                                    //   }
                                    // },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 55,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: AppColors.defaultColor,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/money.png",
                                  height: 25,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: customrechargeController
                                        .amountController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Allow only digits
                                      CustomAmountFormatter() // Enforce value >= 1
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      border: InputBorder.none,
                                      hintText: getText("AMOUNT",
                                          defaultValue: "Amount "),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        DefaultButton(
                          buttonName: getText("RECHARGE_NOW",
                              defaultValue: "Recharge now"),
                          onPressed: () {
                            if (customrechargeController
                                    .numberController.text.isNotEmpty &&
                                customrechargeController
                                    .amountController.text.isNotEmpty) {
                              if (customrechargeController
                                      .numberController.text.length
                                      .toString() !=
                                  box.read("maxlength")) {
                                Get.snackbar("Length error",
                                    "Do not match number length");
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.all(0.0),
                                      content: Container(
                                        height: 250,
                                        width: screenWidth,
                                        child: Obx(
                                          () {
                                            if (customrechargeController
                                                .isLoading.value) {
                                              return Center(
                                                child: Container(
                                                  height: 220,
                                                  width: 220,
                                                  child: Lottie.asset(
                                                      'assets/loties/loading-01.json'),
                                                ),
                                              );
                                            } else if (customrechargeController
                                                .loadsuccess.value) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 180,
                                                    width: 180,
                                                    child: Lottie.asset(
                                                        'assets/loties/loadsuccess.json'),
                                                  ),
                                                  SizedBox(height: 20),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: AppColors
                                                          .defaultColor,
                                                    ),
                                                    onPressed: () {
                                                      customrechargeController
                                                              .loadsuccess
                                                              .value =
                                                          false; // Reset success state
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Close",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    getText(
                                                        "DO_YOU_WANT_TO_CONFIRM",
                                                        defaultValue:
                                                            "Do you want to confirm "),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  SizedBox(height: 40),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              AppColors
                                                                  .defaultColor,
                                                        ),
                                                        onPressed: () {
                                                          customrechargeController
                                                                  .loadsuccess
                                                                  .value =
                                                              false; // Reset success state
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          getText("CANCEL",
                                                              defaultValue:
                                                                  "Cancel "),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                        onPressed: () {
                                                          customrechargeController
                                                              .placeOrder();
                                                        },
                                                        child: Text(
                                                          getText("CONFIRM",
                                                              defaultValue:
                                                                  "Confirm "),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            } else {
                              Get.snackbar("Error", "Fill data correctly");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Obx(
                  () => historyController.isLoading.value == false
                      ? Container(
                          child: historyController
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
                    () => historyController.isLoading.value == false &&
                            languageController.isLoading.value == false &&
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
                              itemCount: historyController.finalList.length,
                              itemBuilder: (context, index) {
                                final data = historyController.finalList[index];
                                return Container(
                                  height: 50,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    //   width: 1,
                                    //   color: Colors.grey,
                                    // ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.listbuilderboxColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                data.bundle!.service!.company!
                                                    .companyLogo
                                                    .toString(),
                                              ),
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible: data
                                                          .bundle!.bundleTitle
                                                          .toString() !=
                                                      "",
                                                  child: Flexible(
                                                    child: Text(
                                                      data.bundle!.bundleTitle
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  data.rechargebleAccount
                                                      .toString(),
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
                                          width: 5,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              Text(
                                                NumberFormat.currency(
                                                  locale: 'en_US',
                                                  symbol: '',
                                                  decimalDigits: 2,
                                                ).format(
                                                  double.parse(
                                                    data.bundle!.sellingPrice
                                                        .toString(),
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
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  data.status.toString() == "0"
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
                                                    fontWeight: FontWeight.w600,
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
                                            padding: EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              data.status.toString() == "0"
                                                  ? "assets/icons/pending.png"
                                                  : data.status.toString() ==
                                                          "1"
                                                      ? "assets/icons/success.png"
                                                      : "assets/icons/reject.png",
                                              height: 26,
                                            ),
                                          ),
                                        ),
                                      ],
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
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 5,
                                    );
                                  },
                                  itemCount: historyController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        historyController.finalList[index];
                                    return Container(
                                      height: 50,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                        // border: Border.all(
                                        //   width: 1,
                                        //   color: Colors.grey,
                                        // ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.listbuilderboxColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                    data.bundle!.service!
                                                        .company!.companyLogo
                                                        .toString(),
                                                  ),
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Visibility(
                                                      visible: data.bundle!
                                                              .bundleTitle
                                                              .toString() !=
                                                          "",
                                                      child: Flexible(
                                                        child: Text(
                                                          data.bundle!
                                                              .bundleTitle
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                        color: Colors.grey,
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
                                              child: Row(
                                                children: [
                                                  Text(
                                                    NumberFormat.currency(
                                                      locale: 'en_US',
                                                      symbol: '',
                                                      decimalDigits: 2,
                                                    ).format(
                                                      double.parse(
                                                        data.bundle!
                                                            .sellingPrice
                                                            .toString(),
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 11,
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
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 11,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                padding: EdgeInsets.all(10.0),
                                                child: Image.asset(
                                                  data.status.toString() == "0"
                                                      ? "assets/icons/pending.png"
                                                      : data.status
                                                                  .toString() ==
                                                              "1"
                                                          ? "assets/icons/success.png"
                                                          : "assets/icons/reject.png",
                                                  height: 26,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
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

class CustomAmountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Check if the input is empty
    if (newValue.text.isEmpty) {
      return TextEditingValue.empty;
    }

    // Parse the input to an integer
    final intValue = int.tryParse(newValue.text);

    // If parsing fails or the value is less than 1, revert to old value
    if (intValue == null || intValue < 1) {
      return oldValue;
    }

    // Allow the new value if it's valid
    return newValue;
  }
}
