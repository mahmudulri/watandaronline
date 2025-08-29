import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:watandaronline/controllers/company_controller.dart';
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/controllers/custom_history_controller.dart';
import 'package:watandaronline/controllers/custom_recharge_controller.dart';
import 'package:watandaronline/controllers/dashboard_controller.dart';
import 'package:watandaronline/controllers/history_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/operator_controller.dart';
import 'package:watandaronline/helpers/language_helper.dart';
import 'package:watandaronline/screens/custom_order_details.dart';
import 'package:watandaronline/screens/order_details_screen.dart';
import 'package:watandaronline/utils/colors.dart';
import 'package:watandaronline/widgets/default_button.dart';

import '../controllers/conversation_controller.dart';
import '../controllers/currency_controller_new.dart';
import '../global controller/languages_controller.dart';
import 'neworderdetails_screen.dart';

class CustomRechargeScreen extends StatefulWidget {
  CustomRechargeScreen({super.key});

  @override
  State<CustomRechargeScreen> createState() => _CustomRechargeScreenState();
}

class _CustomRechargeScreenState extends State<CustomRechargeScreen> {
  final languagesController = Get.find<LanguagesController>();

  final countryListController = Get.find<CountryListController>();
  final customrechargeController = Get.find<CustomRechargeController>();

  final OperatorController operatorController = Get.put(OperatorController());

  // final historyController = Get.find<HistoryController>();
  final customhistoryController = Get.find<CustomHistoryController>();
  final ScrollController scrollController = ScrollController();

  ConversationController conversationController =
      Get.put(ConversationController());

  int selectedIndex = 0;
  final box = GetStorage();

