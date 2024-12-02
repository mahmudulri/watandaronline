import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watandaronline/utils/colors.dart';

class DefaultButton extends StatelessWidget {
  String? buttonName;
  final VoidCallback? onPressed;
  DefaultButton({
    super.key,
    this.buttonName,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 45,
        width: screenWidth,
        decoration: BoxDecoration(
          color: AppColors.defaultColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            buttonName.toString(),
            style: TextStyle(
              color: Color(0xffFFFFFF),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
