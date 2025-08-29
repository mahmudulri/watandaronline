import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/widgets/auth_textfield.dart';

import '../controllers/add_hawala_controller.dart';
import '../controllers/branch_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/currency_controller_new.dart';
import '../controllers/hawala_currency_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../global controller/languages_controller.dart';
import '../utils/colors.dart';
import '../widgets/default_button.dart';

class HawalaScreen extends StatefulWidget {
  HawalaScreen({super.key});

  @override
  State<HawalaScreen> createState() => _HawalaScreenState();
}

class _HawalaScreenState extends State<HawalaScreen> {
  final AddHawalaController addHawalaController =
      Get.put(AddHawalaController());
  SignInController signInController = Get.put(SignInController());

  final CurrencyController currencyController = Get.put(CurrencyController());
  final BranchController branchController = Get.put(BranchController());

  final box = GetStorage();

  List commissionpaidby = [];

  RxString person = "".obs;

  LanguagesController languagesController = Get.put(LanguagesController());

  HawalaCurrencyController hawalaCurrencyController =
      Get.put(HawalaCurrencyController());

  ConversationController conversationController =
      Get.put(ConversationController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addHawalaController.amountController.clear();
    addHawalaController.currency.value = '';
    addHawalaController.finalAmount.value = '';
    conversationController.selectedCurrency.value = "";
    addHawalaController.senderNameController.clear();
    addHawalaController.receiverNameController.clear();
    addHawalaController.fatherNameController.clear();
    addHawalaController.idcardController.clear();
    addHawalaController.currencyID.value == "";
    addHawalaController.paidbyreceiver.value = "";
    addHawalaController.paidbysender.value = "";
    addHawalaController.branchId.value = "";
    addHawalaController.currency.value = "";
    addHawalaController.currency2.value = "";
    addHawalaController.branch.value = "";

    hawalaCurrencyController.fetchcurrency();
    currencyController.fetchCurrency();
    branchController.fetchallbranch();
    commissionpaidby = [
      languagesController.tr("SENDER"),
      languagesController.tr("RECEIVER"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            hawalaCurrencyController.fetchcurrency();
          },
          child: Text(
            languagesController.tr("CREATE_HAWALA"),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Container(
        color: AppColors.backgroundColor,
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Text(
                languagesController.tr("SENDER_NAME"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              AuthTextField(
                hintText: "",
                controller: addHawalaController.senderNameController,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                languagesController.tr("RECEIVER_NAME"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              AuthTextField(
                hintText: "",
                controller: addHawalaController.receiverNameController,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                languagesController.tr("RECEIVER_FATHERS_NAME"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              AuthTextField(
                hintText: "",
                controller: addHawalaController.fatherNameController,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                languagesController.tr("RECEIVER_ID_CARD_NUMBER"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              AuthTextField(
                hintText: "",
                controller: addHawalaController.idcardController,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    languagesController.tr("HAWALA_AMOUNT"),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.020,
                    ),
                  ),
                  Text(
                    languagesController.tr("CURRENCY"),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.020,
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
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: screenHeight * 0.065,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          color: Color(0xffF9FAFB),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: TextField(
                            style: TextStyle(
                              height: 1.1,
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            controller: addHawalaController.amountController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenHeight * 0.018,
                              ),
                            ),
                            onChanged: (value) {
                              final selected =
                                  addHawalaController.selectedRate.value;

                              // যদি কোন currency সিলেক্ট না করা হয় (selected null হয়) তাহলে হিসাব না করো
                              if (selected == null ||
                                  addHawalaController.currency.value.isEmpty) {
                                addHawalaController.finalAmount.value = "0.00";
                                return;
                              }

                              double input = double.tryParse(addHawalaController
                                      .amountController.text
                                      .trim()) ??
                                  0;
                              double dAmount = double.tryParse(
                                      selected.amount?.toString() ?? "0") ??
                                  0;
                              double sRate = double.tryParse(
                                      selected.sellRate?.toString() ?? "0") ??
                                  0;

                              double result = 0;
                              if (dAmount > 0 && sRate > 0) {
                                result = (input / dAmount) * sRate;
                              }

                              addHawalaController.finalAmount.value =
                                  result.toStringAsFixed(2);
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Obx(() {
                        final List<dynamic> rates = (hawalaCurrencyController
                                .hawalafilteredcurrency
                                .value
                                .data
                                ?.rates as List?) ??
                            <dynamic>[];

                        double _toDouble(dynamic v) {
                          if (v == null) return 0;
                          return double.tryParse(v.toString()) ?? 0;
                        }

                        final bool langIsFa =
                            box.read("language").toString() == "Fa";

                        // 1) ডুপ্লিকেট toCurrency.id বাদ দিয়ে প্রথম occurrence রাখি
                        final Map<String, dynamic> uniqueByToId = {};
                        for (final r in rates) {
                          final String toId =
                              ((r?.toCurrency?.id) ?? '').toString();
                          if (toId.isEmpty) continue;
                          // আগে রাখা না থাকলে রাখি (প্রথমটাই থাকবে)
                          uniqueByToId.putIfAbsent(toId, () => r);
                        }

                        // 2) Dropdown items তৈরি
                        final dropdownItems = uniqueByToId.entries
                            .map<DropdownMenuItem<String>>((e) {
                          final symbol =
                              ((e.value?.toCurrency?.symbol) ?? '').toString();
                          return DropdownMenuItem<String>(
                            value: e.key, // toCurrency.id
                            child: Text(symbol),
                          );
                        }).toList();

                        // 3) বর্তমান value dropdown-এ আছে কিনা
                        final currentValue =
                            addHawalaController.currencyID.value;
                        final bool valueExists = currentValue.isNotEmpty &&
                            uniqueByToId.containsKey(currentValue);

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            alignment: !langIsFa
                                ? Alignment.centerLeft
                                : Alignment.centerRight,

                            // dropdown-এ না থাকলে null
                            value: valueExists ? currentValue : null,

                            items: dropdownItems,

                            onChanged: (value) {
                              if (value == null) return;

                              // 4) নির্বাচিত rate (ডুপ্লিকেট ফ্রি map থেকে)
                              final selectedRate = uniqueByToId[value];

                              // 5) controller আপডেট
                              addHawalaController.currencyID.value = value;
                              addHawalaController.currency.value =
                                  ((selectedRate?.toCurrency?.symbol) ?? '')
                                      .toString();
                              addHawalaController.selectedRate.value =
                                  selectedRate;

                              // 6) হিসাব
                              final input = _toDouble(addHawalaController
                                  .amountController.text
                                  .trim());
                              final dAmount = _toDouble(selectedRate?.amount);
                              final sRate = _toDouble(selectedRate?.sellRate);

                              double result = 0;
                              if (dAmount > 0 && sRate > 0) {
                                result = (input / dAmount) * sRate;
                              }
                              addHawalaController.finalAmount.value =
                                  result.toStringAsFixed(2);
                            },

                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            icon: CircleAvatar(
                              backgroundColor:
                                  AppColors.defaultColor.withOpacity(0.7),
                              radius: 15,
                              child: Icon(
                                FontAwesomeIcons.chevronDown,
                                color: Colors.white,
                                size: 17,
                              ),
                            ),
                            hint: Text(
                              addHawalaController.currency.value.isEmpty
                                  ? ''
                                  : addHawalaController.currency.value,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Text(
              //   languagesController.tr("YOUR_ACCOUNT_BALANCE_IS"),
              //   style: TextStyle(
              //     color: AppColors.primaryColor,
              //     fontWeight: FontWeight.w500,
              //     fontSize: screenHeight * 0.017,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              Text(
                languagesController.tr("COMMISSION_PAID_BY"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            person.value.toString(),
                            style: TextStyle(
                              fontSize: screenHeight * 0.020,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  height: 150,
                                  width: screenWidth,
                                  color: Colors.white,
                                  child: ListView.builder(
                                    itemCount: commissionpaidby.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          person.value =
                                              commissionpaidby[index];
                                          if (commissionpaidby[index] ==
                                              "sender") {
                                            addHawalaController
                                                .paidbysender.value = "1";
                                            addHawalaController
                                                .paidbyreceiver.value = "0";
                                          } else {
                                            addHawalaController
                                                .paidbysender.value = "0";
                                            addHawalaController
                                                .paidbyreceiver.value = "1";
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 8),
                                          height: 40,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          child: Text(
                                            commissionpaidby[index],
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              AppColors.defaultColor.withOpacity(0.7),
                          radius: 15,
                          child: Icon(
                            FontAwesomeIcons.chevronDown,
                            color: Colors.white,
                            size: 17,
                          ),
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
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Color(0xff352B73),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          addHawalaController.finalAmount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        box.read("currency_code"),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                languagesController
                    .tr("FINAL_AMOUNT_DEDUCTED_FROM_YOUR_BALANCE"),
                style: TextStyle(
                  color: AppColors.defaultColor,
                  fontWeight: FontWeight.w500,
                  fontSize: screenHeight * 0.015,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                languagesController.tr("BRANCH"),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screenHeight * 0.020,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      Expanded(
                          child: Obx(
                        () => Text(
                          addHawalaController.branch.toString(),
                          style: TextStyle(
                            fontSize: screenHeight * 0.020,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      )),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  height: 150,
                                  width: screenWidth,
                                  color: Colors.white,
                                  child: Obx(
                                    () => branchController.isLoading.value ==
                                            false
                                        ? ListView.builder(
                                            itemCount: branchController
                                                .allbranch
                                                .value
                                                .data!
                                                .hawalabranches!
                                                .length,
                                            itemBuilder: (context, index) {
                                              final data = branchController
                                                  .allbranch
                                                  .value
                                                  .data!
                                                  .hawalabranches![index];
                                              return GestureDetector(
                                                onTap: () {
                                                  addHawalaController
                                                          .branch.value =
                                                      data.name.toString();
                                                  addHawalaController
                                                          .branchId.value =
                                                      data.id.toString();

                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 8),
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          data.name.toString(),
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
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              AppColors.defaultColor.withOpacity(0.7),
                          radius: 15,
                          child: Icon(
                            FontAwesomeIcons.chevronDown,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => DefaultButton(
                  buttonName: addHawalaController.isLoading.value == false
                      ? languagesController.tr("CONFIRM_AND_SUBMIT")
                      : languagesController.tr("PLEASE_WAIT"),
                  onPressed: () async {
                    if (addHawalaController.senderNameController.text.isNotEmpty &&
                        addHawalaController
                            .receiverNameController.text.isNotEmpty &&
                        addHawalaController.amountController.text.isNotEmpty &&
                        addHawalaController
                            .fatherNameController.text.isNotEmpty &&
                        addHawalaController.idcardController.text.isNotEmpty &&
                        addHawalaController.currencyID.value != "" &&
                        addHawalaController.paidbyreceiver.value != "" &&
                        addHawalaController.branchId.value != "") {
                      print("All is ok............");

                      bool success = await addHawalaController.createhawala();
                      if (success) {
                        Get.back();
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Enter All data",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                ),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
