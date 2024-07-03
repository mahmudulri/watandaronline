import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watantelecom/controllers/dashboard_controller.dart';
import 'package:watantelecom/controllers/iso_code_controller.dart';
import 'package:watantelecom/controllers/language_controller.dart';
import 'package:watantelecom/controllers/sign_in_controller.dart';
import 'package:watantelecom/screens/add_card_screen.dart';
import 'package:watantelecom/screens/myprofile_screen.dart';
import 'package:watantelecom/screens/sign_in_screen.dart';
import 'package:watantelecom/screens/sub_reseller_screen.dart';
import 'package:watantelecom/utils/colors.dart';
import 'package:watantelecom/widgets/profile_menu_widget.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});

  final box = GetStorage();

  final DashboardController dashboardController =
      Get.put(DashboardController());

  final SignInController signInController = Get.put(SignInController());

  final IscoCodeController iscoCodeController = Get.put(IscoCodeController());

  final LanguageController languageController = Get.put(LanguageController());

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
              languageController.alllanguageData.value.languageData!["PROFILE"]
                  .toString(),
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
              itemName: languageController
                  .alllanguageData.value.languageData!["PERSONAL_INFO"]
                  .toString(),
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
              itemName: languageController
                  .alllanguageData.value.languageData!["SUB_RESELLER"]
                  .toString(),
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
              itemName: languageController
                  .alllanguageData.value.languageData!["TERMS_AND_CONDITIONS"]
                  .toString(),
              imageLink: "assets/icons/terms.png",
              onPressed: () {},
            ),
            SizedBox(
              height: 5,
            ),
            ProfileMenuWidget(
              itemName: languageController
                  .alllanguageData.value.languageData!["HELP"]
                  .toString(),
              imageLink: "assets/icons/help.png",
              onPressed: () {},
            ),
            ProfileMenuWidget(
              itemName: languageController
                  .alllanguageData.value.languageData!["CHANGE_LANGUAGE"]
                  .toString(),
              imageLink: "assets/icons/globe.png",
              onPressed: () {
                iscoCodeController.fetchisoCode();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      // contentPadding: EdgeInsets.all(0.0),
                      content: Container(
                        height: 300,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                                child: Obx(
                              () => iscoCodeController.isLoading.value == false
                                  ? ListView.builder(
                                      itemCount: iscoCodeController
                                          .allisoCodeData
                                          .value
                                          .data!
                                          .languages
                                          .length,
                                      itemBuilder: (context, index) {
                                        final data = iscoCodeController
                                            .allisoCodeData
                                            .value
                                            .data!
                                            .languages[index];
                                        return languageBox(
                                          lanName: data.languageName,
                                          onpressed: () {
                                            print(data.language_code);
                                            languageController.fetchlanData(
                                                data.language_code.toString());
                                            box.write("isoCode",
                                                data.language_code.toString());
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    ),
                            )),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(
              height: 5,
            ),
            ProfileMenuWidget(
              itemName: languageController
                  .alllanguageData.value.languageData!["LOG_OUT"]
                  .toString(),
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
                              languageController.alllanguageData.value
                                  .languageData!["DO_YOU_WANT_TO_LOGOUT"]
                                  .toString(),
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignInScreen(),
                                      ),
                                    );

                                    signInController.usernameController.clear();
                                    signInController.passwordController.clear();

                                    box.remove("userToken");
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: AppColors.borderColor,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Center(
                                      child: Text(
                                        languageController.alllanguageData.value
                                            .languageData!["YES"]
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: AppColors.borderColor,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Center(
                                      child: Text(
                                        languageController.alllanguageData.value
                                            .languageData!["NO"]
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
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

class languageBox extends StatelessWidget {
  const languageBox({
    super.key,
    this.lanName,
    this.onpressed,
  });
  final String? lanName;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: GestureDetector(
        onTap: onpressed,
        child: Container(
          margin: EdgeInsets.only(bottom: 6),
          height: 40,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
              child: Text(
            lanName.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          )),
        ),
      ),
    );
  }
}
