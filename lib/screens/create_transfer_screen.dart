import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/widgets/default_button.dart';

import '../controllers/add_selling_price_controller.dart';

import '../controllers/categories_list_controller.dart';
import '../controllers/create_transfer_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/only_service_controller.dart';
import '../global controller/languages_controller.dart';

import '../utils/colors.dart';

import '../widgets/custom_text.dart';
import 'commission_transfer_screen.dart';
import 'selling_price_screen.dart';

class CreateTransferScreen extends StatefulWidget {
  const CreateTransferScreen({super.key});

  @override
  State<CreateTransferScreen> createState() => _CreateTransferScreenState();
}

class _CreateTransferScreenState extends State<CreateTransferScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());

  final dashboardController = Get.find<DashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.amountController.clear();
  }

  CreateTransferController controller = Get.put(CreateTransferController());
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    LanguagesController languagesController = Get.put(LanguagesController());

    final box = GetStorage();

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: Text(
          languagesController.tr("CREATE_TRANSFER_REQUEST"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  color: Color(0xffEEF4FF),
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
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(
                    padding: EdgeInsets.all(0),
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
                      Container(
                        height: 60,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          color: Color(0xffF9FAFB),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  // color: Colors.red,
                                  child: TextField(
                                    keyboardType: TextInputType.phone,
                                    controller: controller.amountController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: Center(
                                    child: Row(
                                      children: [
                                        KText(
                                          text: dashboardController
                                              .alldashboardData
                                              .value
                                              .data!
                                              .userInfo!
                                              .totalearning
                                              .toString(),
                                          fontSize: 16,
                                        ),
                                        Text(" / "),
                                        GestureDetector(
                                          onTap: () {
                                            controller.amountController.text =
                                                dashboardController
                                                    .alldashboardData
                                                    .value
                                                    .data!
                                                    .userInfo!
                                                    .totalearning
                                                    .toString();
                                          },
                                          child: KText(
                                            text: "All",
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Obx(
                        () => DefaultButton(
                          buttonName: controller.isLoading.value == false
                              ? languagesController.tr("CREATE_NOW")
                              : languagesController.tr("PLEASE_WAIT"),
                          onPressed: () {
                            if (controller.amountController.text.isNotEmpty) {
                              controller.createnow();
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
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceBox extends StatelessWidget {
  ServiceBox({super.key});

  final OnlyServiceController serviceController =
      Get.put(OnlyServiceController());

  final categorisListController = Get.find<CategorisListController>();
  AddSellingPriceController addSellingPriceController =
      Get.put(AddSellingPriceController());
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
                            // addSellingPriceController.serviceidcontroller.text =
                            //     data.id.toString();

                            // addSellingPriceController.catName.value =
                            //     categorisListController.allcategorieslist.value
                            //         .data!.servicecategories!
                            //         .firstWhere(
                            //           (cat) =>
                            //               cat.id.toString() ==
                            //               data.serviceCategoryId.toString(),
                            //           orElse: () =>
                            //               Servicecategory(categoryName: ''),
                            //         )
                            //         .categoryName
                            //         .toString();

                            // addSellingPriceController.logolink.value =
                            //     data.company!.companyLogo.toString();

                            // addSellingPriceController.serviceName.value =
                            //     data.company!.companyName.toString();

                            // Navigator.pop(context);
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
                                      // Text(
                                      //   categorisListController
                                      //       .allcategorieslist
                                      //       .value
                                      //       .data!
                                      //       .servicecategories!
                                      //       .firstWhere(
                                      //         (cat) =>
                                      //             cat.id.toString() ==
                                      //             data.serviceCategoryId
                                      //                 .toString(),
                                      //         orElse: () => Servicecategory(
                                      //             categoryName: ''),
                                      //       )
                                      //       .categoryName
                                      //       .toString(),
                                      //   style: TextStyle(
                                      //     fontFamily:
                                      //         box.read("language").toString() ==
                                      //                 "Fa"
                                      //             ? Get.find<FontController>()
                                      //                 .currentFont
                                      //             : null,
                                      //   ),
                                      // ),
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
