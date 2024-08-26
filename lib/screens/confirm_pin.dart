import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/place_order_controller.dart';

import '../controllers/confirm_pin_controller.dart';
import 'result_screen.dart';

class ConfirmPinScreen extends StatefulWidget {
  ConfirmPinScreen({super.key});

  @override
  State<ConfirmPinScreen> createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends State<ConfirmPinScreen> {
  final ConfirmPinController confirmPinController =
      Get.put(ConfirmPinController());

  final LanguageController languageController = Get.put(LanguageController());

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Step 2: Request focus when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Don't forget to dispose the FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        confirmPinController.pinController.clear();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            height: screenHeight,
            width: screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Lottie.asset('assets/loties/pin.json'),
                Container(
                  height: 50,
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          confirmPinController.isLoading.value == false
                              ? languageController.alllanguageData.value
                                  .languageData!["CONFIRM_YOUR_PIN"]
                                  .toString()
                              : languageController.alllanguageData.value
                                  .languageData!["PLEASE_WAIT"]
                                  .toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        confirmPinController.isLoading.value == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
                // OTPInput(),
                Container(
                  height: 40,
                  width: 100,
                  // color: Colors.red,
                  child: TextField(
                    focusNode: _focusNode,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    controller: confirmPinController.pinController,
                    maxLength: 4,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      counterText: '',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 15,
                // ),
                // GestureDetector(
                //   onTap: () {},
                //   child: Icon(FontAwesomeIcons.rotateRight),
                // ),

                SizedBox(
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        confirmPinController.pinController.clear();
                      },
                      child: Container(
                        height: 60,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Center(
                            child: Text(
                              languageController
                                  .alllanguageData.value.languageData!["CANCEL"]
                                  .toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () async {
                          if (confirmPinController.isLoading.value == false) {
                            print("pin is...." +
                                confirmPinController.pinController.text
                                    .toString());
                            if (confirmPinController
                                    .pinController.text.isEmpty ||
                                confirmPinController
                                        .pinController.text.length !=
                                    4) {
                              Fluttertoast.showToast(
                                  msg: "Enter your pin",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              await confirmPinController.verify();
                              if (confirmPinController.loadsuccess.value ==
                                  false) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultScreen(),
                                  ),
                                );
                              } else {
                                print("errorBD");
                              }
                            }
                          } else {
                            print("Working");
                          }
                        },
                        child: Obx(
                          () => Container(
                            height: 60,
                            width: 120,
                            decoration: BoxDecoration(
                              color:
                                  confirmPinController.isLoading.value == false
                                      ? Colors.green
                                      : Colors.grey,
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Center(
                                child: Text(
                                  languageController.alllanguageData.value
                                      .languageData!["VERIFY"]
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OTPInput extends StatefulWidget {
  @override
  _OTPInputState createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  // Define controllers and focus nodes for each OTP box
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  final ConfirmPinController confirmPinController =
      Get.put(ConfirmPinController());

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (_) => TextEditingController());
    _focusNodes = List.generate(4, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Function to handle text change and move focus
  void _handleChange(String value, int index) {
    if (value.length == 1) {
      if (index < 3) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    }
    _updatePinController();
  }

  void _updatePinController() {
    String pin = _controllers.map((controller) => controller.text).join();

    confirmPinController.pinController.text = pin;
  }

  // Function to reset all input fields
  void _resetFields() {
    confirmPinController.pinController.clear();
    for (var controller in _controllers) {
      controller.clear();
    }
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return SizedBox(
                width: 50,
                child: TextFormField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _handleChange(value, index),
                ),
              );
            }),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: _resetFields,
            child: Icon(FontAwesomeIcons.rotateRight),
          ),
        ],
      ),
    );
  }
}
