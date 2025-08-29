import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:watandaronline/controllers/bundles_controller.dart';
import 'package:watandaronline/controllers/language_controller.dart';
import 'package:watandaronline/controllers/service_controller.dart';
import 'package:watandaronline/helpers/language_helper.dart';
import 'package:watandaronline/helpers/price.dart';
import 'package:watandaronline/routes/routes.dart';
import 'package:watandaronline/widgets/number_textfield.dart';
import '../controllers/confirm_pin_controller.dart';
import '../global controller/languages_controller.dart';
import '../utils/colors.dart';

class SocialRechargeScreen extends StatefulWidget {
  SocialRechargeScreen({
    super.key,
  });

  @override
  State<SocialRechargeScreen> createState() => _SocialRechargeScreenState();
}

class _SocialRechargeScreenState extends State<SocialRechargeScreen> {
  int selectedIndex = -1;
  int duration_selectedIndex = 0;

  List<Map<String, String>> duration = [];
  void initializeDuration() {
    duration = [
      {
        "Name": languagesController.tr("All"),
        "Value": "",
      },
      {
        "Name": languagesController.tr("UNLIMITED"),
        "Value": "unlimited",
      },
      {
        "Name": languagesController.tr("MONTHLY"),
        "Value": "monthly",
      },
      {
        "Name": languagesController.tr("WEEKLY"),
        "Value": "weekly",
      },
      {
        "Name": languagesController.tr("DAILY"),
        "Value": "daily",
      },
      {
        "Name": languagesController.tr("HOURLY"),
        "Value": "hourly",
      },
      {
        "Name": languagesController.tr("NIGHTLY"),
        "Value": "nightly",
      },
    ];
  }

  final box = GetStorage();
  final serviceController = Get.find<ServiceController>();
  final bundleController = Get.find<BundleController>();
  final confirmPinController = Get.find<ConfirmPinController>();
  final languagesController = Get.find<LanguagesController>();

  TextEditingController searchController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  String search = "";

