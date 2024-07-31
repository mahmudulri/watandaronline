import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/controllers/history_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/sub_reseller_controller.dart';
import 'package:watandaronline/controllers/transaction_controller.dart';
import 'package:watandaronline/pages/more.dart';
import 'package:watandaronline/pages/orders.dart';
import 'package:watandaronline/pages/transactions.dart';

import 'package:watandaronline/pages/sub_reseller_screen.dart';
import 'package:watandaronline/utils/colors.dart';

import 'controllers/order_list_controller.dart';
import 'controllers/page_controller.dart';
import 'pages/homepage.dart';
import 'pages/myhomepage.dart';
import 'screens/change_pin.dart';
import 'screens/service_screen.dart';

class BottomNavigationbar extends StatefulWidget {
  BottomNavigationbar({super.key});

  @override
  State<BottomNavigationbar> createState() => _BottomNavigationbarState();
}

class _BottomNavigationbarState extends State<BottomNavigationbar> {
  // List pages = [
  //   Myhomepage(),
  //   TransactionsPage(),
  //   NotificationPage(),
  //   MorePage(),
  // ];
  final box = GetStorage();
  int currentIndex = 0;
  MyPageController myPageController = Get.put(MyPageController());

  final OrderlistController orderlistController =
      Get.put(OrderlistController());

  final HistoryController historyController = Get.put(HistoryController());
  final TransactionController transactionController =
      Get.put(TransactionController());
  final SubresellerController subresellerController =
      Get.put(SubresellerController());

  final PageStorageBucket bucket = PageStorageBucket();
  late Widget currentPage;

  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    currentPage = myPageController.currentPage;
  }

  void nextpage(index) {
    setState(() {
      currentIndex = index;
      controller.jumpToPage(index);
    });
  }

  final LanguageController languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    exit(0);
                  },
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    // ignore: deprecated_member_use
    return Obx(
      () => languageController.isLoading.value == false
          // ignore: deprecated_member_use
          ? WillPopScope(
              onWillPop: showExitPopup,
              child: Scaffold(
                body: PageStorage(bucket: bucket, child: currentPage),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  onPressed: () {
                    box.write("country_id", "2");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceScreen(),
                      ),
                    );
                    // Get.to(() => ServiceScreen());
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: SizedBox(
                  height: 67,
                  child: BottomAppBar(
                    elevation: 7.0,
                    shape: CircularNotchedRectangle(),
                    notchMargin: 10,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MaterialButton(
                              minWidth: 40,
                              onPressed: () {
                                setState(() {
                                  currentPage = Homepage();
                                  currentIndex = 0;
                                  orderlistController.finalList.clear();
                                  orderlistController.initialpage = 1;

                                  // historyController.finalList.clear();
                                  historyController.initialpage = 1;
                                  // historyController.fetchHistory();
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(
                                  //   Icons.home,
                                  //   color: currentIndex == 0 ? Colors.blue : Colors.grey,
                                  // ),
                                  Image.asset(
                                    "assets/icons/homeicon.png",
                                    height: 25,
                                    color: currentIndex == 0
                                        ? AppColors.defaultColor
                                        : Colors.black,
                                  ),
                                  Text(
                                    languageController.alllanguageData.value
                                        .languageData!["HOME"]
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: currentIndex == 0
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MaterialButton(
                              minWidth: 40,
                              onPressed: () {
                                setState(() {
                                  currentPage = TransactionsPage();
                                  currentIndex = 1;
                                  orderlistController.finalList.clear();
                                  orderlistController.initialpage = 1;
                                  historyController.finalList.clear();
                                  historyController.initialpage = 1;
                                });
                                transactionController.fetchTransactionData();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/transactionsicon.png",
                                    height: 25,
                                    color: currentIndex == 1
                                        ? AppColors.defaultColor
                                        : Colors.black,
                                  ),
                                  Text(
                                    languageController.alllanguageData.value
                                        .languageData!["TRANSACTIONS"]
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: currentIndex == 1
                                          ? AppColors.defaultColor
                                          : Colors.black,
                                      fontWeight: currentIndex == 1
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MaterialButton(
                              minWidth: 40,
                              onPressed: () {
                                box.write("orderstatus", "");
                                orderlistController.finalList.clear();
                                orderlistController.initialpage = 1;
                                setState(() {
                                  historyController.finalList.clear();
                                  historyController.finalList.clear();
                                  currentPage = NotificationPage();
                                  currentIndex = 2;
                                });
                                orderlistController.fetchOrderlistdata();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/notificationicon.png",
                                    height: 25,
                                    color: currentIndex == 2
                                        ? AppColors.defaultColor
                                        : Colors.black,
                                  ),
                                  Text(
                                    languageController.alllanguageData.value
                                        .languageData!["ORDERS"]
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: currentIndex == 2
                                          ? AppColors.defaultColor
                                          : Colors.black,
                                      fontWeight: currentIndex == 2
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MaterialButton(
                              minWidth: 40,
                              onPressed: () {
                                setState(() {
                                  currentPage = SubResellerScreen();
                                  currentIndex = 3;
                                  orderlistController.finalList.clear();
                                  orderlistController.initialpage = 1;
                                  historyController.finalList.clear();
                                  historyController.initialpage = 1;

                                  // print(orderlistController.initialpage);
                                  // print(orderlistController.finalList.length);
                                });
                                subresellerController.fetchSubReseller();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/sub_reseller.png",
                                    height: 25,
                                    color: currentIndex == 3
                                        ? AppColors.defaultColor
                                        : Colors.black,
                                  ),
                                  Text(
                                    languageController.alllanguageData.value
                                        .languageData!["SUB_RESELLER"]
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: currentIndex == 3
                                          ? AppColors.defaultColor
                                          : Colors.black,
                                      fontWeight: currentIndex == 3
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                    ),
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
            )
          : Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
    );
  }
}
