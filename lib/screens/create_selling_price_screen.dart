import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/widgets/auth_textfield.dart';
import 'package:watandaronline/widgets/default_button.dart';

import '../controllers/add_selling_price_controller.dart';
import '../controllers/categories_list_controller.dart';
import '../controllers/only_cat_controller.dart';
import '../controllers/only_service_controller.dart';

import '../global controller/languages_controller.dart';
import '../models/categories_service_model.dart';
import '../utils/colors.dart';

class CreateSellingPriceScreen extends StatefulWidget {
  const CreateSellingPriceScreen({super.key});

  @override
  State<CreateSellingPriceScreen> createState() =>
      _CreateSellingPriceScreenState();
}

class _CreateSellingPriceScreenState extends State<CreateSellingPriceScreen> {
  final languagesController = Get.find<LanguagesController>();

  final onlycatController = Get.find<OnlyCatController>();
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
      {
        "name": languagesController.tr("FIXED"),
        "value": "fixed",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    final languagesController = Get.find<LanguagesController>();
    final addSellingPriceController = Get.find<AddSellingPriceController>();
    final serviceController = Get.find<OnlyServiceController>();

    final box = GetStorage();

    return Scaffold(
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
            languagesController.tr("CREATE_SELLING_PRICE"),
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
          child: ListView(
            children: [
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
                hintText: "Enter amount",
                controller: addSellingPriceController.amountController,
              ),
              SizedBox(
                height: 12,
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
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          height: 150,
                          width: screenWidth,
                          color: Colors.white,
                          child: ListView.builder(
                            itemCount: commissiontype.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  addSellingPriceController.commitype.value =
                                      commissiontype[index]["name"];
                                  addSellingPriceController.commissiontype
                                      .value = commissiontype[index]["value"];
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  height: 50,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
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
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            addSellingPriceController.commitype.value
                                .toString(),
                          ),
                        ),
                      ),
                      Icon(
                        FontAwesomeIcons.chevronDown,
                        size: screenHeight * 0.018,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Text(
                    languagesController.tr("SERVICE"),
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
              Row(
                children: [
                  Container(
                    height: 120,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: Obx(
                      () => addSellingPriceController.catName.value != ''
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Image.network(
                                    addSellingPriceController.logolink
                                        .toString(),
                                    height: 50,
                                  ),
                                  Text(
                                    addSellingPriceController.serviceName
                                        .toString(),
                                  ),
                                  Text(
                                    addSellingPriceController.catName
                                        .toString(),
                                  ),
                                ])
                          : SizedBox(
                              child: Text(""),
                            ),
                    )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            insetPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            child: ServiceBox(),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey,
                      child: Center(
                        child: Icon(
                          FontAwesomeIcons.chevronDown,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Obx(
                () => DefaultButton(
                  buttonName: addSellingPriceController.isLoading.value == false
                      ? languagesController.tr("CREATE_NOW")
                      : languagesController.tr("PLEASE_WAIT"),
                  onPressed: () {
                    if (addSellingPriceController
                            .amountController.text.isNotEmpty &&
                        addSellingPriceController.commissiontype.value != "" &&
                        addSellingPriceController
                            .serviceidcontroller.text.isNotEmpty) {
                      addSellingPriceController.createnow();
                    } else {
                      Fluttertoast.showToast(
                          msg: "Fill data",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceBox extends StatelessWidget {
  ServiceBox({super.key});

  final onlycatController = Get.find<OnlyCatController>();

  final serviceController = Get.find<OnlyServiceController>();

  final addSellingPriceController = Get.find<AddSellingPriceController>();

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Container(
        height: 500,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => serviceController.isLoading.value == false
                ? GridView.builder(
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: serviceController
                        .allservices.value.data!.services.length,
                    itemBuilder: (context, index) {
                      final data = serviceController
                          .allservices.value.data!.services[index];
                      return Padding(
                        padding: EdgeInsets.all(3.0),
                        child: GestureDetector(
                          onTap: () {
                            addSellingPriceController.serviceidcontroller.text =
                                data.id.toString();

                            addSellingPriceController.catName.value =
                                onlycatController.onlycategorieslist.value.data!
                                    .servicecategories
                                    .firstWhere(
                                      (cat) =>
                                          cat.id.toString() ==
                                          data.serviceCategoryId.toString(),
                                      orElse: () =>
                                          Servicecategory(categoryName: ''),
                                    )
                                    .categoryName
                                    .toString();

                            addSellingPriceController.logolink.value =
                                data.company!.companyLogo.toString();

                            addSellingPriceController.serviceName.value =
                                data.company!.companyName.toString();

                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          data.company!.companyLogo.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        data.company!.companyName.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      // Text(data.serviceCategoryId.toString()),
                                      Text(
                                        onlycatController.onlycategorieslist
                                            .value.data!.servicecategories!
                                            .firstWhere(
                                              (cat) =>
                                                  cat.id.toString() ==
                                                  data.serviceCategoryId
                                                      .toString(),
                                              orElse: () => Servicecategory(
                                                  categoryName: ''),
                                            )
                                            .categoryName
                                            .toString(),
                                        style: TextStyle(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
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
      ),
    );
  }
}
