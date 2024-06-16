import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watantelecom/controllers/bundles_controller.dart';
import 'package:watantelecom/controllers/confirm_pin_controller.dart';
import 'package:watantelecom/controllers/place_order_controller.dart';
import 'package:watantelecom/controllers/service_controller.dart';
import 'package:watantelecom/screens/confirm_pin.dart';
import 'package:watantelecom/widgets/auth_textfield.dart';
import 'package:watantelecom/widgets/default_button.dart';
import 'package:watantelecom/widgets/rechange_number_box.dart';

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

  final ServiceController serviceController = Get.put(ServiceController());

  final BundleController bundleController = Get.put(BundleController());
  final box = GetStorage();
  final ConfirmPinController confirmPinController =
      Get.put(ConfirmPinController());

  TextEditingController searchController = TextEditingController();

  String search = "";

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fetchservices();
      bundleController.fetchbundles();
    });
  }
  // @override
  // void initState() {
  //   serviceController.fetchservices();
  //   bundleController.fetchbundles();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.defaultColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
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
          "Recharge Now",
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: confirmPinController.numberController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Number",
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
                      SizedBox(
                          height: 50,
                          width: screenWidth,
                          child: Obx(
                            () => serviceController.isLoading.value == false
                                ? ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        width: 5,
                                      );
                                    },
                                    scrollDirection: Axis.horizontal,
                                    itemCount: serviceController.allserviceslist
                                        .value.data!.services.length,
                                    itemBuilder: (context, index) {
                                      final data = serviceController
                                          .allserviceslist
                                          .value
                                          .data!
                                          .services[index];

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                            box.write(
                                                "company_id", data.companyId);
                                            bundleController.fetchbundles();
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
                                            child: Image.network(
                                              data.company!.companyLogo
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                      strokeWidth: 1.0,
                                    ),
                                  ),
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: duration.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  duration_selectedIndex = index;
                                  box.write("validity_type",
                                      duration[index]["Value"]);
                                  bundleController.fetchbundles();
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(),
                                height: 30,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    child: Text(
                                      duration[index]["Name"]!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: duration_selectedIndex == index
                                            ? Colors.white
                                            : Colors.black,
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
              flex: 8,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: Colors.white,
                ),
                child: Obx(
                  () => bundleController.isLoading.value == false
                      ? Padding(
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
                                height: 45,
                                width: screenWidth,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: TextField(
                                    onChanged: (String? value) {
                                      setState(() {
                                        search = value.toString();
                                      });
                                    },
                                    controller: searchController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                      border: InputBorder.none,
                                      hintText: "Search by Title ...",
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
                                    child: Obx(
                                      () =>
                                          bundleController.isLoading.value ==
                                                  false
                                              ? GridView.builder(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  itemCount: bundleController
                                                      .allbundleslist
                                                      .value
                                                      .data!
                                                      .bundles!
                                                      .length,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 8.0,
                                                    mainAxisSpacing: 7.0,
                                                    childAspectRatio: 0.45,
                                                  ),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final data =
                                                        bundleController
                                                            .allbundleslist
                                                            .value
                                                            .data!
                                                            .bundles![index];
                                                    if (searchController
                                                        .text.isEmpty) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (confirmPinController
                                                              .numberController
                                                              .text
                                                              .isEmpty) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Enter Number ",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);
                                                          } else {
                                                            box.write(
                                                                "bundleID",
                                                                data.id
                                                                    .toString());
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ConfirmPinScreen(),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.2), // Color of the shadow
                                                                spreadRadius:
                                                                    2, // How much the shadow spreads
                                                                blurRadius:
                                                                    5, // The blur radius of the shadow
                                                                offset: Offset(
                                                                    0,
                                                                    3), // The offset of the shadow
                                                              ),
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Text(
                                                                        data
                                                                            .service!
                                                                            .company!
                                                                            .companyName
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            30,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                NetworkImage(
                                                                              data.service!.company!.companyLogo.toString(),
                                                                            ),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                        // child: Image.asset(
                                                                        //   "assets/images/pubg.png",
                                                                        // ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              80,
                                                                          width:
                                                                              80,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            image:
                                                                                DecorationImage(
                                                                              image: NetworkImage(
                                                                                data.service!.company!.companyLogo.toString(),
                                                                              ),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              data.bundleTitle.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              data.sellingPrice.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 2,
                                                                            ),
                                                                            Text(
                                                                              data.currency!.code.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 2,
                                                                            ),
                                                                            Text(
                                                                              data.validityType.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return AlertDialog(
                                                                                  content: Container(
                                                                                    height: 160,
                                                                                    width: screenWidth,
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Text(
                                                                                          "Bundle Details",
                                                                                          style: TextStyle(
                                                                                            fontSize: 17,
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ),
                                                                                        ),
                                                                                        Divider(
                                                                                          thickness: 1,
                                                                                          color: Colors.grey,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 20,
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(
                                                                                              "Bundle Title : ",
                                                                                            ),
                                                                                            Text("${data.bundleTitle}"),
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(
                                                                                              "Validity : ",
                                                                                            ),
                                                                                            Text("${data.validityType}"),
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(
                                                                                              "Buying Price : ",
                                                                                            ),
                                                                                            Text("${data.buyingPrice}   ${data.currency!.code.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "Details",
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
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
                                                    } else if (bundleController
                                                        .allbundleslist
                                                        .value
                                                        .data!
                                                        .bundles![index]
                                                        .bundleTitle
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(searchController
                                                            .text
                                                            .toString()
                                                            .toLowerCase())) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (confirmPinController
                                                              .numberController
                                                              .text
                                                              .isEmpty) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Enter Number ",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);
                                                          } else {
                                                            box.write(
                                                                "bundleID",
                                                                data.id
                                                                    .toString());
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ConfirmPinScreen(),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.2), // Color of the shadow
                                                                spreadRadius:
                                                                    2, // How much the shadow spreads
                                                                blurRadius:
                                                                    5, // The blur radius of the shadow
                                                                offset: Offset(
                                                                    0,
                                                                    3), // The offset of the shadow
                                                              ),
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Text(
                                                                        data
                                                                            .service!
                                                                            .company!
                                                                            .companyName
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            30,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                NetworkImage(
                                                                              data.service!.company!.companyLogo.toString(),
                                                                            ),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                        // child: Image.asset(
                                                                        //   "assets/images/pubg.png",
                                                                        // ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              80,
                                                                          width:
                                                                              80,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            image:
                                                                                DecorationImage(
                                                                              image: NetworkImage(
                                                                                data.service!.company!.companyLogo.toString(),
                                                                              ),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              data.bundleTitle.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              data.sellingPrice.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 2,
                                                                            ),
                                                                            Text(
                                                                              data.currency!.code.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 2,
                                                                            ),
                                                                            Text(
                                                                              data.validityType.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return AlertDialog(
                                                                                  content: Container(
                                                                                    height: 160,
                                                                                    width: screenWidth,
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Text(
                                                                                          "Bundle Details",
                                                                                          style: TextStyle(
                                                                                            fontSize: 17,
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ),
                                                                                        ),
                                                                                        Divider(
                                                                                          thickness: 1,
                                                                                          color: Colors.grey,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 20,
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(
                                                                                              "Bundle Title : ",
                                                                                            ),
                                                                                            Text("${data.bundleTitle}"),
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(
                                                                                              "Validity : ",
                                                                                            ),
                                                                                            Text("${data.validityType}"),
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(
                                                                                              "Buying Price : ",
                                                                                            ),
                                                                                            Text("${data.buyingPrice}   ${data.currency!.code.toString()}"),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "Details",
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
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
                                                    } else {
                                                      print("object");
                                                    }
                                                  },
                                                )
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                    )),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
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
