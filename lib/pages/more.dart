import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watandaronline/controllers/dashboard_controller.dart';
import 'package:watandaronline/utils/colors.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../bottom_nav_screen.dart';
import '../controllers/page_controller.dart';
import '../screens/add_card_screen.dart';
import '../screens/change_pin.dart';
import '../screens/myprofile_screen.dart';
import '../screens/sub_reseller_screen.dart';
import '../widgets/profile_menu_widget.dart';

class MorePage extends StatelessWidget {
  MorePage({super.key});

  // MyPageController myPageController = Get.put(MyPageController());

  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
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
                        dashboardController.alldashboardData.value.data!
                            .userInfo!.profileImageUrl
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
                  dashboardController
                      .alldashboardData.value.data!.userInfo!.email
                      .toString(),
                  style: GoogleFonts.rubik(
                    color: AppColors.borderColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
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
                  itemName: "Change Pin",
                  imageLink: "assets/icons/change_password.png",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePin(),
                      ),
                    );
                  },
                ),

                // SizedBox(
                //   height: 5,
                // ),
                // ProfileMenuWidget(
                //   itemName: "Change Pin",
                //   imageLink: "assets/icons/change_password.png",
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => ChangePassword(),
                //       ),
                //     );
                //   },
                // ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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

                // SizedBox(
                //   height: 5,
                // ),
                // ThemeButton(
                //   itemName: "Theme",
                //   imageLink: "assets/icons/theme.png",
                // ),
              ],
            ),
          ),
        ));
  }
}
