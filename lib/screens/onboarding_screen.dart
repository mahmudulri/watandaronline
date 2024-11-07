import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watandaronline/routes/routes.dart';
import 'package:watandaronline/widgets/default_button.dart';

import '../utils/colors.dart';
import 'sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  final box = GetStorage();

  List pagelist = [
    pageOne(),
    pageTwo(),
    pageThree(),
  ];
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffFFFEFE),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(14.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pagelist.length,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return pagelist[index];
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
                      width: currentPage == index ? 30 : 10,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? AppColors.defaultColor.withOpacity(0.9)
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 10,
              ),
              DefaultButton(
                buttonName: currentPage == 2 ? "Get Started" : "Next",
                onPressed: () {
                  if (currentPage < pagelist.length - 1) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                    print(pagelist.length);
                  } else {
                    print(pagelist.length);
                    Get.toNamed(signinscreen);
                  }
                },
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(signinscreen);
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.defaultColor,
                    ),
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

class pageOne extends StatelessWidget {
  final box = GetStorage();
  pageOne({
    super.key,
  });
  String scantext =
      "Lorem ipsum dolor sit amet consectetur. In ornare ultrices cursus in integer mattis diam. Ullamcorper at vel. Lorem ipsum dolor sit amet consectetur. In ornare ultrices cursus in integer mattis diam. Ullamcorper at vel.";

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Container(
          height: 250,
          child: Image.asset('assets/images/slide-1.png'),
        ),
        // SizedBox(
        //   height: 80,
        // ),
        // ElevatedButton(
        //   onPressed: () {
        //     box.read("Restore");
        //   },
        //   child: Text("Restore"),
        // ),
        // Text(box.read("userToken").toString()),
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Watandaronline".toUpperCase(),
                      style: GoogleFonts.bebasNeue(
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth * 0.055,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Order everywhere, everytime".toUpperCase(),
                  style: GoogleFonts.bebasNeue(
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.055,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            textAlign: TextAlign.center,
            scantext,
          ),
        ),
      ],
    );
  }
}

class pageTwo extends StatelessWidget {
  pageTwo({
    super.key,
  });
  String scantext =
      "Lorem ipsum dolor sit amet consectetur. In ornare ultrices cursus in integer mattis diam. Ullamcorper at vel. Lorem ipsum dolor sit amet consectetur. In ornare ultrices cursus in integer mattis diam. Ullamcorper at vel.";

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Container(
          height: 250,
          // color: Colors.amber,
          child: Image.asset('assets/images/slide-2.png'),
        ),
        SizedBox(
          height: 80,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Watandaronline".toUpperCase(),
                      style: GoogleFonts.bebasNeue(
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth * 0.055,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Order everywhere, everytime".toUpperCase(),
                  style: GoogleFonts.bebasNeue(
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.055,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            textAlign: TextAlign.center,
            scantext,
          ),
        ),
      ],
    );
  }
}

class pageThree extends StatelessWidget {
  pageThree({
    super.key,
  });
  String scantext =
      "Lorem ipsum dolor sit amet consectetur. In ornare ultrices cursus in integer mattis diam. Ullamcorper at vel. Lorem ipsum dolor sit amet consectetur. In ornare ultrices cursus in integer mattis diam. Ullamcorper at vel.";

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Container(
          height: 250,
          // color: Colors.amber,
          child: Image.asset('assets/images/slide-3.png'),
        ),
        SizedBox(
          height: 80,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Watandaronline".toUpperCase(),
                      style: GoogleFonts.bebasNeue(
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth * 0.055,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Order everywhere, everytime".toUpperCase(),
                  style: GoogleFonts.bebasNeue(
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.055,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            textAlign: TextAlign.center,
            scantext,
          ),
        ),
      ],
    );
  }
}