  Future<void> refresh() async {
    final int totalPages = customhistoryController
            .allorderlist.value.payload?.pagination!.totalPages ??
        0;
    final int currentPage = customhistoryController.initialpage;

    // Prevent loading more pages if we've reached the last page
    if (currentPage >= totalPages) {
      print(
          "End..........................................End.....................");
      return;
    }

    // Check if the scroll position is at the bottom
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      customhistoryController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (customhistoryController.initialpage <= totalPages) {
        print("Load More...................");
        customhistoryController.fetchHistory();
      } else {
        customhistoryController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  CompanyController companyController = Get.put(CompanyController());

  @override
  void initState() {
    super.initState();

    customhistoryController.finalList.clear();
    customhistoryController.initialpage = 1;
    // historyController.fetchHistory();

    customhistoryController.fetchHistory();

    scrollController.addListener(refresh);
    customrechargeController.numberController.addListener(() {
      final text = customrechargeController.numberController.text;
      companyController.matchCompanyByPhoneNumber(text);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
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
        title: Text(
          languagesController.tr("DIRECT_RECHARGE"),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            children: [
              Container(
                height: 260,
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
                                  controller:
                                      customrechargeController.numberController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(int.parse(
                                        box.read(
                                            "maxlength"))), // Limit input length
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only numeric input
                                  ],
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 5),
                                    border: InputBorder.none,
                                    hintText:
                                        languagesController.tr("PHONE_NUMBER"),
                                  ),
                                ),
                              ),
                              Obx(() {
                                final company =
                                    companyController.matchedCompany.value;
                                return Container(
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: company == null
                                        ? Colors.transparent
                                        : null,
                                    image: company != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                company.companyLogo ?? ''),
                                            fit: BoxFit.contain,
                                          )
                                        : null,
                                  ),
                                  child: company == null
                                      ? Center(
                                          child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors.transparent,
                                        ))
                                      : null,
                                );
                              }),
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
                                  onChanged: (value) {
                                    conversationController.inputAmount.value =
                                        double.tryParse(value) ?? 0.0;
                                  },
                                  controller:
                                      customrechargeController.amountController,
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
                                    hintText: languagesController.tr("AMOUNT"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 50,
                        child: Obx(() {
                          final convertedList =
                              conversationController.getConvertedValues();

                          if (convertedList.isEmpty) {
                            return Center(child: Text("dd"));
                          }

                          final item =
                              convertedList.first; // only show the first item

                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "${item['symbol']} :",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    item['value'].toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DefaultButton(
                        buttonName: languagesController.tr("RECHARGE_NOW"),
                        onPressed: () {
                          if (customrechargeController
                                  .numberController.text.isNotEmpty &&
                              customrechargeController
                                  .amountController.text.isNotEmpty) {
                            if (customrechargeController
                                    .numberController.text.length
                                    .toString() !=
                                box.read("maxlength")) {
                              Get.snackbar(
                                  languagesController.tr("LENGTH_ERROR"),
                                  languagesController
                                      .tr("DO_NOT_MATCH_THE_NUMBER_LENGTH"));
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
                                            Future.delayed(Duration(seconds: 2),
                                                () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            });
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.defaultColor,
                                                  ),
                                                  onPressed: () {
                                                    customrechargeController
                                                            .loadsuccess.value =
                                                        false; // Reset success state
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    languagesController
                                                        .tr("CLOSE"),
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
                                                  languagesController.tr(
                                                      "DO_YOU_WANT_TO_CONFIRM"),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                SizedBox(height: 40),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        languagesController
                                                            .tr("CANCEL"),
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
                                                        languagesController
                                                            .tr("CONFIRM"),
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
                            Get.snackbar(languagesController.tr("ERROR"),
                                languagesController.tr("FILL_DATA_CORRECTLY"));
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
                () => customhistoryController.isLoading.value == false
                    ? Container(
                        child: customhistoryController
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
                                    Text(
                                      languagesController.tr("NO_DATA_FOUND"),
                                    ),
                                  ],
                                ),
                              ),
                      )
                    : SizedBox(),
              ),
              Expanded(
                child: Obx(
                  () => customhistoryController.isLoading.value == false &&
                          languageController.isLoading.value == false &&
                          customhistoryController.finalList.isNotEmpty
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
                            itemCount: customhistoryController.finalList.length,
                            itemBuilder: (context, index) {
                              final data =
                                  customhistoryController.finalList[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderSuccessScreen(
                                        createDate: data.createdAt.toString(),
                                        status: data.status.toString(),
                                        rejectReason:
                                            data.rejectReason.toString(),
                                        companyName: data.bundle!.service!
                                            .company!.companyName
                                            .toString(),
                                        amount: data.bundle.amount.toString(),
                                        bundleTitle: data.bundle!.bundleTitle!
                                            .toString(),
                                        rechargebleAccount:
                                            data.rechargebleAccount!.toString(),
                                        // validityType:
                                        //     data.bundle!.validityType!.toString(),
                                        sellingPrice: data.bundle!.sellingPrice
                                            .toString(),
                                        // amount: data.bundle!.amount.toString(),
                                        buyingPrice:
                                            data.bundle!.buyingPrice.toString(),
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
                                child: Container(
                                  height: 50,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
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
                                                Flexible(
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
                                              // Text(
                                              //   NumberFormat.currency(
                                              //     locale: 'en_US',
                                              //     symbol: '',
                                              //     decimalDigits: 2,
                                              //   ).format(
                                              //     double.parse(
                                              //       data.bundle!.sellingPrice
                                              //           .toString(),
                                              //     ),
                                              //   ),
                                              //   style: TextStyle(
                                              //     fontSize: 11,
                                              //     fontWeight: FontWeight.w600,
                                              //   ),
                                              // ),
                                              // SizedBox(
                                              //   width: 2,
                                              // ),
                                              Text(
                                                data.bundle!.amount.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: Colors.black,
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
                                                      ? languagesController
                                                          .tr("PENDING")
                                                      : data.status
                                                                  .toString() ==
                                                              "1"
                                                          ? languagesController
                                                              .tr("CONFIRMED")
                                                          : languagesController
                                                              .tr("REJECTED"),
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
                                ),
                              );
                            },
                          ),
                        )
                      : customhistoryController.finalList.isEmpty
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
                                itemCount:
                                    customhistoryController.finalList.length,
                                itemBuilder: (context, index) {
                                  final data =
                                      customhistoryController.finalList[index];
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
                                            amount:
                                                data.bundle.amount.toString(),
                                            bundleTitle: data
                                                .bundle!.bundleTitle!
                                                .toString(),
                                            rechargebleAccount: data
                                                .rechargebleAccount!
                                                .toString(),
                                            // validityType:
                                            //     data.bundle!.validityType!.toString(),
                                            sellingPrice: data
                                                .bundle!.sellingPrice
                                                .toString(),
                                            // amount: data.bundle!.amount.toString(),
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
                                    child: Container(
                                      height: 50,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
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
                                                    Flexible(
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
                                                  // Text(
                                                  //   NumberFormat.currency(
                                                  //     locale: 'en_US',
                                                  //     symbol: '',
                                                  //     decimalDigits: 2,
                                                  //   ).format(
                                                  //     double.parse(
                                                  //       data.bundle!.sellingPrice
                                                  //           .toString(),
                                                  //     ),
                                                  //   ),
                                                  //   style: TextStyle(
                                                  //     fontSize: 11,
                                                  //     fontWeight: FontWeight.w600,
                                                  //   ),
                                                  // ),
                                                  // SizedBox(
                                                  //   width: 2,
                                                  // ),
                                                  Text(
                                                    data.bundle!.amount
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15,
                                                      color: Colors.black,
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
                                                          ? languagesController
                                                              .tr("PENDING")
                                                          : data.status
                                                                      .toString() ==
                                                                  "1"
                                                              ? languagesController
                                                                  .tr(
                                                                      "CONFIRMED")
                                                              : languagesController
                                                                  .tr("REJECTED"),
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
