import 'package:flutter/material.dart';

import '../utils/colors.dart';

class AddCardWidget extends StatelessWidget {
  String? carName;
  String? imagelink;
  AddCardWidget({super.key, this.carName, this.imagelink});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 60,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.listbuilderboxColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  imagelink.toString(),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              carName.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Color(0xff3D3D3D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
