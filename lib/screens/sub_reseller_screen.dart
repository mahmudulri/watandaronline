import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/controllers/change_status_controller.dart';
import 'package:watandaronline/controllers/delete_sub_reseller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/sub_reseller_controller.dart';
import 'package:watandaronline/controllers/subreseller_details_controller.dart';
import 'package:watandaronline/screens/add_sub_reseller_screen.dart';
import 'package:watandaronline/services/subreseller_details_service.dart';
import 'package:watandaronline/utils/colors.dart';
import 'package:watandaronline/widgets/auth_textfield.dart';
import 'package:watandaronline/widgets/default_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/myprofile_box_widget.dart';
import 'change_balance_screen.dart';
import 'change_sub_pass_screen.dart';
import 'edit_profile_screen.dart';
import 'update_sub_reseller_screen.dart';

class SubResellerScreen extends StatefulWidget {
  SubResellerScreen({super.key});

  @override
  State<SubResellerScreen> createState() => _SubResellerScreenState();
}

class _SubResellerScreenState extends State<SubResellerScreen> {
  final SubresellerController subresellerController =
      Get.put(SubresellerController());

  final box = GetStorage();

  TextEditingController searchController = TextEditingController();

  String search = "";

  final LanguageController languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    // subresellerController.fetchSubReseller();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            // print(box.read("subresellerID"));
          },
          child: Text(
            languageController
                .alllanguageData.value.languageData!["SUB_RESELLER"]
                .toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
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
                height: 40,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color(0xff46558A),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (String? value) {
                              setState(() {
                                search = value.toString();
                              });
                            },
                            controller: searchController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: languageController
                                  .alllanguageData.value.languageData!["SEARCH"]
                                  .toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddSubResellerScreen(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Color(0xff46558A),
                            color: AppColors.defaultColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "Add New",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: Obx(
                () => subresellerController.isLoading.value == false
                    ? ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: subresellerController
                            .allsubresellerData.value.data!.resellers.length,
                        itemBuilder: (context, index) {
                          final data = subresellerController
                              .allsubresellerData.value.data!.resellers[index];
                          if (searchController.text.isEmpty) {
                            return dataBoxname(
                              wingetName: "wingetName",
                              catID: "catID",
                              resellerName: data.contactName,
                              phoneNumber: data.phone,
                              balance: data.balance,
                              code: data.code,
                              id: data.id.toString(),
                              status: data.status.toString(),
                              imagelink: data.profileImageUrl,
                            );
                          } else if (subresellerController.allsubresellerData
                              .value.data!.resellers[index].resellerName
                              .toString()
                              .toLowerCase()
                              .contains(searchController.text
                                  .toString()
                                  .toLowerCase())) {
                            return dataBoxname(
                              wingetName: "wingetName",
                              catID: "catID",
                              resellerName: data.contactName,
                              phoneNumber: data.phone,
                              balance: data.balance,
                              code: data.code,
                              id: data.id.toString(),
                              status: data.status.toString(),
                              imagelink: data.profileImageUrl,
                            );
                          } else {
                            return Container();
                          }
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class dataBoxname extends StatefulWidget {
  String? wingetName;
  String? catID;
  String? resellerName;
  String? phoneNumber;
  String? balance;
  String? loadbalance;
  String? code;
  String? country;
  String? province;
  String? districts;
  String id;
  String? status;
  String? imagelink;

  dataBoxname({
    super.key,
    this.wingetName,
    this.catID,
    this.resellerName,
    this.phoneNumber,
    this.balance,
    this.loadbalance,
    this.code,
    this.country,
    this.province,
    this.districts,
    required this.id,
    this.status,
    this.imagelink,
  });

  @override
  State<dataBoxname> createState() => _dataBoxnameState();
}

class _dataBoxnameState extends State<dataBoxname> {
  final SubresellerDetailsController detailsController =
      Get.put(SubresellerDetailsController());

  final DeleteSubResellerController deleteSubResellerController =
      Get.put(DeleteSubResellerController());

  final ChangeStatusController changeStatusController =
      Get.put(ChangeStatusController());

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Color of the shadow
              spreadRadius: 4, // How much the shadow spreads
              blurRadius: 5, // The blur radius of the shadow
              offset: Offset(0, 2), // The offset of the shadow
            ),
          ],
        ),
        child: ExpansionTile(
          onExpansionChanged: (bool expanding) {
            setState(() {});
            if (expanding) {
              detailsController.fetchSubResellerDetails(widget.id);
            } else {
              print('ExpansionTile collapsed');
            }
          },

          // backgroundColor: Color(0xff2c3e50),
          backgroundColor: Colors.white,
          // collapsedBackgroundColor: Color(0xff2c3e50),
          collapsedBackgroundColor: Color(0xffecf0f1),
          iconColor: Colors.white,

          trailing: SizedBox(
            height: 40,
            width: 60,
            child: GestureDetector(
              onTap: () {
                box.write("subresellerID", widget.id);
                detailsController.fetchSubResellerDetails(widget.id);
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(0.0),
                      content: Container(
                        height: 180,
                        width: screenWidth - 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              // GestureDetector(
                              //   onTap: () {
                              //     Get.to(() => UpdateSubResellerScreen());
                              //   },
                              //   child: Row(
                              //     children: [
                              //       Icon(Icons.edit),
                              //       SizedBox(
                              //         width: 10,
                              //       ),
                              //       Text("Edit"),
                              //     ],
                              //   ),
                              // ),
                              // Divider(
                              //   thickness: 1,
                              //   color: Colors.grey,
                              // ),
                              GestureDetector(
                                onTap: () {
                                  changeStatusController
                                      .channgestatus(widget.id.toString());
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.ac_unit),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(widget.status.toString() == "0"
                                        ? "Active"
                                        : "Deactive"),
                                    Spacer(),
                                    CircleAvatar(
                                      radius: 8,
                                      backgroundColor:
                                          widget.status.toString() == "0"
                                              ? Colors.grey
                                              : Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                              GestureDetector(
                                onTap: () {
                                  deleteSubResellerController
                                      .deletesub(widget.id.toString());
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Delete"),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => ChangeSubPasswordScreen(
                                        subID: widget.id.toString(),
                                      ));
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.password),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Set Password"),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => ChangeBalanceScreen(
                                        subID: widget.id.toString(),
                                      ));
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Change Balance"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  // color: Color(0xff46558A),
                  color: AppColors.defaultColor,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                    child: Text(
                      "Action",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          tilePadding: EdgeInsets.all(5),
          title: Row(
            children: [
              widget.imagelink != null
                  ? Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.imagelink.toString(),
                          ),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                      ),
                    )
                  : Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: Icon(
                        Icons.person,
                      )),
                    ),
              SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.resellerName.toString(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.phoneNumber.toString(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Balance",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "${widget.balance} ${widget.code}".substring(0, 8),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    size: 15,
                    Icons.arrow_downward_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Divider(
                    indent: 10,
                    endIndent: 10,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  Obx(
                    () => detailsController.isLoading.value == false
                        ? Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text("Today order"),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          // color: Color(0xff46558A),
                                          color: AppColors.defaultColor,
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Center(
                                              child: Text(
                                                detailsController
                                                    .allsubresellerDetailsData
                                                    .value
                                                    .data!
                                                    .reseller!
                                                    .todayOrders
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text("Total order"),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          // color: Color(0xff46558A),
                                          color: AppColors.defaultColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Center(
                                            child: Text(
                                              detailsController
                                                  .allsubresellerDetailsData
                                                  .value
                                                  .data!
                                                  .reseller!
                                                  .totalOrders
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text("Total Sales"),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          // color: Color(0xff46558A),
                                          color: AppColors.defaultColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Center(
                                            child: Text(
                                              detailsController
                                                  .allsubresellerDetailsData
                                                  .value
                                                  .data!
                                                  .reseller!
                                                  .todaySale
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text("Total Profit"),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          // color: Color(0xff46558A),
                                          color: AppColors.defaultColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Center(
                                            child: Text(
                                              detailsController
                                                  .allsubresellerDetailsData
                                                  .value
                                                  .data!
                                                  .reseller!
                                                  .totalProfit
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text("Today Sale"),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          // color: Color(0xff46558A),
                                          color: AppColors.defaultColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Center(
                                            child: Text(
                                              detailsController
                                                  .allsubresellerDetailsData
                                                  .value
                                                  .data!
                                                  .reseller!
                                                  .todaySale
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text("Today Profit"),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          // color: Color(0xff46558A),
                                          color: AppColors.defaultColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Center(
                                            child: Text(
                                              detailsController
                                                  .allsubresellerDetailsData
                                                  .value
                                                  .data!
                                                  .reseller!
                                                  .todayProfit
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : CircularProgressIndicator(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
