import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watantelecom/controllers/dashboard_controller.dart';
import 'package:watantelecom/utils/colors.dart';
import 'package:watantelecom/widgets/auth_textfield.dart';
import 'package:watantelecom/widgets/default_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/myprofile_box_widget.dart';
import 'edit_profile_screen.dart';

class MyprofileScreen extends StatelessWidget {
  MyprofileScreen({super.key});

  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        title: Text(
          "Personal Info",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       Get.to(() => EditProfileScreen());
        //     },
        //     child: Icon(
        //       FontAwesomeIcons.penToSquare,
        //       color: Colors.black,
        //     ),
        //   ),
        //   SizedBox(
        //     width: 15,
        //   ),
        // ],
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      dashboardController.alldashboardData.value.data!.userInfo!
                          .profileImageUrl
                          .toString(),
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              MyProfileboxwidget(
                boxname: "Name",
                title: dashboardController
                    .alldashboardData.value.data!.userInfo!.resellerName
                    .toString(),
              ),
              SizedBox(
                height: 5,
              ),
              MyProfileboxwidget(
                boxname: "Email",
                title: dashboardController
                    .alldashboardData.value.data!.userInfo!.email
                    .toString(),
              ),
              SizedBox(
                height: 5,
              ),
              MyProfileboxwidget(
                boxname: "Name",
                title: dashboardController
                    .alldashboardData.value.data!.userInfo!.phone
                    .toString(),
              ),
              SizedBox(
                height: 5,
              ),
              MyProfileboxwidget(
                boxname: "Balance",
                title: dashboardController
                    .alldashboardData.value.data!.userInfo!.balance
                    .toString(),
              ),
              SizedBox(
                height: 5,
              ),
              MyProfileboxwidget(
                boxname: "Loan Balance",
                title: dashboardController
                    .alldashboardData.value.data!.userInfo!.loanBalance
                    .toString(),
              ),
              SizedBox(
                height: 5,
              ),
              MyProfileboxwidget(
                boxname: "Total sold amount",
                title: dashboardController
                    .alldashboardData.value.data!.totalSoldAmount
                    .toString(),
              ),
              SizedBox(
                height: 5,
              ),
              MyProfileboxwidget(
                boxname: "Total revenue",
                title: dashboardController
                    .alldashboardData.value.data!.totalRevenue
                    .toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
