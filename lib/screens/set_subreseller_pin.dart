import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/widgets/default_button.dart';
import '../controllers/change_pin_controller.dart';
import '../global controller/languages_controller.dart';
import '../widgets/custom_text.dart';

class SetSubresellerPin extends StatefulWidget {
  SetSubresellerPin({
    super.key,
    this.subID,
  });

  String? subID;

  @override
  State<SetSubresellerPin> createState() => _SetSubresellerPinState();
}

class _SetSubresellerPinState extends State<SetSubresellerPin> {
  final ChangePinController setpinController = Get.put(ChangePinController());

  LanguagesController languagesController = Get.put(LanguagesController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
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
          languagesController.tr("SET_PIN"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      key: _scaffoldKey,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => KText(
                            text: languagesController.tr("NEW_PIN"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Pinbox(
                      // hintText: languagesController.tr("ENTER_NEW_PIN"),
                      controller: setpinController.newPinController,
                      length: 4,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        KText(
                          text: languagesController.tr("CONFIRM_PIN"),
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Pinbox(
                      // hintText: languagesController.tr("ENTER_CONFIRM_PIN"),
                      controller: setpinController.confirmPinController,
                      length: 4,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Obx(
                      () => DefaultButton(
                        buttonName: setpinController.isLoading.value == false
                            ? languagesController.tr("CONFIRMATION")
                            : languagesController.tr("PLEASE_WAIT"),
                        onPressed: () {
                          final newPin =
                              setpinController.newPinController.text.trim();
                          final confirmPin =
                              setpinController.confirmPinController.text.trim();

                          if (newPin.isEmpty || confirmPin.isEmpty) {
                            Fluttertoast.showToast(
                              msg:
                                  languagesController.tr("FILL_DATA_CORRECTLY"),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else if (newPin != confirmPin) {
                            Fluttertoast.showToast(
                              msg:
                                  languagesController.tr("DONT_MATCH_BOTH_PIN"),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            setpinController.setpin(widget.subID.toString());
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Text(
                          languagesController
                              .tr("PIN_LENGTH_SHOULD_BE_4_CHARACTER"),
                          style: TextStyle(
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Pinbox extends StatelessWidget {
  Pinbox({
    super.key,
    this.hintText,
    this.controller,
    this.length,
  });

  String? hintText;
  int? length;
  TextEditingController? controller;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.070,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Colors.grey.shade300,
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: TextField(
            maxLength: length,
            controller: controller,
            decoration: InputDecoration(
                counterText: "",
                hintText: hintText,
                border: InputBorder.none,
                suffixIcon: Icon(
                  Icons.visibility_off,
                ),
                hintStyle: TextStyle()),
          ),
        ),
      ),
    );
  }
}
