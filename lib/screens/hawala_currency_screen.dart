import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/hawala_currency_controller.dart';
import '../global controller/languages_controller.dart';
import '../utils/colors.dart';

class HawalaCurrencyScreen extends StatefulWidget {
  const HawalaCurrencyScreen({super.key});

  @override
  State<HawalaCurrencyScreen> createState() => _HawalaCurrencyScreenState();
}

class _HawalaCurrencyScreenState extends State<HawalaCurrencyScreen> {
  final box = GetStorage();

  HawalaCurrencyController hawalacurrencycontroller =
      Get.put(HawalaCurrencyController());
  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  void initState() {
    super.initState();
    hawalacurrencycontroller.fetchcurrency();
  }

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
          languagesController.tr("HAWALA_RATES"),
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
        decoration: BoxDecoration(),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => hawalacurrencycontroller.isLoading.value == false
                      ? ListView.builder(
                          itemCount: hawalacurrencycontroller
                              .allcurrencylist.value.data!.rates!.length,
                          itemBuilder: (context, index) {
                            final data = hawalacurrencycontroller
                                .allcurrencylist.value.data!.rates![index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 5),
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: Obx(
                                    () => Text(
                                      data.amount.toString() +
                                          " " +
                                          data.fromCurrency!.name.toString() +
                                          " To " +
                                          data.toCurrency!.name.toString() +
                                          " " +
                                          languagesController.tr("BUYING") +
                                          " " +
                                          data.buyRate.toString() +
                                          " " +
                                          data.toCurrency!.symbol.toString() +
                                          " " +
                                          languagesController.tr("SELLING") +
                                          " " +
                                          data.sellRate.toString() +
                                          " " +
                                          data.toCurrency!.symbol.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenHeight * 0.020,
                                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
