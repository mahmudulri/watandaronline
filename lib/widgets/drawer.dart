import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watantelecom/controllers/dashboard_controller.dart';
import 'package:watantelecom/screens/add_card_screen.dart';
import 'package:watantelecom/screens/myprofile_screen.dart';
import 'package:watantelecom/screens/sub_reseller_screen.dart';
import 'package:watantelecom/utils/colors.dart';
import 'package:watantelecom/widgets/profile_menu_widget.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});

  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      height: screenHeight,
      width: screenWidth - 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              "My Profile",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    dashboardController
                        .alldashboardData.value.data!.userInfo!.profileImageUrl
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
            Text(
              dashboardController
                  .alldashboardData.value.data!.userInfo!.resellerName
                  .toString(),
              style: GoogleFonts.rubik(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              dashboardController.alldashboardData.value.data!.userInfo!.email
                  .toString(),
              style: GoogleFonts.rubik(
                color: AppColors.borderColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Divider(
              thickness: 1,
              indent: 10,
              endIndent: 10,
              color: Colors.grey,
            ),
            SizedBox(
              height: 15,
            ),
            ProfileMenuWidget(
              itemName: "Personal info",
              imageLink: "assets/icons/homeicon.png",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyprofileScreen(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 5,
            ),
            ProfileMenuWidget(
              itemName: "Add card",
              imageLink: "assets/icons/add_card.png",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCardScreen(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 5,
            ),
            ProfileMenuWidget(
              itemName: "Sub reseller",
              imageLink: "assets/icons/sub_reseller.png",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubResellerScreen(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 5,
            ),
            ProfileMenuWidget(
              itemName: "Terms & conditions",
              imageLink: "assets/icons/terms.png",
              onPressed: () {},
            ),
            SizedBox(
              height: 5,
            ),
            ProfileMenuWidget(
              itemName: "Help",
              imageLink: "assets/icons/help.png",
              onPressed: () {},
            ),
            SizedBox(
              height: 5,
            ),
            ProfileMenuWidget(
              itemName: "Logout",
              imageLink: "assets/icons/logout.png",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        height: 140,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Do you want to Logout",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.borderColor,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.borderColor,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
