import 'package:flutter/material.dart';

import '../utils/colors.dart';

class RegisterField extends StatelessWidget {
  String? hintText;
  final TextEditingController? controller;
  RegisterField({
    super.key,
    this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 45,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: AppColors.borderColor,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 10),
        child: Center(
          child: TextField(
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
