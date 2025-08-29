import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/dashboard_controller.dart';
import '../global controller/languages_controller.dart';
import '../routes/routes.dart';

import '../screens/commission_transfer_screen.dart';
import '../screens/hawala_currency_screen.dart';
import '../screens/hawala_list_screen.dart';
import '../screens/loan_screen.dart';
import '../utils/colors.dart';
import '../widgets/payment_button.dart';
import 'transactions.dart';

class TransactionsType extends StatefulWidget {
  TransactionsType({super.key});

  @override
  State<TransactionsType> createState() => _TransactionsTypeState();
}

class _TransactionsTypeState extends State<TransactionsType> {
  final box = GetStorage();

  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          languagesController.tr("TRANSACTIONS_TYPES"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffF1F3FF),
        ),
        height: screenHeight,
        width: screenWidth,
        child: ListView(
          children: [
            Container(
              width: screenWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Column(
                  children: [
                    PaymentButton(
                      buttonName:
                          languagesController.tr("PAYMENT_RECEIPT_REQUEST"),
                      imagelink: "assets/icons/wallet.png",
                      mycolor: Color(0xff04B75D),
                      onpressed: () {
                        Get.toNamed(receiptScreen);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PaymentButton(
                      buttonName: languagesController.tr("REQUES_LOAN_BALANCE"),
                      imagelink: "assets/icons/transactionsicon2.png",
                      mycolor: Color(0xff3498db),
                      onpressed: () {
                        Get.to(() => RequestLoanScreen());
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PaymentButton(
                      buttonName: languagesController.tr("HAWALA"),
                      imagelink: "assets/icons/exchange.png",
                      mycolor: Color(0xffFE8F2D),
                      onpressed: () {
                        Get.to(() => HawalaListScreen());
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PaymentButton(
                      buttonName: languagesController.tr("HAWALA_RATES"),
                      imagelink: "assets/icons/exchange-rate.png",
                      mycolor: Color(0xff4B7AFC),
                      onpressed: () {
                        Get.to(() => HawalaCurrencyScreen());
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PaymentButton(
                      buttonName:
                          languagesController.tr("BALANCE_TRANSACTIONS"),
                      imagelink: "assets/icons/transactionsicon2.png",
                      mycolor: Color(0xffDE4B5E),
                      onpressed: () {
                        Get.to(() => TransactionsPage());
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PaymentButton(
                      buttonName: languagesController
                          .tr("TRANSFER_COMISSION_TO_BALANCE"),
                      imagelink: "assets/icons/transactionsicon2.png",
                      mycolor: Color(0xff9b59b6),
                      onpressed: () {
                        Get.to(() => CommissionTransferScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
