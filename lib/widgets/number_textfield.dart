import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class PasteRestrictionFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Check if new value comes from pasting
    if (newValue.text.length > oldValue.text.length) {
      // Try parsing the new value to an integer
      if (int.tryParse(newValue.text) == null) {
        // If it's not an integer, return the old value (block paste)
        return oldValue;
      }
    }
    // If it's an integer, allow the update
    return newValue;
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController confirmPinController;
  final String numberLength;
  // final ValueNotifier<Map<String, String>> languageData;
  final String languageData;

  const CustomTextField({
    required this.confirmPinController,
    required this.numberLength,
    required this.languageData,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
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
          maxLength: int.parse(numberLength),
          style: TextStyle(color: Colors.white),
          controller: confirmPinController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            PasteRestrictionFormatter(), // Custom formatter to restrict paste
            FilteringTextInputFormatter.digitsOnly, // Allow digits only
          ],
          decoration: InputDecoration(
            counterText: "",
            border: InputBorder.none,
            hintText: languageData,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
