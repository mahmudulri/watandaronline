import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:watandaronline/routes/routes.dart';

import '../controllers/history_controller.dart';
import '../global controller/languages_controller.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({super.key});

  /////////////////////...........fetching Controller ......................//

  final historyController = Get.find<HistoryController>();
  final languagesController = Get.find<LanguagesController>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: screenHeight,
          width: screenWidth,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.grey.withOpacity(0.2), // Color of the shadow
                      spreadRadius: 2, // How much the shadow spreads
                      blurRadius: 5, // The blur radius of the shadow
                      offset: Offset(0, 3), // The offset of the shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 250,
                width: screenWidth,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // print(controller.numberController.text);
                      },
                      child: Image.asset(
                        "assets/images/success.png",
                        height: 100,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      languagesController.tr("SUCCESS"),
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      languagesController.tr("ORDER_CREATED_SUCCESSFULLY"),
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            historyController.finalList.clear();
                            historyController.initialpage = 1;
                            Get.toNamed(bottomnavscreen);
                            // Get.to(() => BottomNavigationbar());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.green,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 40,
                            width: 100,
                            child: Center(
                              child: Text(
                                languagesController.tr("CLOSE"),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
