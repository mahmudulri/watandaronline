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
import 'package:watandaronline/routes/routes.dart';
import 'package:watandaronline/screens/add_sub_reseller_screen.dart';
import 'package:watandaronline/services/subreseller_details_service.dart';
import 'package:watandaronline/utils/colors.dart';
import 'package:watandaronline/widgets/auth_textfield.dart';
import 'package:watandaronline/widgets/default_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/commission_group_controller.dart';
import '../controllers/set_commission_group_controller.dart';
import '../global controller/languages_controller.dart';
import '../screens/set_subreseller_pin.dart';
import '../widgets/myprofile_box_widget.dart';
import '../screens/change_balance_screen.dart';
import '../screens/change_sub_pass_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/update_sub_reseller_screen.dart';

class SubResellerScreen extends StatefulWidget {
  SubResellerScreen({super.key});

  @override
  State<SubResellerScreen> createState() => _SubResellerScreenState();
}

class _SubResellerScreenState extends State<SubResellerScreen> {
  final languagesController = Get.find<LanguagesController>();
  final subresellerController = Get.find<SubresellerController>();

  final box = GetStorage();

  TextEditingController searchController = TextEditingController();

  String search = "";

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
            languagesController.tr("SUB_RESELLER"),
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
              Container(
                height: 50,
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
                              hintText: languagesController.tr("SEARCH"),
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
                          Get.toNamed(addsubresellerscreen);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Color(0xff46558A),
                            color: AppColors.defaultColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("ADD_NEW"),
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
              Obx(
                () => subresellerController.isLoading.value == false
                    ? Container(
                        child: subresellerController.allsubresellerData.value
                                .data!.resellers.isNotEmpty
                            ? SizedBox()
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/empty.png",
                                      height: 80,
                                    ),
                                    Text(
                                      languagesController.tr("NO_DATA_FOUND"),
                                    ),
                                  ],
                                ),
                              ),
                      )
                    : SizedBox(),
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
                                .allsubresellerData
                                .value
                                .data!
                                .resellers[index];
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
                              subResellerCommissionGroupId:
                                  data.subResellerCommissionGroupId,
                            );
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(),
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
  String? subResellerCommissionGroupId;

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
    this.subResellerCommissionGroupId,
  });

  @override
  State<dataBoxname> createState() => _dataBoxnameState();
}

class _dataBoxnameState extends State<dataBoxname> {
  final detailsController = Get.find<SubresellerDetailsController>();
  final deleteSubResellerController = Get.find<DeleteSubResellerController>();
  final changeStatusController = Get.find<ChangeStatusController>();
  final languagesController = Get.find<LanguagesController>();

  final commissionlistController = Get.find<CommissionGroupController>();
  SetCommissionGroupController controller =
      Get.put(SetCommissionGroupController());

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
                        height: 300,
                        width: screenWidth - 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                    Text(
                                      widget.status.toString() == "0"
                                          ? languagesController.tr("ACTIVE")
                                          : languagesController.tr("DEACTIVE"),
                                    ),
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
                                    Text(
                                      languagesController.tr("DELETE"),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    builder: (context) {
                                      return Obx(() {
                                        if (commissionlistController
                                            .isLoading.value) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }

                                        final groups = commissionlistController
                                                .allgrouplist
                                                .value
                                                .data
                                                ?.groups ??
                                            [];

                                        return ListView.builder(
                                          itemCount: groups.length,
                                          itemBuilder: (context, index) {
                                            final group = groups[index];
                                            return ListTile(
                                              title:
                                                  Text(group.groupName ?? ''),
                                              subtitle: Text(
                                                  "${group.amount} ${group.commissionType == 'percentage' ? '%' : ''}"),
                                              trailing:
                                                  widget.subResellerCommissionGroupId
                                                              .toString() ==
                                                          group.id.toString()
                                                      ? Icon(Icons.check,
                                                          color: Colors.green)
                                                      : null,
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await controller.setgroup(
                                                    widget.id.toString(),
                                                    group.id.toString());
                                              },
                                            );
                                          },
                                        );
                                      });
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.group),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      languagesController
                                          .tr("SET_COMMISSION_GROUP"),
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
                                  Get.to(() => SetSubresellerPin(
                                        subID: widget.id.toString(),
                                      ));
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.key),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      languagesController.tr("SET_PIN"),
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
                                    Text(
                                      languagesController.tr("SET_PASSWORD"),
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
                                  // Get.toNamed(changebalancescreen, arguments: {
                                  //   "subID": widget.id.toString(),
                                  // });
                                  Get.to(() => ChangeBalanceScreen(
                                        subID: widget.id.toString(),
                                      ));
                                  print(widget.id.toString());
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      languagesController.tr("CHANGE_BALANCE"),
                                    ),
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
                      languagesController.tr("ACTION"),
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
              // avatar
              widget.imagelink != null && widget.imagelink!.isNotEmpty
                  ? Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.imagelink!),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    )
                  : const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),

              const SizedBox(width: 8),

              // NAME + PHONE — let this flex
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.resellerName ?? "-",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.phoneNumber ?? "-",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // BALANCE — cap width and ellipsize
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      languagesController.tr("BALANCE"),
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "${widget.balance ?? ''} ${widget.code ?? ''}".trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // arrow
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_downward_outlined,
                    size: 12,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(width: 10),
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
                                      Text(
                                        languagesController.tr("TODAY_ORDER"),
                                      ),
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
                                      Text(
                                        languagesController.tr("TOTAL_ORDER"),
                                      ),
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
                                      Text(
                                        languagesController.tr("TOTAL_SALE"),
                                      ),
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
                                      Text(
                                        languagesController.tr("TOTAL_PROFIT"),
                                      ),
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
                                      Text(
                                        languagesController.tr("TODAY_SALE"),
                                      ),
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
                                      Text(
                                        languagesController.tr("TODAY_PROFIT"),
                                      ),
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
