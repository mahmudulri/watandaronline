import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watandaronline/controllers/add_sub_reseller_controller.dart';
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/controllers/currency_controller.dart';
import 'package:watandaronline/controllers/district_controller.dart';
import 'package:watandaronline/controllers/province_controller.dart';
import 'package:watandaronline/controllers/sub_reseller_controller.dart';
import 'package:watandaronline/utils/colors.dart';
import 'package:watandaronline/widgets/auth_textfield.dart';
import 'package:watandaronline/widgets/default_button.dart';
import 'package:watandaronline/widgets/register_textfield.dart';

import '../global controller/languages_controller.dart';

class AddSubResellerScreen extends StatefulWidget {
  AddSubResellerScreen({super.key});

  @override
  State<AddSubResellerScreen> createState() => _AddSubResellerScreenState();
}

class _AddSubResellerScreenState extends State<AddSubResellerScreen> {
  final countryListController = Get.find<CountryListController>();
  final provinceController = Get.find<ProvinceController>();
  final currencyListController = Get.find<CurrencyListController>();
  final districtController = Get.find<DistrictController>();
  final addSubResellerController = Get.find<AddSubResellerController>();

  final languagesController = Get.find<LanguagesController>();

  final box = GetStorage();

  RxString selected_comissiongroup = "".obs;
  RxString selected_country = "".obs;
  RxString selected_province = "".obs;
  RxString selected_district = "".obs;

