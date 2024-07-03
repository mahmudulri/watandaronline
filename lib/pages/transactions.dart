import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watantelecom/controllers/language_controller.dart';
import 'package:watantelecom/utils/colors.dart';

import '../controllers/transaction_controller.dart';

class TransactionsPage extends StatelessWidget {
  TransactionsPage({super.key});
  final TransactionController transactionController =
      Get.put(TransactionController());

  final box = GetStorage();

  final TextEditingController dateController = TextEditingController();
  final LanguageController languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    // transactionController.fetchTransactionData();

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColors.backgroundColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            languageController
                .alllanguageData.value.languageData!["TRANSACTIONS"]
                .toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          color: AppColors.backgroundColor,
          height: screenHeight,
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
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
                                  controller: dateController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "dd/mm/yyyy",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {},
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
                                    .languageData!["SEARCH"]
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      languageController
                              .alllanguageData.value.languageData!["ALL"]
                              .toString() +
                          " " +
                          languageController.alllanguageData.value
                              .languageData!["TRANSACTIONS"]
                              .toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Obx(
                  () => transactionController.isLoading.value == false
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: transactionController.alltransactionlist
                              .value.data!.resellerBalanceTransactions.length,
                          itemBuilder: (context, index) {
                            final data = transactionController
                                .alltransactionlist
                                .value
                                .data!
                                .resellerBalanceTransactions[index];
                            return Card(
                              child: Container(
                                width: screenWidth,
                                decoration: BoxDecoration(
                                    // color: Colors.grey,
                                    ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 50,
                                                width: screenWidth,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            data.order != null
                                                                ? Text(
                                                                    data
                                                                        .order!
                                                                        .bundle!
                                                                        .bundleTitle
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
                                                                  )
                                                                : SizedBox(),
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
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              data.reseller!
                                                                  .contactName
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
                                                              DateFormat(
                                                                      "dd-MM-yyyy")
                                                                  .format(DateTime
                                                                      .parse(data
                                                                          .createdAt
                                                                          .toString())),
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
                                                              data.status
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: data.status
                                                                            .toString() ==
                                                                        "debit"
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${box.read("currency_code")} ${data.amount}",
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: data.status
                                                                            .toString() ==
                                                                        "debit"
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .green,
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
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                )),
              ],
            ),
          ),
        ));
  }
}
