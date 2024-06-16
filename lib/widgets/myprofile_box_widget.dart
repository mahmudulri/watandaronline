import 'package:flutter/material.dart';

import '../utils/colors.dart';

class MyProfileboxwidget extends StatelessWidget {
  String? boxname;
  String? title;
  MyProfileboxwidget({super.key, this.boxname, this.title});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 55,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.listbuilderboxColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              boxname.toString(),
              style: TextStyle(
                color: Color(0xff838383),
                fontSize: 13,
              ),
            ),
            Text(
              title.toString(),
              style: TextStyle(
                color: Color(0xff000000),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
