import 'package:get/get.dart';
import 'package:watandaronline/bindings/add_sub_reseller_binding.dart';
import 'package:watandaronline/bindings/bottom_nav_binding.dart';
import 'package:watandaronline/bindings/custom_recharge_binding.dart';
import 'package:watandaronline/bindings/myprofile_binding.dart';
import 'package:watandaronline/bindings/new_service_binding.dart';
import 'package:watandaronline/bindings/recharge_binding.dart';
import 'package:watandaronline/bindings/service_binding.dart';
import 'package:watandaronline/bindings/sign_in_binding.dart';
import 'package:watandaronline/bindings/splash_binding.dart';
import 'package:watandaronline/bottom_nav_screen.dart';
import 'package:watandaronline/screens/add_card_screen.dart';
import 'package:watandaronline/screens/add_sub_reseller_screen.dart';
import 'package:watandaronline/screens/change_balance_screen.dart';
import 'package:watandaronline/screens/change_pin.dart';
import 'package:watandaronline/screens/change_sub_pass_screen.dart';
import 'package:watandaronline/screens/confirm_pin.dart';
import 'package:watandaronline/screens/custom_recharge_screen.dart';
import 'package:watandaronline/screens/edit_profile_screen.dart';
import 'package:watandaronline/screens/myprofile_screen.dart';
import 'package:watandaronline/screens/new_service_screen.dart';
import 'package:watandaronline/screens/onboarding_screen.dart';
import 'package:watandaronline/screens/order_details_screen.dart';
import 'package:watandaronline/screens/recharge_screen.dart';
import 'package:watandaronline/screens/result_screen.dart';
import 'package:watandaronline/screens/service_screen.dart';
import 'package:watandaronline/screens/sign_in_screen.dart';
import 'package:watandaronline/screens/sign_up_screen.dart';
import 'package:watandaronline/screens/social_recharge.dart';
import 'package:watandaronline/splash_screen.dart';

import '../bindings/selling_price_binding.dart';
import '../screens/commission_group_screen.dart';
import '../screens/create_selling_price_screen.dart';
import '../screens/helpscreen.dart';
import '../screens/selling_price_screen.dart';
import '../screens/social_recharge_screen.dart';

// control all pages from here

const String splash = '/splash-screen';
const String signinscreen = '/sign-in-screen';
const String onboardingscreen = '/onboardin-screen';
const String bottomnavscreen = '/bottomnav-screen';
const String addcardScreen = '/addcard-screen';
const String addsubresellerscreen = '/addsubreseller-screen';
const String changebalancescreen = '/changebalance-screen';
const String changepinscreen = '/changepin-screen';
const String changesubpassscreen = '/changesubpass-screen';
const String confirmpinscreen = '/confirmpin-screen';
const String editprofilescreen = '/editprofile-screen';
const String helpscreen = '/help-screen';
const String myprofilescreen = '/myprofile-screen';
const String orderdetailsscreen = '/orderdetails-screen';
const String rechargescreen = '/recharge-screen';
const String customrechargescreen = '/customrecharge-screen';
const String resultscreen = '/result-screen';
const String servicescreen = '/service-screen';
const String newservicescreen = '/newservice-screen';
const String signupscreen = '/signup-screen';
const String socialrechargescreen = '/socialrecharge-screen';
const String sellingpricescreen = '/sellingprice-screen';
const String createsellingpricescreen = '/createselling-screen';
const String commissiongroupscreen = '/comissiongroup-screen';

List<GetPage> myroutes = [
  GetPage(
    name: splash,
    page: () => SplashScreen(),
    binding: SplashBinding(),
  ),
  GetPage(
    name: onboardingscreen,
    page: () => OnboardingScreen(),
  ),
  GetPage(
    name: signinscreen,
    page: () => SignInScreen(),
    binding: SignInControllerBinding(),
  ),
  GetPage(
    name: bottomnavscreen,
    page: () => BottomNavigationbar(),
    binding: BottomNavBinding(),
  ),
  GetPage(
    name: addcardScreen,
    page: () => AddCardScreen(),
  ),
  GetPage(
    name: addsubresellerscreen,
    page: () => AddSubResellerScreen(),
    binding: AddSubResellerBinding(),
  ),
  GetPage(
    name: changebalancescreen,
    page: () => ChangeBalanceScreen(),
  ),
  GetPage(
    name: changepinscreen,
    page: () => ChangePin(),
  ),
  GetPage(
    name: onboardingscreen,
    page: () => OnboardingScreen(),
  ),
  GetPage(
    name: changesubpassscreen,
    page: () => ChangeSubPasswordScreen(),
  ),
  GetPage(
    name: confirmpinscreen,
    page: () => ConfirmPinScreen(),
  ),
  GetPage(
    name: editprofilescreen,
    page: () => EditProfileScreen(),
  ),
  GetPage(
    name: myprofilescreen,
    page: () => MyprofileScreen(),
    binding: MyProfileBinding(),
  ),
  GetPage(
    name: orderdetailsscreen,
    page: () => OrderDetailsScreen(),
  ),
  GetPage(
    name: rechargescreen,
    page: () => RechargeScreen(),
    binding: RechargeBinding(),
  ),
  GetPage(
    name: customrechargescreen,
    page: () => CustomRechargeScreen(),
    binding: CustomRechargeBinding(),
  ),
  GetPage(
    name: resultscreen,
    page: () => ResultScreen(),
  ),
  GetPage(
    name: newservicescreen,
    page: () => NewServiceScreen(),
    binding: NewServiceBinding(),
  ),
  GetPage(
    name: signinscreen,
    page: () => SignUpScreen(),
  ),
  GetPage(
    name: socialrechargescreen,
    page: () => SocialRechargeScreen(),
    binding: RechargeBinding(),
  ),
  GetPage(
    name: helpscreen,
    page: () => Helpscreen(),
    binding: BottomNavBinding(),
  ),
  GetPage(
    name: sellingpricescreen,
    page: () => SellingPriceScreen(),
    binding: SellingPriceBinding(),
  ),
  GetPage(
    name: commissiongroupscreen,
    page: () => CommissionGroupScreen(),
    binding: BottomNavBinding(),
  ),
  GetPage(
    name: createsellingpricescreen,
    page: () => CreateSellingPriceScreen(),
    binding: SellingPriceBinding(),
  ),
];
