import 'package:flutter/material.dart';

import '../utils/colors.dart';

class AuthTextField extends StatelessWidget {
  String? hintText;
  final TextEditingController? controller;
  AuthTextField({
    super.key,
    this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 55,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
          color: AppColors.borderColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Center(
          child: TextField(
            keyboardType: hintText == "Enter your amount"
                ? TextInputType.phone
                : TextInputType.name,
            controller: controller,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                )),
          ),
        ),
      ),
    );
  }
}