  @override
  void initState() {
    super.initState();
    bundleController.finalList.clear();
    bundleController.initialpage = 1;

    initializeDuration();
    bundleController.fetchallbundles();
    scrollController.addListener(refresh);
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fetchservices();
    });
  }

  Future<void> refresh() async {
    final int totalPages =
        bundleController.allbundleslist.value.payload?.pagination!.totalPages ??
            0;
    final int currentPage = bundleController.initialpage;

    // Prevent loading more pages if we've reached the last page
    if (currentPage >= totalPages) {
      print(
          "End..........................................End.....................");
      return;
    }

    // Check if the scroll position is at the bottom
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      bundleController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (bundleController.initialpage <= totalPages) {
        print("Load More...................");
        bundleController.fetchallbundles();
      } else {
        bundleController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        confirmPinController.numberController.clear();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff2980b9),
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
          backgroundColor: Color(0xff2980b9),
          elevation: 0.0,
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              print(box.read("permission"));
            },
            child: Text(
              languagesController.tr("SOCIAL_RECHARGE"),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
                    color: Color(0xff2980b9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: confirmPinController.numberController,
                              maxLength: 200,
                              style: TextStyle(color: Colors.white),
                              // keyboardType: TextInputType.phone,
                              // inputFormatters: [
                              //   NewPasteRestrictionFormatter(),
                              //   FilteringTextInputFormatter.digitsOnly,
                              // ],
                              decoration: InputDecoration(
                                hintText: languagesController
                                    .tr("ENTER_NUMBER_OR_ID"),
                                counterText: "",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // CustomTextField(
                        //   confirmPinController:
                        //       confirmPinController.numberController,
                        //   languageData: languageController.alllanguageData.value
                        //       .languageData!["ENTER_YOUR_NUMBER"]
                        //       .toString(),
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          child: Obx(
                            () {
                              // Get all services
                              final services = serviceController
                                      .allserviceslist.value.data?.services ??
                                  [];

                              // Filter services based on input text
                              final filteredServices = confirmPinController
                                      .numberController.text.isEmpty
                                  ? services
                                  : services.where((service) {
                                      return service.company?.companycodes
                                              ?.any((code) {
                                            final reservedDigit =
                                                code.reservedDigit ?? '';
                                            return confirmPinController
                                                .numberController.text
                                                .startsWith(reservedDigit);
                                          }) ??
                                          false;
                                    }).toList();

                              // Use filteredServices or fallback to all services
                              final displayServices = filteredServices.isEmpty
                                  ? services
                                  : filteredServices;

                              // Check if services are loading
                              if (serviceController.isLoading.value) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.grey,
                                    strokeWidth: 1.0,
                                  ),
                                );
                              }

                              // Render the services
                              return Center(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(width: 5);
                                  },
                                  scrollDirection: Axis.horizontal,
                                  itemCount: displayServices.length,
                                  itemBuilder: (context, index) {
                                    final data = displayServices[index];

                                    return GestureDetector(
                                      onTap: () {
                                        bundleController.initialpage = 1;
                                        bundleController.finalList.clear();
                                        box.write("company_id", data.companyId);
                                        bundleController.fetchallbundles();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 65,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                data.company?.companyLogo ?? '',
                                            placeholder: (context, url) {
                                              print('Loading image: $url');
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                            errorWidget: (context, url, error) {
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
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          width: screenWidth,
                          height: 25,
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return VerticalDivider();
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: duration.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    duration_selectedIndex = index;
                                    box.write("validity_type",
                                        duration[index]["Value"]);
                                    bundleController.initialpage = 1;
                                    bundleController.finalList.clear();
                                    bundleController.fetchallbundles();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(),
                                  height: 30,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      child: Text(
                                        duration[index]["Name"]!,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: duration_selectedIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
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
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(13.0),
                      child: Column(
                        children: [
                          Container(
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
                                  hintText: languagesController.tr("SEARCH"),
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
                          Obx(
                            () => bundleController.isLoading.value == false
                                ? Container(
                                    child: bundleController.allbundleslist.value
                                            .data!.bundles!.isNotEmpty
                                        ? SizedBox()
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/empty.png",
                                                  height: 80,
                                                ),
                                                Text(
                                                  languagesController
                                                      .tr("NO_DATA_FOUND"),
                                                ),
                                              ],
                                            ),
                                          ),
                                  )
                                : SizedBox(),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Obx(
                                () => bundleController.isLoading.value == false
                                    ? RefreshIndicator(
                                        onRefresh: refresh,
                                        child: GridView.builder(
                                          shrinkWrap: false,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
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
                                            final data = bundleController
                                                .finalList[index];
                                            return GestureDetector(
                                              onTap: () {
                                                if (confirmPinController
                                                    .numberController
                                                    .text
                                                    .isEmpty) {
                                                  Fluttertoast.showToast(
                                                      msg: languagesController.tr(
                                                          "ENTER_NUMBER_OR_ID"),
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
                                                  Get.toNamed(confirmpinscreen);
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
                                                      BorderRadius.circular(10),
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
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
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
                                                                          12,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
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
                                                                        ? languagesController.tr(
                                                                            "UNLIMITED")
                                                                        : data.validityType.toString() ==
                                                                                "monthly"
                                                                            ? languagesController.tr("MONTHLY")
                                                                            : data.validityType.toString() == "weekly"
                                                                                ? languagesController.tr("WEEKLY").toString()
                                                                                : data.validityType.toString() == "daily"
                                                                                    ? languagesController.tr("DAILY")
                                                                                    : data.validityType.toString() == "hourly"
                                                                                        ? languagesController.tr("HOURLY")
                                                                                        : data.validityType.toString() == "nightly"
                                                                                            ? languagesController.tr("NIGHTLY")
                                                                                            : "",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12,
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
                                                                        languagesController
                                                                            .tr("BUY"),
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

                                                              // GestureDetector(
                                                              //   onTap: () {
                                                              //     showDialog(
                                                              //       context:
                                                              //           context,
                                                              //       builder:
                                                              //           (context) {
                                                              //         return AlertDialog(
                                                              //           content:
                                                              //               Container(
                                                              //             height:
                                                              //                 160,
                                                              //             width:
                                                              //                 screenWidth,
                                                              //             decoration:
                                                              //                 BoxDecoration(
                                                              //               color:
                                                              //                   Colors.white,
                                                              //             ),
                                                              //             child:
                                                              //                 Column(
                                                              //               children: [
                                                              //                 Text(
                                                              //                   languageController.alllanguageData.value.languageData!["BUNDLE_DETAILS"].toString(),
                                                              //                   style: TextStyle(
                                                              //                     fontSize: 17,
                                                              //                     fontWeight: FontWeight.w600,
                                                              //                   ),
                                                              //                 ),
                                                              //                 Divider(
                                                              //                   thickness: 1,
                                                              //                   color: Colors.grey,
                                                              //                 ),
                                                              //                 SizedBox(
                                                              //                   height: 20,
                                                              //                 ),
                                                              //                 Row(
                                                              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              //                   children: [
                                                              //                     Text(
                                                              //                       languageController.alllanguageData.value.languageData!["BUNDLE_TITLE"].toString(),
                                                              //                     ),
                                                              //                     Text("${data.bundleTitle}"),
                                                              //                   ],
                                                              //                 ),
                                                              //                 Row(
                                                              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              //                   children: [
                                                              //                     Text(
                                                              //                       languageController.alllanguageData.value.languageData!["VALIDITY"].toString(),
                                                              //                     ),
                                                              //                     Text("${data.validityType}"),
                                                              //                   ],
                                                              //                 ),
                                                              //                 Row(
                                                              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              //                   children: [
                                                              //                     Text(
                                                              //                       languageController.alllanguageData.value.languageData!["BUYING_PRICE"].toString(),
                                                              //                     ),
                                                              //                     Spacer(),
                                                              //                     Text(
                                                              //                       NumberFormat.currency(
                                                              //                         locale: 'en_US',
                                                              //                         symbol: '',
                                                              //                         decimalDigits: 2,
                                                              //                       ).format(
                                                              //                         double.parse(
                                                              //                           data.buyingPrice.toString(),
                                                              //                         ),
                                                              //                       ),
                                                              //                     ),
                                                              //                     Text(
                                                              //                       " ${box.read("currency_code")}",
                                                              //                       style: TextStyle(
                                                              //                         fontSize: 13,
                                                              //                         fontWeight: FontWeight.w500,
                                                              //                         color: Colors.black,
                                                              //                       ),
                                                              //                     ),
                                                              //                   ],
                                                              //                 ),
                                                              //               ],
                                                              //             ),
                                                              //           ),
                                                              //         );
                                                              //       },
                                                              //     );
                                                              //   },
                                                              //   child: Text(
                                                              //     languageController
                                                              //         .alllanguageData
                                                              //         .value
                                                              //         .languageData![
                                                              //             "VIEW_DETAILS"]
                                                              //         .toString(),
                                                              //     style:
                                                              //         TextStyle(
                                                              //       fontWeight:
                                                              //           FontWeight
                                                              //               .w600,
                                                              //       fontSize: 12,
                                                              //     ),
                                                              //   ),
                                                              // )
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
                                            final data = bundleController
                                                .finalList[index];
                                            return GestureDetector(
                                              onTap: () {
                                                if (confirmPinController
                                                    .numberController
                                                    .text
                                                    .isEmpty) {
                                                  Fluttertoast.showToast(
                                                      msg: languagesController.tr(
                                                          "ENTER_YOUR_NUMBER"),
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
                                                  Get.toNamed(confirmpinscreen);
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
                                                      BorderRadius.circular(10),
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
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
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
                                                                          12,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
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
                                                                        ? languagesController.tr(
                                                                            "UNLIMITED")
                                                                        : data.validityType.toString() ==
                                                                                "monthly"
                                                                            ? languagesController.tr("MONTHLY")
                                                                            : data.validityType.toString() == "weekly"
                                                                                ? languagesController.tr("WEEKLY").toString()
                                                                                : data.validityType.toString() == "daily"
                                                                                    ? languagesController.tr("DAILY")
                                                                                    : data.validityType.toString() == "hourly"
                                                                                        ? languagesController.tr("HOURLY")
                                                                                        : data.validityType.toString() == "nightly"
                                                                                            ? languagesController.tr("NIGHTLY")
                                                                                            : "",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12,
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
                                                                        languagesController
                                                                            .tr("BUY"),
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

                                                              // GestureDetector(
                                                              //   onTap: () {
                                                              //     showDialog(
                                                              //       context:
                                                              //           context,
                                                              //       builder:
                                                              //           (context) {
                                                              //         return AlertDialog(
                                                              //           content:
                                                              //               Container(
                                                              //             height:
                                                              //                 160,
                                                              //             width:
                                                              //                 screenWidth,
                                                              //             decoration:
                                                              //                 BoxDecoration(
                                                              //               color:
                                                              //                   Colors.white,
                                                              //             ),
                                                              //             child:
                                                              //                 Column(
                                                              //               children: [
                                                              //                 Text(
                                                              //                   languageController.alllanguageData.value.languageData!["BUNDLE_DETAILS"].toString(),
                                                              //                   style: TextStyle(
                                                              //                     fontSize: 17,
                                                              //                     fontWeight: FontWeight.w600,
                                                              //                   ),
                                                              //                 ),
                                                              //                 Divider(
                                                              //                   thickness: 1,
                                                              //                   color: Colors.grey,
                                                              //                 ),
                                                              //                 SizedBox(
                                                              //                   height: 20,
                                                              //                 ),
                                                              //                 Row(
                                                              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              //                   children: [
                                                              //                     Text(
                                                              //                       languageController.alllanguageData.value.languageData!["BUNDLE_TITLE"].toString(),
                                                              //                     ),
                                                              //                     Text("${data.bundleTitle}"),
                                                              //                   ],
                                                              //                 ),
                                                              //                 Row(
                                                              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              //                   children: [
                                                              //                     Text(
                                                              //                       languageController.alllanguageData.value.languageData!["VALIDITY"].toString(),
                                                              //                     ),
                                                              //                     Text("${data.validityType}"),
                                                              //                   ],
                                                              //                 ),
                                                              //                 Row(
                                                              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              //                   children: [
                                                              //                     Text(
                                                              //                       languageController.alllanguageData.value.languageData!["BUYING_PRICE"].toString(),
                                                              //                     ),
                                                              //                     Spacer(),
                                                              //                     Text(
                                                              //                       NumberFormat.currency(
                                                              //                         locale: 'en_US',
                                                              //                         symbol: '',
                                                              //                         decimalDigits: 2,
                                                              //                       ).format(
                                                              //                         double.parse(
                                                              //                           data.buyingPrice.toString(),
                                                              //                         ),
                                                              //                       ),
                                                              //                     ),
                                                              //                     Text(
                                                              //                       " ${box.read("currency_code")}",
                                                              //                       style: TextStyle(
                                                              //                         fontSize: 13,
                                                              //                         fontWeight: FontWeight.w500,
                                                              //                         color: Colors.black,
                                                              //                       ),
                                                              //                     ),
                                                              //                   ],
                                                              //                 ),
                                                              //               ],
                                                              //             ),
                                                              //           ),
                                                              //         );
                                                              //       },
                                                              //     );
                                                              //   },
                                                              //   child: Text(
                                                              //     languageController
                                                              //         .alllanguageData
                                                              //         .value
                                                              //         .languageData![
                                                              //             "VIEW_DETAILS"]
                                                              //         .toString(),
                                                              //     style:
                                                              //         TextStyle(
                                                              //       fontWeight:
                                                              //           FontWeight
                                                              //               .w600,
                                                              //       fontSize: 12,
                                                              //     ),
                                                              //   ),
                                                              // )
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
                                      ),
                              ),
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

class NewPasteRestrictionFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Check if the new value contains any non-digit characters
    if (!RegExp(r'^\d*$').hasMatch(newValue.text)) {
      // Show an error if the input is not numeric
      Get.snackbar(
        "Error",
        "Only allow English number format",
        colorText: Colors.white,
        duration: Duration(milliseconds: 1000),
        backgroundColor: Colors.black,
      );
      return oldValue; // Block the update
    }

    return newValue; // Allow the update if the input is numeric
  }
}
