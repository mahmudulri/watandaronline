import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watantelecom/utils/colors.dart';

class SocialButton extends StatelessWidget {
  String? buttonName;
  String? imageLink;
  final VoidCallback? onPressed;
  SocialButton({
    super.key,
    this.buttonName,
    this.onPressed,
    this.imageLink,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.socialButtonColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(imageLink.toString()),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              buttonName.toString(),
              style: TextStyle(
                color: Color(0xff000000),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
