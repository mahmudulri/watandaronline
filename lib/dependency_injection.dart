import 'package:get/get.dart';

import 'controllers/check_internet_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
