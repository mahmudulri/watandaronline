import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:watandaronline/controllers/bundles_controller.dart';
import 'package:watandaronline/controllers/confirm_pin_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/place_order_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';
import 'package:watandaronline/helpers/price.dart';
import 'package:watandaronline/screens/confirm_pin.dart';
import 'package:watandaronline/widgets/auth_textfield.dart';
import 'package:watandaronline/widgets/default_button.dart';
import 'package:watandaronline/widgets/rechange_number_box.dart';

import '../controllers/operator_controller.dart';
import '../utils/colors.dart';

class SocialRechargeScreen extends StatefulWidget {
  SocialRechargeScreen({super.key});

  @override
  State<SocialRechargeScreen> createState() => _SocialRechargeScreenState();
}

class _SocialRechargeScreenState extends State<SocialRechargeScreen> {
  int selectedIndex = -1;
  int duration_selectedIndex = -1;

  List mycolor = [
    Color(0xff74b9ff),
    Color(0xff2bcbba),
    Color(0xff009432),
    Color(0xff2d98da),
  ];

  List<Map<String, String>> duration = [
    {
      "Name": "All",
      "Value": "",
    },
    {
      "Name": "Unllimited",
      "Value": "unlimited",
    },
    {
      "Name": "Monthly",
      "Value": "monthly",
    },
    {
      "Name": "Weekly",
      "Value": "weekly",
    },
    {
      "Name": "Daily",
      "Value": "daily",
    },
    {
      "Name": "Hourly",
      "Value": "hourly",
    },
    {
      "Name": "Nightly",
      "Value": "nightly",
    },
  ];
  final LanguageController languageController = Get.put(LanguageController());
  final ServiceController serviceController = Get.put(ServiceController());

  final BundleController bundleController = Get.put(BundleController());
  final box = GetStorage();
  final ConfirmPinController confirmPinController =
      Get.put(ConfirmPinController());

  TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String search = "";
  String inputNumber = "";

