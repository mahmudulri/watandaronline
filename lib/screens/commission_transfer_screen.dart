import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/widgets/default_button.dart';
import '../controllers/categories_list_controller.dart';
import '../controllers/only_service_controller.dart';
import '../controllers/selling_price_controller.dart';
import '../controllers/transferlist_controller.dart';
import '../global controller/languages_controller.dart';
import '../utils/colors.dart';
import '../widgets/custom_text.dart';
import 'create_transfer_screen.dart';

class CommissionTransferScreen extends StatefulWidget {
  CommissionTransferScreen({super.key});

  @override
  State<CommissionTransferScreen> createState() =>
      _CommissionTransferScreenState();
}

class _CommissionTransferScreenState extends State<CommissionTransferScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());

  TransferlistController transferlistController =
      Get.put(TransferlistController());

  final SellingPriceController sellingPriceController =
      Get.put(SellingPriceController());

  final box = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transferlistController.fetchdata();

    sellingPriceController.fetchpriceData();
    serviceController.fetchservices();
  }

  CategorisListController categorisListController =
      Get.put(CategorisListController());

  final OnlyServiceController serviceController =
      Get.put(OnlyServiceController());
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
          languagesController.tr("TRANSFER_COMISSION"),
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
        decoration: BoxDecoration(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
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
                      child: DefaultButton(
                        buttonName: languagesController.tr("CREATE_NEW"),
                        onPressed: () {
                          Get.to(() => CreateTransferScreen());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Obx(() => transferlistController.isLoading.value == false
                    ? ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        itemCount: transferlistController
                            .alltransferlist.value.data!.requests!.length,
                        itemBuilder: (context, index) {
                          final data = transferlistController
                              .alltransferlist.value.data!.requests![index];
                          return Card(
                            child: Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 7),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        KText(
                                            text: languagesController
                                                .tr("AMOUNT")),
                                        KText(
                                          text: data.amount.toString(),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        KText(
                                            text: languagesController
                                                .tr("STATUS")),
                                        KText(
                                          text: data.status.toString(),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible:
                                          data.adminNotes.toString() != "null",
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          KText(
                                            text:
                                                languagesController.tr("NOTES"),
                                          ),
                                          KText(
                                            text: data.adminNotes.toString(),
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
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
