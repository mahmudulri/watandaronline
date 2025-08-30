import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../utils/colors.dart';

class ProfileMenuWidget extends StatelessWidget {
  String? itemName;
  String? imageLink;
  final VoidCallback? onPressed;
  ProfileMenuWidget({super.key, this.itemName, this.imageLink, this.onPressed});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 42,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.asset(
                imageLink.toString(),
                height: 26,
                color: AppColors.defaultColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                itemName.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeButton extends StatefulWidget {
  String? itemName;
  String? imageLink;

  ThemeButton({
    super.key,
    this.itemName,
    this.imageLink,
  });

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 45,
      width: screenWidth,
      decoration: BoxDecoration(
        color: AppColors.socialButtonColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Image.asset(
              widget.imageLink.toString(),
              height: 24,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              widget.itemName.toString(),
              style: TextStyle(
                fontSize: 15,
                color: AppColors.borderColor,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3),
              child: FlutterSwitch(
                width: 125.0,
                height: 55.0,
                valueFontSize: 18.0,
                toggleSize: 45.0,
                value: status,
                borderRadius: 16.0,
                padding: 8.0,
                activeColor: Colors.black,
                inactiveText: "Light",
                activeText: "Dark",
                showOnOff: true,
                onToggle: (val) {
                  setState(() {
                    status = val;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
