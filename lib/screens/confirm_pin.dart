import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:watantelecom/controllers/place_order_controller.dart';

import '../controllers/confirm_pin_controller.dart';

class ConfirmPinScreen extends StatelessWidget {
  ConfirmPinScreen({super.key});

  final ConfirmPinController confirmPinController =
      Get.put(ConfirmPinController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset('assets/loties/pin.json'),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      confirmPinController.isLoading.value == false
                          ? "Confirm Your Pin"
                          : "Please wait...",
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
              OTPInput(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.pop(context);
                      print(confirmPinController.numberController.text);
                    },
                    child: Container(
                      height: 35,
                      width: 80,
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
                            "Cancel",
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
                    onTap: () {
                      if (confirmPinController.pinController.text.isEmpty ||
                          confirmPinController.pinController.text.length != 4) {
                        Fluttertoast.showToast(
                            msg: "Enter your pin",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        confirmPinController.verify();
                        // orderController.placeOrder();
                        // print(controller.pinController.text);
                        // ignore: unrelated_type_equality_checks
                        // if (controller.getresult == false) {
                        //   orderController.placeOrder();
                        // } else {
                        //   print("success");
                        // }
                      }
                    },
                    child: Container(
                      height: 35,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.green,
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
                            "Verify",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
              onTap: _resetFields, child: Icon(FontAwesomeIcons.rotateRight)),
        ],
      ),
    );
  }
}
