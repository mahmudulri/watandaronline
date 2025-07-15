import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/widgets/auth_textfield.dart';

import '../controllers/add_commsion_group_controller.dart';
import '../controllers/commission_group_controller.dart';
import '../global controller/languages_controller.dart';

import '../utils/colors.dart';

class CommissionGroupScreen extends StatefulWidget {
  CommissionGroupScreen({super.key});

  @override
  State<CommissionGroupScreen> createState() => _CommissionGroupScreenState();
}

class _CommissionGroupScreenState extends State<CommissionGroupScreen> {
  final box = GetStorage();

  final languagesController = Get.find<LanguagesController>();

  final commissionlistController = Get.find<CommissionGroupController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commissionlistController.fetchGrouplist();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: GestureDetector(
          onTap: () {},
          child: Text(
            languagesController.tr("COMMISSION_GROUP"),
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
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                height: 50,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: languagesController.tr("SEARCH"),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenHeight * 0.020,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                content: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: CreateGroupBox()),
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.defaultColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("CREATE_NEW"),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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
                height: 10,
              ),
              Expanded(
                child: Obx(
                  () => commissionlistController.isLoading.value == false
                      ? ListView.separated(
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 5,
                            );
                          },
                          itemCount: commissionlistController
                              .allgrouplist.value.data!.groups!.length,
                          itemBuilder: (context, index) {
                            final data = commissionlistController
                                .allgrouplist.value.data!.groups![index];
                            return Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr("GROUP_NAME"),
                                          style: TextStyle(),
                                        ),
                                        Text(
                                          data.groupName.toString(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr("AMOUNT"),
                                          style: TextStyle(),
                                        ),
                                        Text(
                                          data.amount.toString(),
                                          style: TextStyle(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController
                                              .tr("COMMISSION_TYPE"),
                                          style: TextStyle(),
                                        ),
                                        Text(
                                          data.commissionType.toString() ==
                                                  "percentage"
                                              ? languagesController
                                                  .tr("PERCENTAGE")
                                              : "",
                                          style: TextStyle(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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

class CreateGroupBox extends StatefulWidget {
  CreateGroupBox({super.key});

  @override
  State<CreateGroupBox> createState() => _CreateGroupBoxState();
}

class _CreateGroupBoxState extends State<CreateGroupBox> {
  final box = GetStorage();

  final addCommsionGroupController = Get.find<AddCommsionGroupController>();

  List commissiontype = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    commissiontype = [
      {
        "name": languagesController.tr("PERCENTAGE"),
        "value": "percentage",
      },
    ];
  }

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 400,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Text(
                  languagesController.tr("GROUP_NAME"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            AuthTextField(
              hintText: languagesController.tr("ENTER_GROUP_NAME"),
              controller: addCommsionGroupController.nameController,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  languagesController.tr("COMMISSION_TYPE"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          height: 180,
                          width: screenWidth,
                          color: Colors.white,
                          child: ListView.builder(
                            itemCount: commissiontype.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  addCommsionGroupController.commitype.value =
                                      commissiontype[index]["name"];
                                  addCommsionGroupController.commissiontype
                                      .value = commissiontype[index]["value"];
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  height: 50,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Center(
                                      child: Text(
                                        commissiontype[index]["name"],
                                      ),
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
                child: Row(
                  children: [
                    Expanded(
                        child: Obx(
                      () => Text(
                        addCommsionGroupController.commitype.value.toString(),
                      ),
                    )),
                    CircleAvatar(
                      backgroundColor: AppColors.defaultColor.withOpacity(0.7),
                      radius: 18,
                      child: Icon(
                        FontAwesomeIcons.chevronDown,
                        color: Colors.white,
                        size: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  languagesController.tr("AMOUNT"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            AuthTextField(
              hintText: languagesController.tr("ENTER_AMOUNT_OR_VALUE"),
              controller: addCommsionGroupController.amountController,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 50,
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        addCommsionGroupController.amountController.clear();
                        addCommsionGroupController.nameController.clear();
                        addCommsionGroupController.commissiontype.value = "";
                        addCommsionGroupController.commitype.value = "";
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            languagesController.tr("CANCEL"),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        if (addCommsionGroupController
                                .nameController.text.isNotEmpty &&
                            addCommsionGroupController
                                .amountController.text.isNotEmpty &&
                            addCommsionGroupController.commissiontype.value !=
                                "") {
                          addCommsionGroupController.createnow();
                          print(" filled");
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  languagesController.tr("FILL_DATA_CORRECTLY"),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                            child: Obx(
                          () => Text(
                            addCommsionGroupController.isLoading.value == false
                                ? languagesController.tr("CREATE_NOW")
                                : languagesController.tr("PLEASE_WAIT"),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
