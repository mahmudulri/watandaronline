import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:watantelecom/bottom_nav_screen.dart';
import 'package:watantelecom/controllers/bundles_controller.dart';
import 'package:watantelecom/controllers/confirm_pin_controller.dart';
import 'package:watantelecom/controllers/country_list_controller.dart';
import 'package:watantelecom/controllers/dashboard_controller.dart';
import 'package:watantelecom/controllers/place_order_controller.dart';
import 'package:watantelecom/controllers/service_controller.dart';
import 'package:watantelecom/controllers/sub_reseller_controller.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({super.key});

  /////////////////////...........fetching Controller ......................//

  final DashboardController dashboardController =
      Get.put(DashboardController());
  final CountryListController countryListController =
      Get.put(CountryListController());
  final SubresellerController subresellerController =
      Get.put(SubresellerController());

  final ServiceController serviceController = Get.put(ServiceController());

  final BundleController bundleController = Get.put(BundleController());

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
                      "Success",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Order created successfully",
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
                        Container(
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
                              "Print",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // dashboardController.fetchDashboardData();
                            // countryListController.fetchCountryData();
                            // subresellerController.fetchSubReseller();
                            // bundleController.fetchbundles();
                            // serviceController.fetchservices();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavigationbar(),
                              ),
                            );
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
                                "Close",
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
