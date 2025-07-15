import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/categories_list_controller.dart';

import '../controllers/delete_selling_price_controller.dart';
import '../controllers/only_cat_controller.dart';
import '../controllers/only_service_controller.dart';
import '../controllers/selling_price_controller.dart';

import '../global controller/languages_controller.dart';
import '../models/categories_service_model.dart';
import '../routes/routes.dart';
import '../utils/colors.dart';

class SellingPriceScreen extends StatefulWidget {
  SellingPriceScreen({super.key});

  @override
  State<SellingPriceScreen> createState() => _SellingPriceScreenState();
}

class _SellingPriceScreenState extends State<SellingPriceScreen> {
  final languagesController = Get.find<LanguagesController>();

  final sellingPriceController = Get.find<SellingPriceController>();

  final box = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onlycatController.fetchcategories();
    sellingPriceController.fetchpriceData();
    serviceController.fetchservices();
  }

  // final categorisListController = Get.find<CategorisListController>();
  final onlycatController = Get.find<OnlyCatController>();
  final serviceController = Get.find<OnlyServiceController>();

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
          onTap: () {
            onlycatController.fetchcategories();
          },
          child: Text(
            languagesController.tr("SELLING_PRICE_2"),
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
        decoration: BoxDecoration(),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          Get.toNamed(createsellingpricescreen);
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
              Obx(
                () => sellingPriceController.isLoading.value == false &&
                        serviceController.isLoading.value == false &&
                        onlycatController.isLoading.value == false
                    ? Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: sellingPriceController
                              .allpricelist.value.data!.pricings!.length,
                          itemBuilder: (context, index) {
                            final data = sellingPriceController
                                .allpricelist.value.data!.pricings![index];
                            return Container(
                              width: screenWidth,
                              margin: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            serviceController.allservices.value
                                                .data!.services
                                                .firstWhere(
                                                  (srvs) =>
                                                      srvs.id.toString() ==
                                                      data.serviceId.toString(),
                                                )
                                                .company!
                                                .companyLogo
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                serviceController.allservices
                                                    .value.data!.services
                                                    .firstWhere(
                                                      (srvs) =>
                                                          srvs.id.toString() ==
                                                          data.serviceId
                                                              .toString(),
                                                    )
                                                    .company!
                                                    .companyName
                                                    .toString(),
                                              ),
                                              Text(
                                                onlycatController
                                                    .onlycategorieslist
                                                    .value
                                                    .data!
                                                    .servicecategories
                                                    .firstWhere(
                                                      (cat) =>
                                                          cat.id.toString() ==
                                                          data.service!
                                                              .serviceCategoryId
                                                              .toString(),
                                                      orElse: () =>
                                                          Servicecategory(
                                                              categoryName:
                                                                  'null'),
                                                    )
                                                    .categoryName
                                                    .toString(),
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
                                              ),
                                              Text(
                                                data.commissionType
                                                            .toString() ==
                                                        "percentage"
                                                    ? languagesController
                                                        .tr("PERCENTAGE")
                                                    : languagesController
                                                        .tr("FIXED"),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languagesController
                                                    .tr("AMOUNT"),
                                                style: TextStyle(),
                                              ),
                                              Text(
                                                data.amount.toString(),
                                                style: TextStyle(),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: DeleteDialog(
                                                priceID: data.id.toString(),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  DeleteDialog({
    super.key,
    this.priceID,
  });

  String? priceID;

  final languagesController = Get.find<LanguagesController>();
  final controller = Get.find<DeleteSellingPriceController>();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 200,
      width: screenWidth,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            languagesController.tr("DO_YOU_WANT_TO_DELETE"),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            height: 50,
            width: screenWidth,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.deleteprice(priceID.toString());
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.defaultColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                        child: Obx(
                      () => Text(
                        controller.isLoading.value == false
                            ? languagesController.tr("YES")
                            : languagesController.tr("PLEASE_WAIT"),
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        languagesController.tr("NO"),
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
