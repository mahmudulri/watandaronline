import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watantelecom/controllers/change_balance_controller.dart';
import 'package:watantelecom/utils/colors.dart';
import 'package:watantelecom/widgets/auth_textfield.dart';
import 'package:watantelecom/widgets/default_button.dart';

class ChangeBalanceScreen extends StatefulWidget {
  String? subID;
  ChangeBalanceScreen({
    super.key,
    this.subID,
  });

  @override
  State<ChangeBalanceScreen> createState() => _ChangeBalanceScreenState();
}

class _ChangeBalanceScreenState extends State<ChangeBalanceScreen> {
  final BalanceController balanceController = Get.put(BalanceController());
  bool isCreditSelected = false;
  bool isDebitSelected = false;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
          "Change Balance",
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
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Amount : ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 55,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 55,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 1,
                            color: AppColors.borderColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Center(
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              controller: balanceController.amountController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter amount",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 55,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 1,
                            color: AppColors.borderColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextField(
                                readOnly: true,
                                keyboardType: TextInputType.phone,
                                controller: balanceController.amountController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: box.read("currency_code"),
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // AuthTextField(
              //   hintText: "Enter your amount",
              //   controller: balanceController.amountController,
              // ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Select Type :",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      balanceController.status.value = "credit";
                      setState(() {
                        isCreditSelected = true;
                        isDebitSelected = false;
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isCreditSelected ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Credit',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        balanceController.status.value = "debit";
                        isCreditSelected = false;
                        isDebitSelected = true;
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDebitSelected ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Debit',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Obx(
                () => DefaultButton(
                  buttonName: balanceController.isLoading.value == false
                      ? "Confirm Now"
                      : "Please wait..",
                  onPressed: () {
                    if (balanceController.amountController.text.isEmpty ||
                        balanceController.status.value == '') {
                      Fluttertoast.showToast(
                          msg: "Enter Amount or Select Type",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      if (balanceController.status.value == "credit") {
                        balanceController.credit(widget.subID.toString());
                      } else {
                        balanceController.debit(widget.subID.toString());
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
