import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watantelecom/controllers/checker.dart';
import 'package:watantelecom/controllers/dashboard_controller.dart';
import 'package:watantelecom/controllers/order_list_controller.dart';
import 'package:watantelecom/screens/bus_ticket_screen.dart';
import 'package:watantelecom/screens/sub_reseller_screen.dart';
import 'package:watantelecom/widgets/drawer.dart';

import '../controllers/country_list_controller.dart';
import '../controllers/sub_reseller_controller.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<String> assets = [
    'assets/images/img1.png',
    'assets/images/img2.png',
    'assets/images/img4.png',
    'assets/images/img5.png'
  ];

  List<String> catpic = [
    'assets/images/recharge.png',
    'assets/images/electricity.png',
    'assets/images/flight.png',
    'assets/images/bus.png'
  ];

  List<String> catName = [
    "Recharge",
    "Electricity",
    "Flight ticket",
    "Bus ticket",
  ];

  final box = GetStorage();
  int currentindex = 0;

  // @override
  // void initState() {
  //   dashboardController.fetchDashboardData();
  //   subresellerController.fetchSubReseller();
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardController.fetchDashboardData();
      subresellerController.fetchSubReseller();
      orderlistController.fetchOrderlistdata();
    });
  }

  final DashboardController dashboardController =
      Get.put(DashboardController());
  final CountryListController countryListController =
      Get.put(CountryListController());
  final SubresellerController subresellerController =
      Get.put(SubresellerController());

  final OrderlistController orderlistController =
      Get.put(OrderlistController());

  @override
  void dispose() {
    // dashboardController.dispose();
    // countryListController.dispose();
    // subresellerController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.blue, // Optional: makes status bar transparent
    ));
    // dashboardController.fetchDashboardData();
    // subresellerController.fetchSubReseller();
    // countryListController.fetchCountryData();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffecf0f1),
      key: _scaffoldKey,
      appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(
              Icons.sort,
              color: Colors.black,
            ),
          ),
          elevation: 0.0,
          backgroundColor: AppColors.backgroundColor,
          title: Obx(
            () => dashboardController.isLoading.value == false
                ? Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            dashboardController.alldashboardData.value.data!
                                .userInfo!.resellerName
                                .toString(),
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          // GestureDetector(
                          //   onTap: () {
                          //     setState(() {
                          //       LocalizationChecker.changeLanguge(context);
                          //     });
                          //     // showDialog(
                          //     //   context: context,
                          //     //   builder: (context) {
                          //     //     return AlertDialog(
                          //     //       content: Container(
                          //     //         height: 200,
                          //     //         width: screenWidth,
                          //     //         child: Column(
                          //     //           children: [
                          //     //             ElevatedButton(
                          //     //                 onPressed: () {
                          //     //                   setState(() {
                          //     //                     EasyLocalization.of(context)!
                          //     //                         .setLocale(Locale('en', 'US'));
                          //     //                   });
                          //     //                   setState(() {});
                          //     //                 },
                          //     //                 child: Text("English")),
                          //     //             ElevatedButton(
                          //     //                 onPressed: () {
                          //     //                   setState(() {
                          //     //                     EasyLocalization.of(context)!
                          //     //                         .setLocale(Locale('ar', 'AE'));
                          //     //                   });
                          //     //                   setState(() {});
                          //     //                 },
                          //     //                 child: Text("Arabic")),
                          //     //           ],
                          //     //         ),
                          //     //       ),
                          //     //     );
                          //     //   },
                          //     // );

                          //     // setState(() {
                          //     //   EasyLocalization.of(context)!
                          //     //       .setLocale(Locale('ar', 'AE'));
                          //     // });
                          //     // setState(() {
                          //     //   LocalizationChecker.changeLanguge(context);
                          //     // });
                          //   },
                          //   child: Icon(Icons.language),
                          // ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            countryListController.finalCountryList.firstWhere(
                                (element) =>
                                    element['id'].toString() ==
                                    dashboardController
                                        .alldashboardData
                                        .value
                                        .data!
                                        .userInfo!
                                        .countryId)["country_name"],
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : SizedBox(),
          )),
      drawer: DrawerWidget(),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Obx(
              () => dashboardController.isLoading.value == false
                  ? ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 1,
                        ),
                        SizedBox(
                          height: 150,
                          child: PageView.builder(
                            itemCount: assets.length,
                            physics: BouncingScrollPhysics(),
                            controller: PageController(
                              initialPage: 0,
                              viewportFraction: 0.9,
                            ),
                            onPageChanged: (value) {
                              currentindex = value;
                              setState(() {});
                            },
                            itemBuilder: (context, index) {
                              return Container(
                                width: screenWidth,
                                margin: EdgeInsets.all(8),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  assets[index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: 10,
                                width: currentindex == index ? 30 : 10,
                                decoration: BoxDecoration(
                                  color: currentindex == index
                                      ? AppColors.defaultColor.withOpacity(0.9)
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () {
                        //         // print(countryListController.finalCountryList);
                        //         // countryListController.fetchCountryData();
                        //       },
                        //       child: Text(
                        //         "Sub Resellers",
                        //         style: GoogleFonts.rubik(
                        //           color: Colors.black,
                        //           fontSize: 22,
                        //           fontWeight: FontWeight.w500,
                        //         ),
                        //       ),
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => SubResellerScreen(),
                        //           ),
                        //         );
                        //       },
                        //       child: Text(
                        //         "View all",
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 15,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       "Categories",
                        //       style: GoogleFonts.rubik(
                        //         color: Colors.black,
                        //         fontSize: 22,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {},
                        //       child: Text(
                        //         "View all",
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 15,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        // Container(
                        //     margin: EdgeInsets.only(left: 10),
                        //     height: 90,
                        //     width: screenWidth,
                        //     // color: Colors.green,
                        //     child: Obx(
                        //       () => subresellerController.isLoading.value ==
                        //               false
                        //           ? ListView.separated(
                        //               separatorBuilder: (context, index) {
                        //                 return SizedBox(
                        //                   width: 30,
                        //                 );
                        //               },
                        //               scrollDirection: Axis.horizontal,
                        //               itemCount: subresellerController
                        //                   .allsubresellerData
                        //                   .value
                        //                   .data!
                        //                   .resellers
                        //                   .length,
                        //               itemBuilder: (context, index) {
                        //                 final data = subresellerController
                        //                     .allsubresellerData
                        //                     .value
                        //                     .data!
                        //                     .resellers[index];

                        //                 return Column(
                        //                   children: [
                        //                     Container(
                        //                       height: 60,
                        //                       width: 60,
                        //                       decoration: BoxDecoration(
                        //                         shape: BoxShape.circle,
                        //                         color:
                        //                             AppColors.categoryBoxColor,
                        //                         image: DecorationImage(
                        //                             image: AssetImage(
                        //                                 "assets/images/profilepic.jpg")),
                        //                         boxShadow: [
                        //                           BoxShadow(
                        //                             color: Colors.grey
                        //                                 .withOpacity(
                        //                                     0.5), // Shadow color
                        //                             spreadRadius:
                        //                                 1, // Spread radius
                        //                             blurRadius:
                        //                                 7, // Blur radius
                        //                             offset:
                        //                                 Offset(0, 3), // Offset
                        //                           ),
                        //                         ],
                        //                       ),
                        //                       // child: Padding(
                        //                       //   padding: EdgeInsets.all(8.0),
                        //                       //   child: Image.asset(
                        //                       //     "assets/images/profilepic.jpg",
                        //                       //   ),
                        //                       // ),
                        //                     ),
                        //                     SizedBox(
                        //                       height: 5,
                        //                     ),
                        //                     Text(
                        //                       data.contactName.toString(),
                        //                       style: TextStyle(
                        //                         fontSize: 10,
                        //                       ),
                        //                       textAlign: TextAlign.center,
                        //                     )
                        //                   ],
                        //                 );
                        //               },
                        //             )
                        //           : Center(
                        //               child: CircularProgressIndicator(),
                        //             ),
                        //     )),

                        Row(
                          children: [
                            Text(
                              "Finacial Inquiry",
                              style: GoogleFonts.rubik(
                                color: AppColors.defaultColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 50,
                          width: screenWidth,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            children: [
                              financialbox(
                                boxname: "Balance",
                                balance: dashboardController
                                    .alldashboardData.value.data!.balance
                                    .toString(),
                                mycolor: Color(0xff16a085),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              financialbox(
                                boxname: "Loan balance",
                                balance: dashboardController
                                    .alldashboardData.value.data!.loanBalance
                                    .toString(),
                                mycolor: Color(0xff1abc9c),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              financialbox(
                                boxname: "Total Sold amount",
                                balance: dashboardController.alldashboardData
                                    .value.data!.totalSoldAmount
                                    .toString(),
                                mycolor: Color(0xffe67e22),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              financialbox(
                                boxname: "Total revenue",
                                balance: dashboardController
                                    .alldashboardData.value.data!.totalRevenue
                                    .toString(),
                                mycolor: Color(0xff9b59b6),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              financialbox(
                                boxname: "Today sale",
                                balance: dashboardController
                                    .alldashboardData.value.data!.todaySale
                                    .toString(),
                                mycolor: Color(0xff2c3e50),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              financialbox(
                                boxname: "Today profit",
                                balance: dashboardController
                                    .alldashboardData.value.data!.todayProfit
                                    .toString(),
                                mycolor: Color(0xff7f8c8d),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   height: 50,
                        //   width: screenWidth,
                        //   child: ListView.separated(
                        //     separatorBuilder: (context, index) {
                        //       return SizedBox(
                        //         width: 5,
                        //       );
                        //     },
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: finacialName.length,
                        //     itemBuilder: (context, index) {
                        //       return Container(
                        //         height: 50,
                        //         width: 200,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10),
                        //           color: finacialName[index]['color'],
                        //         ),
                        //         child: Padding(
                        //           padding: const EdgeInsets.symmetric(
                        //               horizontal: 12),
                        //           child: Column(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.center,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               Text(
                        //                 finacialName[index]['name'],
                        //                 style: TextStyle(
                        //                   fontSize: 15,
                        //                   fontWeight: FontWeight.bold,
                        //                   color: Colors.white,
                        //                 ),
                        //               ),
                        //               Text(
                        //                 "AFG : ${finacialName[index]['balance']}",
                        //                 style: TextStyle(
                        //                   fontSize: 15,
                        //                   fontWeight: FontWeight.bold,
                        //                   color: Colors.white,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),

                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "History",
                              style: GoogleFonts.rubik(
                                color: AppColors.defaultColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 400,
                          child: Obx(
                            () => orderlistController.isLoading.value == false
                                ? ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 5,
                                      );
                                    },
                                    itemCount: orderlistController
                                        .allorderlist.value.data!.orders.length,
                                    itemBuilder: (context, index) {
                                      final data = orderlistController
                                          .allorderlist
                                          .value
                                          .data!
                                          .orders[index];
                                      return Container(
                                        height: 60,
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColors.listbuilderboxColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: Image.network(data
                                                      .bundle!
                                                      .service!
                                                      .company!
                                                      .companyLogo
                                                      .toString()),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      data.bundle!.bundleTitle
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      data.rechargebleAccount
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      data.bundle!.sellingPrice
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      data
                                                          .bundle!
                                                          .preferedCurrency!
                                                          .code
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                        size: 14,
                                                      ),
                                                      Text(
                                                        data.status.toString() ==
                                                                "0"
                                                            ? "pending"
                                                            : data.status
                                                                        .toString() ==
                                                                    "1"
                                                                ? "confirmed"
                                                                : "rejected",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      // Text(
                                                      //   "2 days ago",
                                                      //   style: TextStyle(
                                                      //     color: Colors.green,
                                                      //     fontSize: 10,
                                                      //     fontWeight:
                                                      //         FontWeight.w600,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: CircleAvatar(),
                                  ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            )),
      ),
    );
  }
}

class financialbox extends StatelessWidget {
  String? boxname;
  String? balance;
  Color? mycolor;
  financialbox({
    super.key,
    this.boxname,
    this.balance,
    this.mycolor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff3498db),
              Color(0xff95a5a6),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Colors.white,
          )
          // color: mycolor,
          ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              boxname.toString(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              "AFG : ${balance.toString()}",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
