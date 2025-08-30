import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watandaronline/controllers/dashboard_controller.dart';
import 'package:watandaronline/controllers/history_controller.dart';
import 'package:watandaronline/controllers/iso_code_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/sign_in_controller.dart';
import 'package:watandaronline/routes/routes.dart';
import 'package:watandaronline/screens/add_card_screen.dart';
import 'package:watandaronline/screens/myprofile_screen.dart';
import 'package:watandaronline/screens/sign_in_screen.dart';
import 'package:watandaronline/pages/sub_reseller_screen.dart';
import 'package:watandaronline/utils/colors.dart';
import 'package:watandaronline/widgets/profile_menu_widget.dart';

import '../global controller/languages_controller.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final box = GetStorage();

  // final SignInController signInController = Get.put(SignInController());

  // final IscoCodeController iscoCodeController = Get.put(IscoCodeController());

  // final LanguageController languageController = Get.put(LanguageController());

  // final HistoryController historyController = Get.put(HistoryController());

  final signInController = Get.find<SignInController>();
  final iscoCodeController = Get.find<IscoCodeController>();
  final languagesController = Get.find<LanguagesController>();
  final historyController = Get.find<HistoryController>();
  final dashboardController = Get.find<DashboardController>();

  whatsapp() async {
    var contact = "+93773735557";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      print("not found");
    }
  }

  bool isvisible = false;

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
          child: Obx(
            () => dashboardController.isLoading.value == false
                ? Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        languagesController.tr("PROFILE"),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      dashboardController.alldashboardData.value.data!.userInfo!
                                  .profileImageUrl !=
                              null
                          ? Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 4,
                                  color: AppColors.defaultColor,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    dashboardController.alldashboardData.value
                                        .data!.userInfo!.profileImageUrl
                                        .toString(),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                              ),
                            )
                          : Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 100,
                                ),
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
                      Divider(
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.grey,
                      ),
                      ProfileMenuWidget(
                        itemName: languagesController.tr("PERSONAL_INFO"),
                        imageLink: "assets/icons/homeicon.png",
                        onPressed: () {
                          Get.toNamed(myprofilescreen);
                        },
                      ),
                      ProfileMenuWidget(
                        itemName: languagesController.tr("SET_SALE_PRICE"),
                        imageLink: "assets/icons/set_sell_price.png",
                        onPressed: () {
                          Get.toNamed(sellingpricescreen);
                        },
                      ),
                      ProfileMenuWidget(
                        itemName: languagesController.tr("COMMISSION_GROUP"),
                        imageLink: "assets/icons/set_vendor_sell_price.png",
                        onPressed: () {
                          Get.toNamed(commissiongroupscreen);
                        },
                      ),
                      ProfileMenuWidget(
                        itemName: languagesController.tr("CHANGE_PIN"),
                        imageLink: "assets/icons/key.png",
                        onPressed: () {
                          Get.toNamed(changepinscreen);
                        },
                      ),
                      ProfileMenuWidget(
                        itemName: languagesController.tr("CHANGE_PASSWORD"),
                        imageLink: "assets/icons/help.png",
                        onPressed: () {
                          Get.toNamed(changepasswordScreen);
                        },
                      ),
                      ProfileMenuWidget(
                        itemName: languagesController.tr("HELP"),
                        imageLink: "assets/icons/help.png",
                        onPressed: () {
                          Get.toNamed(helpscreen);
                        },
                      ),
                      ProfileMenuWidget(
                        itemName: languagesController.tr("CONTACTUS"),
                        imageLink: "assets/icons/support.png",
                        onPressed: () {
                          whatsapp();
                        },
                      ),
                      ProfileMenuWidget(
                        itemName: languagesController.tr("CHANGE_LANGUAGE"),
                        imageLink: "assets/icons/globe.png",
                        onPressed: () {
                          // historyController.finalList.clear();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    languagesController.tr("CHANGE_LANGUAGE")),
                                content: Container(
                                  height: 350,
                                  width: screenWidth,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: languagesController
                                        .alllanguagedata.length,
                                    itemBuilder: (context, index) {
                                      final data = languagesController
                                          .alllanguagedata[index];
                                      return GestureDetector(
                                        onTap: () {
                                          languagesController.changeLanguage(
                                              data["name"].toString());
                                          box.write("language", data["name"]);
                                          if (data["direction"].toString() ==
                                              "ltr") {
                                            box.write("direction", "ltr");
                                            setState(() {
                                              EasyLocalization.of(context)!
                                                  .setLocale(
                                                      Locale('en', 'US'));
                                            });
                                            print(
                                                "LRT Mode.....................");
                                          } else {
                                            box.write("direction", "rtl");
                                            setState(() {
                                              EasyLocalization.of(context)!
                                                  .setLocale(
                                                      Locale('ar', 'AE'));
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          height: 45,
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.grey.shade100,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    languagesController
                                                        .alllanguagedata[index]
                                                            ["fullname"]
                                                        .toString(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Visibility(
                        visible: isvisible,
                        child: Container(
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Text(
                                languagesController.tr("DO_YOU_WANT_TO_LOGOUT"),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      historyController.finalList.clear();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SignInScreen();
                                          },
                                        ),
                                      );

                                      signInController.usernameController
                                          .clear();
                                      signInController.passwordController
                                          .clear();

                                      box.remove("userToken");
                                      signInController.loginsuccess.value =
                                          true;

                                      //...........................
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Center(
                                        child: Text(
                                          languagesController.tr("YES"),
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
                                      setState(() {
                                        isvisible = !isvisible;
                                      });
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
                                          languagesController.tr("NO"),
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
                      ),
                      ProfileMenuWidget(
                        itemName: languagesController.tr("LOG_OUT"),
                        imageLink: "assets/icons/logout.png",
                        onPressed: () {
                          setState(() {
                            isvisible = !isvisible;
                          });
                          // historyController.finalList.clear();

                          // showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return AlertDialog(
                          //       content: Container(
                          //         height: 140,
                          //         width: screenWidth,
                          //         decoration: BoxDecoration(
                          //           color: Colors.white,
                          //         ),
                          //         child: Column(
                          //           children: [
                          //             Text(
                          //               languageController
                          //                   .alllanguageData
                          //                   .value
                          //                   .languageData![
                          //                       "DO_YOU_WANT_TO_LOGOUT"]
                          //                   .toString(),
                          //               style: TextStyle(
                          //                 fontSize: 17,
                          //                 fontWeight: FontWeight.w600,
                          //               ),
                          //             ),
                          //             SizedBox(
                          //               height: 40,
                          //             ),
                          //             Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 GestureDetector(
                          //                   onTap: () {
                          //                     historyController.finalList
                          //                         .clear();
                          //                     Navigator.push(
                          //                       context,
                          //                       MaterialPageRoute(
                          //                         builder: (context) {
                          //                           return SignInScreen();
                          //                         },
                          //                       ),
                          //                     );

                          //                     signInController
                          //                         .usernameController
                          //                         .clear();
                          //                     signInController
                          //                         .passwordController
                          //                         .clear();

                          //                     box.remove("userToken");
                          //                     signInController
                          //                         .loginsuccess.value = true;

                          //                     //...........................
                          //                   },
                          //                   child: Container(
                          //                     height: 40,
                          //                     width: 100,
                          //                     decoration: BoxDecoration(
                          //                       color: AppColors.borderColor,
                          //                       borderRadius:
                          //                           BorderRadius.circular(7),
                          //                     ),
                          //                     child: Center(
                          //                       child: Text(
                          //                         languageController
                          //                             .alllanguageData
                          //                             .value
                          //                             .languageData!["YES"]
                          //                             .toString(),
                          //                         style: TextStyle(
                          //                           color: Colors.white,
                          //                           fontWeight: FontWeight.w500,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 GestureDetector(
                          //                   onTap: () {
                          //                     Navigator.of(context).pop();
                          //                   },
                          //                   child: Container(
                          //                     height: 40,
                          //                     width: 100,
                          //                     decoration: BoxDecoration(
                          //                       color: AppColors.borderColor,
                          //                       borderRadius:
                          //                           BorderRadius.circular(7),
                          //                     ),
                          //                     child: Center(
                          //                       child: Text(
                          //                         languageController
                          //                             .alllanguageData
                          //                             .value
                          //                             .languageData!["NO"]
                          //                             .toString(),
                          //                         style: TextStyle(
                          //                           color: Colors.white,
                          //                           fontWeight: FontWeight.w500,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // );

                          // box.remove("userToken");
                        },
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: AppColors.defaultColor,
                    ),
                  ),
          )),
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
