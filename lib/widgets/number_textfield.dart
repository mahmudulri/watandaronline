import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/controllers/reserve_digit_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';
import 'package:watandaronline/helpers/language_helper.dart';

class PasteRestrictionFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Check if new value comes from pasting
    if (newValue.text.length > oldValue.text.length) {
      // Try parsing the new value to an integer
      if (int.tryParse(newValue.text) == null) {
        // If it's not an integer, return the old value (block paste)
        Get.snackbar(
          "Error",
          "Only allow english number format",
          colorText: Colors.white,
          duration: Duration(
            milliseconds: 1000,
          ),
          backgroundColor: Colors.black,
        );
        return oldValue;
      }
    }

    return newValue;
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController confirmPinController;

  final String languageData;

  CustomTextField({
    required this.confirmPinController,
    required this.languageData,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final box = GetStorage();

  final ServiceController serviceController = Get.put(ServiceController());

  final ReserveDigitController reserveDigitController =
      Get.put(ReserveDigitController());

  String? errorMessage;

  void validateInput(String input) {
    // Check if the input starts with any of the reserved digits from the controller
    bool isValid =
        serviceController.reserveDigit.any((digit) => input.startsWith(digit));

    // if (!isValid) {
    //   setState(() {
    //     errorMessage = 'Please enter a correct number!';
    //     box.write("permission", "no");
    //   });
    // } else {
    //   setState(() {
    //     box.write("permission", "yes");
    //     errorMessage = null; // Clear error when valid
    //   });
    // }

    if (!isValid) {
      setState(() {
        errorMessage = getText("PLEASE_ENTER_A_CORRECT_NUMBER",
                defaultValue: "Please enter a correct") +
            " ${box.read("maxlength")} " +
            getText("DIGIT", defaultValue: "digit") +
            " " +
            getText("NUMBER", defaultValue: "Number");

        // errorMessage =
        //     'Please enter a correct ${box.read("maxlength")} digit ${reserveDigitController.companyName} number!';
        box.write("permission", "no");
      });
    } else {
      setState(() {
        box.write("permission", "yes");
        errorMessage = null; // Clear error when valid
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: 50,
          width: screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1,
              color: Colors.white,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              maxLength: int.parse(box.read("maxlength")),
              style: TextStyle(color: Colors.white),
              controller: widget.confirmPinController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                PasteRestrictionFormatter(), // Custom formatter to restrict paste
                FilteringTextInputFormatter.digitsOnly, // Allow digits only
              ],
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                hintText: widget.languageData,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              onChanged: (value) {
                validateInput(value);
              },
            ),
          ),
        ),
        if (errorMessage != null)
          Text(
            errorMessage!,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
      ],
    );
  }
}
