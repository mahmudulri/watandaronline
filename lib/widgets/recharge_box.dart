import 'package:flutter/material.dart';
import 'package:watandaronline/utils/colors.dart';

class RechargeNumberBox extends StatelessWidget {
  String? hintText;
  final TextEditingController? controller;
  RechargeNumberBox({
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
            keyboardType: TextInputType.phone,
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