  void updateTranslations() {
    // selected_comissiongroup.value =
    //     languagesController.tr("SELECT_COMISSION_GROUP");
    selected_country.value = languagesController.tr("SELECT_COUNTRY");
    selected_province.value = languagesController.tr("SELECT_PROVINCE");
    selected_district.value = languagesController.tr("SELECT_DISTRICT");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateTranslations();
    ever(languagesController.selectedlan, (_) => updateTranslations());
    countryListController.fetchCountryData();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            countryListController.fetchCountryData();
          },
          child: Text(
            languagesController.tr("ADD_NEW_SUBRESELLER"),
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
        width: screenHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 10,
          ),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Stack(
                      children: [
                        addSubResellerController.selectedImagePath.value == ""
                            ? Container(
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      await addSubResellerController
                                          .uploadImage();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: screenWidth * 0.08,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: FileImage(
                                        addSubResellerController.imageFile!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                languagesController.tr("FULL_NAME"),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              RegisterField(
                  hintText: languagesController.tr("FULL_NAME"),
                  controller: addSubResellerController.resellerNameController),
              SizedBox(
                height: 5,
              ),
              Text(
                languagesController.tr("CONTACT_NAME"),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              RegisterField(
                hintText: languagesController.tr("CONTACT_NAME"),
                controller: addSubResellerController.contactNameController,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                languagesController.tr("EMAIL"),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              RegisterField(
                hintText: languagesController.tr("EMAIL_ADDRESS"),
                controller: addSubResellerController.emailController,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                languagesController.tr("PHONE_NUMBER"),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              RegisterField(
                hintText: languagesController.tr("PHONE_NUMBER"),
                controller: addSubResellerController.phoneController,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                languagesController.tr("CURRENCY_PREFERENCE"),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: AppColors.borderColor,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          box.read("currencyName") +
                              " (${box.read("currency_code")})",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return AlertDialog(
                          //       content: Container(
                          //         height: 150,
                          //         width: screenWidth,
                          //         color: Colors.white,
                          //         child: ListView.builder(
                          //           itemCount: currencyListController
                          //               .allcurrencylist
                          //               .value
                          //               .data!
                          //               .currencies
                          //               .length,
                          //           itemBuilder: (context, index) {
                          //             final data = currencyListController
                          //                 .allcurrencylist
                          //                 .value
                          //                 .data!
                          //                 .currencies[index];
                          //             return GestureDetector(
                          //               onTap: () {
                          //                 setState(() {
                          //                   selected_currency =
                          //                       data.symbol.toString();
                          //                 });
                          //                 addSubResellerController.currencyID
                          //                     .value = data.id.toString();

                          //                 print(addSubResellerController
                          //                     .currencyID);
                          //                 Navigator.pop(context);
                          //               },
                          //               child: Container(
                          //                 margin: EdgeInsets.only(bottom: 8),
                          //                 height: 40,
                          //                 decoration: BoxDecoration(
                          //                   border: Border.all(
                          //                     width: 1,
                          //                     color: Colors.grey,
                          //                   ),
                          //                 ),
                          //                 child: Padding(
                          //                   padding: const EdgeInsets.symmetric(
                          //                       horizontal: 10),
                          //                   child: Row(
                          //                     children: [
                          //                       Text(
                          //                         data.name.toString() + " -",
                          //                       ),
                          //                       SizedBox(
                          //                         width: 15,
                          //                       ),
                          //                       Text(
                          //                         data.symbol.toString(),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ),
                          //             );
                          //           },
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // );
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              AppColors.defaultColor.withOpacity(0.7),
                          radius: 18,
                          child: Icon(
                            FontAwesomeIcons.chevronDown,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                languagesController.tr("COUNTRY"),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: AppColors.borderColor,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 10),
                  child: GestureDetector(
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
                                itemCount: countryListController
                                    .allcountryListData
                                    .value
                                    .data!
                                    .countries
                                    .length,
                                itemBuilder: (context, index) {
                                  final data = countryListController
                                      .allcountryListData
                                      .value
                                      .data!
                                      .countries[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected_country.value =
                                            data.countryName.toString();
                                      });
                                      addSubResellerController.countryId.value =
                                          data.id.toString();

                                      print(addSubResellerController.countryId);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.network(
                                            data.countryFlagImageUrl.toString(),
                                            height: 40,
                                            width: 60,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            data.countryName.toString(),
                                          ),
                                        ],
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
                          child: Text(
                            selected_country.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor:
                              AppColors.defaultColor.withOpacity(0.7),
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
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                languagesController.tr("PROVINCE"),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: AppColors.borderColor,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 10),
                  child: GestureDetector(
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
                                itemCount: provinceController.allprovincelist
                                    .value.data!.provinces.length,
                                itemBuilder: (context, index) {
                                  final data = provinceController
                                      .allprovincelist
                                      .value
                                      .data!
                                      .provinces[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected_province.value =
                                            data.provinceName.toString();
                                      });
                                      addSubResellerController.provinceId
                                          .value = data.id.toString();

                                      print(
                                          addSubResellerController.provinceId);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            data.provinceName.toString(),
                                          ),
                                        ],
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
                          child: Text(
                            selected_province.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor:
                              AppColors.defaultColor.withOpacity(0.7),
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
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                languagesController.tr("DISTRICT"),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: AppColors.borderColor,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 10),
                  child: GestureDetector(
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
                                itemCount: districtController.alldistrictList
                                    .value.data!.districts.length,
                                itemBuilder: (context, index) {
                                  final data = districtController
                                      .alldistrictList
                                      .value
                                      .data!
                                      .districts[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected_district.value =
                                            data.districtName.toString();
                                      });
                                      addSubResellerController.districtID
                                          .value = data.id.toString();
                                      print(
                                          addSubResellerController.districtID);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            data.districtName.toString(),
                                          ),
                                        ],
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
                          child: Text(
                            selected_district.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor:
                              AppColors.defaultColor.withOpacity(0.7),
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
              ),
              SizedBox(
                height: 15,
              ),
              Obx(
                () => DefaultButton(
                  onPressed: () {
                    if (addSubResellerController
                            .resellerNameController.text.isEmpty ||
                        addSubResellerController
                            .contactNameController.text.isEmpty ||
                        addSubResellerController.emailController.text.isEmpty ||
                        addSubResellerController.phoneController.text.isEmpty ||
                        addSubResellerController.countryId.value == '' ||
                        addSubResellerController.provinceId.value == '' ||
                        addSubResellerController.districtID.value == '') {
                      Fluttertoast.showToast(
                          msg: languagesController.tr("FILL_DATA_CORRECTLY"),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      addSubResellerController.addNow();
                      print("ok");
                    }
                  },
                  buttonName: addSubResellerController.isLoading.value == false
                      ? languagesController.tr("ADD_NOW")
                      : languagesController.tr("PLEASE_WAIT"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
