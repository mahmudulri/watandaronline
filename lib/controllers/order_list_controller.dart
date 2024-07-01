import 'package:get/get.dart';
import 'package:watantelecom/models/orders_list_model.dart';
import 'package:watantelecom/services/dashboard_service.dart';
import 'package:watantelecom/services/order_list_service.dart';
import 'package:watantelecom/services/sub_reseller_service.dart';

import '../models/dashboard_data_model.dart';
import '../models/sub_reseller_model.dart';

class OrderlistController extends GetxController {
  String filterDate = "order_status=0";
  String orderstatus = "";
  int initialpage = 1;

  RxList finalList = <Order>[].obs;

  var isLoading = false.obs;

  var allorderlist = OrderListModel().obs;

  void fetchOrderlistdata() async {
    try {
      isLoading(true);
      await OrderListApi().fetchorderList().then((value) {
        allorderlist.value = value;

        if (allorderlist.value.data != null) {
          finalList.addAll(allorderlist.value.data!.orders);
        }
        // print(finalList.length.toString());
        finalList.forEach((order) {
          print(order.id.toString());
        });

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
