import 'package:get/get.dart';
import 'package:watandaronline/controllers/categories_list_controller.dart';
import 'package:watandaronline/controllers/change_status_controller.dart';
import 'package:watandaronline/controllers/country_list_controller.dart';
import 'package:watandaronline/controllers/dashboard_controller.dart';
import 'package:watandaronline/controllers/delete_sub_reseller.dart';
import 'package:watandaronline/controllers/history_controller.dart';
import 'package:watandaronline/controllers/order_list_controller.dart';
import 'package:watandaronline/controllers/sign_in_controller.dart';
import 'package:watandaronline/controllers/sub_reseller_controller.dart';
import 'package:watandaronline/controllers/subreseller_details_controller.dart';
import 'package:watandaronline/controllers/transaction_controller.dart';

class BottomNavBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<OrderlistController>(() => OrderlistController());
    Get.lazyPut<TransactionController>(() => TransactionController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<CountryListController>(() => CountryListController());
    Get.lazyPut<SignInController>(() => SignInController());
    Get.lazyPut<TransactionController>(() => TransactionController());
    Get.lazyPut<SubresellerController>(() => SubresellerController());
    Get.lazyPut<SubresellerDetailsController>(
        () => SubresellerDetailsController());

    Get.lazyPut<DeleteSubResellerController>(
        () => DeleteSubResellerController());
    Get.lazyPut<ChangeStatusController>(() => ChangeStatusController());

    Get.lazyPut<CategorisListController>(() => CategorisListController());
  }
}