  @override
  void initState() {
    super.initState();
    scrollController.addListener(refresh);
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fetchservices();
      bundleController.fetchallbundles();
    });
  }

  Future<void> refresh() async {
    if (bundleController.finalList.length >=
        (bundleController.allbundleslist.value.payload?.pagination.totalItems ??
            0)) {
      print(
          "End..........................................End.....................");
    } else {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        bundleController.initialpage++;
        print(bundleController.initialpage);
        print("Load More...................");
        bundleController.fetchallbundles();
        print(bundleController.initialpage);
      } else {
        // print("nothing");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        confirmPinController.numberController.clear();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.defaultColor,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              confirmPinController.numberController.clear();
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.defaultColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            languageController.alllanguageData.value.languageData!["RECHARGE"]
                .toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: ListView(
                      children: [
                        Container(
                          height: 45,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller:
                                    confirmPinController.numberController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: languageController
                                        .alllanguageData
                                        .value
                                        .languageData!["ENTER_YOUR_NUMBER"]
                                        .toString(),
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          color: Colors.transparent,
                          width: screenWidth,
                          child: Obx(
                            () {
                              // Check if the allserviceslist is not null and contains data
                              final services = serviceController
                                      .allserviceslist.value.data?.services ??
                                  [];

                              // Show all services if input is empty, otherwise filter
                              final filteredServices = inputNumber.isEmpty
                                  ? services
                                  : services.where((service) {
                                      return service.company?.companycodes
                                              ?.any((code) {
                                            final reservedDigit =
                                                code.reservedDigit ?? '';
                                            return inputNumber
                                                .startsWith(reservedDigit);
                                          }) ??
                                          false;
                                    }).toList();

                              return serviceController.isLoading.value == false
                                  ? Center(
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            width: 5,
                                          );
                                        },
                                        scrollDirection: Axis.horizontal,
                                        itemCount: filteredServices.length,
                                        itemBuilder: (context, index) {
                                          final data = filteredServices[index];

                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                bundleController.initialpage =
                                                    1;
                                                bundleController.finalList
                                                    .clear();
                                                selectedIndex = index;
                                                box.write("company_id",
                                                    data.companyId);
                                                bundleController
                                                    .fetchallbundles();
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                color: selectedIndex == index
                                                    ? Color(0xff34495e)
                                                    : Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                  vertical: 5,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: data.company
                                                          ?.companyLogo ??
                                                      '',
                                                  placeholder: (context, url) {
                                                    print(
                                                        'Loading image: $url');
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ));
                                                  },
                                                  errorWidget:
                                                      (context, url, error) {
                                                    print(
                                                        'Error loading image: $url, error: $error');
                                                    return Icon(Icons.error);
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.grey,
                                        strokeWidth: 1.0,
                                      ),
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(13.0),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            height: 50,
                            width: screenWidth,
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: TextField(
                                onChanged: (value) {
                                  bundleController.finalList.clear();
                                  bundleController.initialpage = 1;
                                  box.write("search_tag", value.toString());
                                  bundleController.fetchallbundles();
                                  print(value.toString());
                                },
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      // bundleController.finalList.clear();
                                      // box.write("search_tag", "1.5");
                                      // bundleController.fetchallbundles();
                                    },
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  hintText: languageController.alllanguageData
                                      .value.languageData!["SEARCH"]
                                      .toString(),
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Obx(() {
                                if (bundleController.isLoading.value) {
                                  return RefreshIndicator(
                                    onRefresh: refresh,
                                    child: GridView.builder(
                                      shrinkWrap: false,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      controller: scrollController,
                                      itemCount:
                                          bundleController.finalList.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 8.0,
                                        mainAxisSpacing: 7.0,
                                        childAspectRatio: 0.45,
                                      ),
                                      itemBuilder: (context, index) {
                                        final data =
                                            bundleController.finalList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            if (confirmPinController
                                                .numberController
                                                .text
                                                .isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg: languageController
                                                      .alllanguageData
                                                      .value
                                                      .languageData![
                                                          "ENTER_YOUR_NUMBER"]
                                                      .toString(),
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else {
                                              box.write("bundleID",
                                                  data.id.toString());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConfirmPinScreen(),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(
                                                      0.2), // Color of the shadow
                                                  spreadRadius:
                                                      2, // How much the shadow spreads
                                                  blurRadius:
                                                      5, // The blur radius of the shadow
                                                  offset: Offset(0,
                                                      3), // The offset of the shadow
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Center(
                                                            child: Text(
                                                              data
                                                                  .service!
                                                                  .company!
                                                                  .companyName
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    NetworkImage(
                                                                  data
                                                                      .service!
                                                                      .company!
                                                                      .companyLogo
                                                                      .toString(),
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            // child: Image.asset(
                                                            //   "assets/images/pubg.png",
                                                            // ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: 80,
                                                            width: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    NetworkImage(
                                                                  data
                                                                      .service!
                                                                      .company!
                                                                      .companyLogo
                                                                      .toString(),
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  data.bundleTitle
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              PriceTextView(
                                                                price: data
                                                                    .sellingPrice
                                                                    .toString(),
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                " ${box.read("currency_code")}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 8,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                data.validityType
                                                                            .toString() ==
                                                                        "unlimited"
                                                                    ? languageController
                                                                        .alllanguageData
                                                                        .value
                                                                        .languageData![
                                                                            "UNLIMITED"]
                                                                        .toString()
                                                                    : data.validityType.toString() ==
                                                                            "monthly"
                                                                        ? languageController
                                                                            .alllanguageData
                                                                            .value
                                                                            .languageData![
                                                                                "MONTHLY"]
                                                                            .toString()
                                                                        : data.validityType.toString() ==
                                                                                "weekly"
                                                                            ? languageController.alllanguageData.value.languageData!["WEEKLY"].toString()
                                                                            : data.validityType.toString() == "daily"
                                                                                ? languageController.alllanguageData.value.languageData!["DAILY"].toString()
                                                                                : data.validityType.toString() == "hourly"
                                                                                    ? languageController.alllanguageData.value.languageData!["HOURLY"].toString()
                                                                                    : data.validityType.toString() == "nightly"
                                                                                        ? languageController.alllanguageData.value.languageData!["NIGHTLY"].toString()
                                                                                        : "",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    languageController
                                                                        .alllanguageData
                                                                        .value
                                                                        .languageData![
                                                                            "BUY"]
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          8,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SPriceTextView(
                                                                    price: data
                                                                        .buyingPrice
                                                                        .toString(),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 2,
                                                                  ),
                                                                  Text(
                                                                    " ${box.read("currency_code")}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          8,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else if (bundleController
                                            .allbundleslist.value.data ==
                                        null ||
                                    bundleController.allbundleslist.value.data!
                                        .bundles!.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/icons/empty.png",
                                          height: 80,
                                        ),
                                        Text("No Data found"),
                                      ],
                                    ),
                                  );
                                } else {
                                  return bundleController.isLoading.value ==
                                          false
                                      ? RefreshIndicator(
                                          onRefresh: refresh,
                                          child: GridView.builder(
                                            shrinkWrap: false,
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            controller: scrollController,
                                            itemCount: bundleController
                                                .finalList.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 8.0,
                                              mainAxisSpacing: 7.0,
                                              childAspectRatio: 0.45,
                                            ),
                                            itemBuilder: (context, index) {
                                              final data = bundleController
                                                  .finalList[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  if (confirmPinController
                                                      .numberController
                                                      .text
                                                      .isEmpty) {
                                                    Fluttertoast.showToast(
                                                        msg: languageController
                                                            .alllanguageData
                                                            .value
                                                            .languageData![
                                                                "ENTER_YOUR_NUMBER"]
                                                            .toString(),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.black,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  } else {
                                                    box.write("bundleID",
                                                        data.id.toString());
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ConfirmPinScreen(),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(
                                                                0.2), // Color of the shadow
                                                        spreadRadius:
                                                            2, // How much the shadow spreads
                                                        blurRadius:
                                                            5, // The blur radius of the shadow
                                                        offset: Offset(0,
                                                            3), // The offset of the shadow
                                                      ),
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey.shade300,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 2,
                                                                child: Center(
                                                                  child: Text(
                                                                    data
                                                                        .service!
                                                                        .company!
                                                                        .companyName
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          NetworkImage(
                                                                        data
                                                                            .service!
                                                                            .company!
                                                                            .companyLogo
                                                                            .toString(),
                                                                      ),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  // child: Image.asset(
                                                                  //   "assets/images/pubg.png",
                                                                  // ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  height: 80,
                                                                  width: 80,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          NetworkImage(
                                                                        data
                                                                            .service!
                                                                            .company!
                                                                            .companyLogo
                                                                            .toString(),
                                                                      ),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        data.bundleTitle
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    PriceTextView(
                                                                      price: data
                                                                          .sellingPrice
                                                                          .toString(),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                    Text(
                                                                      " ${box.read("currency_code")}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            8,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                    Text(
                                                                      data.validityType.toString() ==
                                                                              "unlimited"
                                                                          ? languageController
                                                                              .alllanguageData
                                                                              .value
                                                                              .languageData!["UNLIMITED"]
                                                                              .toString()
                                                                          : data.validityType.toString() == "monthly"
                                                                              ? languageController.alllanguageData.value.languageData!["MONTHLY"].toString()
                                                                              : data.validityType.toString() == "weekly"
                                                                                  ? languageController.alllanguageData.value.languageData!["WEEKLY"].toString()
                                                                                  : data.validityType.toString() == "daily"
                                                                                      ? languageController.alllanguageData.value.languageData!["DAILY"].toString()
                                                                                      : data.validityType.toString() == "hourly"
                                                                                          ? languageController.alllanguageData.value.languageData!["HOURLY"].toString()
                                                                                          : data.validityType.toString() == "nightly"
                                                                                              ? languageController.alllanguageData.value.languageData!["NIGHTLY"].toString()
                                                                                              : "",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          languageController
                                                                              .alllanguageData
                                                                              .value
                                                                              .languageData!["BUY"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                8,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SPriceTextView(
                                                                          price: data
                                                                              .buyingPrice
                                                                              .toString(),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Text(
                                                                          " ${box.read("currency_code")}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                8,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : RefreshIndicator(
                                          onRefresh: refresh,
                                          child: GridView.builder(
                                            shrinkWrap: false,
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            controller: scrollController,
                                            itemCount: bundleController
                                                .finalList.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 8.0,
                                              mainAxisSpacing: 7.0,
                                              childAspectRatio: 0.45,
                                            ),
                                            itemBuilder: (context, index) {
                                              final data = bundleController
                                                  .finalList[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  if (confirmPinController
                                                      .numberController
                                                      .text
                                                      .isEmpty) {
                                                    Fluttertoast.showToast(
                                                        msg: languageController
                                                            .alllanguageData
                                                            .value
                                                            .languageData![
                                                                "ENTER_YOUR_NUMBER"]
                                                            .toString(),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.black,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  } else {
                                                    box.write("bundleID",
                                                        data.id.toString());
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ConfirmPinScreen(),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(
                                                                0.2), // Color of the shadow
                                                        spreadRadius:
                                                            2, // How much the shadow spreads
                                                        blurRadius:
                                                            5, // The blur radius of the shadow
                                                        offset: Offset(0,
                                                            3), // The offset of the shadow
                                                      ),
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey.shade300,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 2,
                                                                child: Center(
                                                                  child: Text(
                                                                    data
                                                                        .service!
                                                                        .company!
                                                                        .companyName
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          NetworkImage(
                                                                        data
                                                                            .service!
                                                                            .company!
                                                                            .companyLogo
                                                                            .toString(),
                                                                      ),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  // child: Image.asset(
                                                                  //   "assets/images/pubg.png",
                                                                  // ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  height: 80,
                                                                  width: 80,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          NetworkImage(
                                                                        data
                                                                            .service!
                                                                            .company!
                                                                            .companyLogo
                                                                            .toString(),
                                                                      ),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        data.bundleTitle
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    PriceTextView(
                                                                      price: data
                                                                          .sellingPrice
                                                                          .toString(),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                    Text(
                                                                      " ${box.read("currency_code")}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            8,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                    Text(
                                                                      data.validityType.toString() ==
                                                                              "unlimited"
                                                                          ? languageController
                                                                              .alllanguageData
                                                                              .value
                                                                              .languageData!["UNLIMITED"]
                                                                              .toString()
                                                                          : data.validityType.toString() == "monthly"
                                                                              ? languageController.alllanguageData.value.languageData!["MONTHLY"].toString()
                                                                              : data.validityType.toString() == "weekly"
                                                                                  ? languageController.alllanguageData.value.languageData!["WEEKLY"].toString()
                                                                                  : data.validityType.toString() == "daily"
                                                                                      ? languageController.alllanguageData.value.languageData!["DAILY"].toString()
                                                                                      : data.validityType.toString() == "hourly"
                                                                                          ? languageController.alllanguageData.value.languageData!["HOURLY"].toString()
                                                                                          : data.validityType.toString() == "nightly"
                                                                                              ? languageController.alllanguageData.value.languageData!["NIGHTLY"].toString()
                                                                                              : "",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          languageController
                                                                              .alllanguageData
                                                                              .value
                                                                              .languageData!["BUY"]
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                8,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SPriceTextView(
                                                                          price: data
                                                                              .buyingPrice
                                                                              .toString(),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Text(
                                                                          " ${box.read("currency_code")}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                8,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                }
                              }),
                            ),
                          ),
                          Obx(
                            () => bundleController.isLoading.value == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: AppColors.defaultColor,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
