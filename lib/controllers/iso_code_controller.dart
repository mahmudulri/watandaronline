import 'package:get/get.dart';
import 'package:watantelecom/models/bundle_model.dart';
import 'package:watantelecom/models/isocode_model.dart';
import 'package:watantelecom/models/language_model.dart';
import 'package:watantelecom/services/isocode_service.dart';
import 'package:watantelecom/services/language_service.dart';

class IscoCodeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  var isLoading = false.obs;

  var allisoCodeData = IsoCodeModel().obs;

  void fetchisoCode() async {
    try {
      isLoading(true);
      await IsoCodeApi().fetchIsoCode().then((value) {
        allisoCodeData.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
