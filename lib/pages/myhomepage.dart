import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watantelecom/controllers/country_list_controller.dart';
import 'package:watantelecom/controllers/dashboard_controller.dart';
import 'package:watantelecom/controllers/order_list_controller.dart';
import 'package:watantelecom/controllers/sub_reseller_controller.dart';
import 'package:watantelecom/utils/colors.dart';
import 'package:watantelecom/widgets/drawer.dart';

class Myhomepage extends StatefulWidget {
  const Myhomepage({super.key});

  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> assets = [
    'assets/images/img1.png',
    'assets/images/img2.png',
    'assets/images/img4.png',
    'assets/images/img5.png'
  ];

  final box = GetStorage();
  int currentindex = 0;

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
  Widget build(BuildContext context) {
    // orderlistController.fetchOrderlistdata();
    // dashboardController.fetchDashboardData();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.blue, // Optional: makes status bar transparent
    ));
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.defaultColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(
            Icons.sort,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        backgroundColor: AppColors.defaultColor,
        title: Obx(() => dashboardController.isLoading.value == false
            ? Column(
                children: [
                  Row(
                    children: [
                      Text(
                        dashboardController
                            .alldashboardData.value.data!.userInfo!.resellerName
                            .toString(),
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      )

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
                                dashboardController.alldashboardData.value.data!
                                    .userInfo!.countryId)["country_name"],
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ],
              )
            : SizedBox()),
      ),
      drawer: DrawerWidget(),
      body: Container(
        height: screenHeight,
        width: screenHeight,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  color: Colors.blue,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: Obx(
                          () => dashboardController.isLoading.value == false
                              ? PageView.builder(
                                  itemCount: dashboardController
                                      .alldashboardData
                                      .value
                                      .data!
                                      .advertisementSliders!
                                      .length,
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
                                      child: Image.network(
                                        dashboardController
                                            .alldashboardData
                                            .value
                                            .data!
                                            .advertisementSliders![index]
                                            .adSliderImageUrl
                                            .toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      ),
                      Obx(
                        () => dashboardController.isLoading.value == false
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    dashboardController
                                        .alldashboardData
                                        .value
                                        .data!
                                        .advertisementSliders!
                                        .length, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      height: 10,
                                      width: currentindex == index ? 30 : 10,
                                      decoration: BoxDecoration(
                                        color: currentindex == index
                                            ? Colors.white
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  );
                                }),
                              )
                            : SizedBox(),
                      ),
                      Row(
                        children: [
                          Text(
                            "Finacial Inquiry",
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(
                        () => dashboardController.isLoading.value == false
                            ? Container(
                                height: 70,
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
                                          .alldashboardData
                                          .value
                                          .data!
                                          .loanBalance
                                          .toString(),
                                      mycolor: Color(0xff1abc9c),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    financialbox(
                                      boxname: "Total Sold amount",
                                      balance: dashboardController
                                          .alldashboardData
                                          .value
                                          .data!
                                          .totalSoldAmount
                                          .toString(),
                                      mycolor: Color(0xffe67e22),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    financialbox(
                                      boxname: "Total revenue",
                                      balance: dashboardController
                                          .alldashboardData
                                          .value
                                          .data!
                                          .totalRevenue
                                          .toString(),
                                      mycolor: Color(0xff9b59b6),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    financialbox(
                                      boxname: "Today sale",
                                      balance: dashboardController
                                          .alldashboardData
                                          .value
                                          .data!
                                          .todaySale
                                          .toString(),
                                      mycolor: Color(0xff2c3e50),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    financialbox(
                                      boxname: "Today profit",
                                      balance: dashboardController
                                          .alldashboardData
                                          .value
                                          .data!
                                          .todayProfit
                                          .toString(),
                                      mycolor: Color(0xff7f8c8d),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "History",
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
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
                                        .allorderlist.value.data!.orders[index];
                                    return Container(
                                      height: 60,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                        // border: Border.all(
                                        //   width: 1,
                                        //   color: Colors.grey,
                                        // ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.listbuilderboxColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                    data.bundle!.service!
                                                        .company!.companyLogo
                                                        .toString(),
                                                  ),
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                    data.bundle!
                                                        .preferedCurrency!.code
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
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // Icon(
                                                    //   Icons.check,
                                                    //   color: Colors.green,
                                                    //   size: 14,
                                                    // ),
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
                                  child: CircularProgressIndicator(),
                                ),
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
      width: 200,
      decoration: BoxDecoration(
          color: Colors.blue,
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.blue,
          //     Colors.white.withOpacity(0.1),
          //   ],
          //   begin: Alignment.centerRight,
          //   end: Alignment.centerLeft,
          // ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: Colors.white54,
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
