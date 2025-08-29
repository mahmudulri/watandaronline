import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global controller/languages_controller.dart';

class PaymentButton extends StatelessWidget {
  PaymentButton({
    super.key,
    this.buttonName,
    this.mycolor,
    this.onpressed,
    this.imagelink,
  });

  LanguagesController languagesController = Get.put(LanguagesController());

  String? buttonName;
  String? imagelink;
  Color? mycolor;
  VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 55,
      width: screenWidth,
      child: GestureDetector(
        onTap: onpressed,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),

                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: [
                    //     Colors.white.withOpacity(0.3), // উপরের দিকের হালকা সাদা
                    //     Colors.transparent, // নিচে স্বচ্ছ
                    //   ],
                    // ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            imagelink.toString(),
                            height: 30,
                            color: mycolor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            buttonName.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
