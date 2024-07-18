import 'package:get/get.dart';
import 'package:watandaronline/models/bundle_model.dart';
import 'package:watandaronline/models/language_model.dart';
import 'package:watandaronline/services/language_service.dart';

class LanguageController extends GetxController {
  @override
  void onInit() {
    // fetchlanData();
    super.onInit();
  }

  var isLoading = false.obs;

  var alllanguageData = LanguageModel().obs;

  void fetchlanData(String isoCode) async {
    try {
      isLoading(true);
      await LanguageApi().fetchLanguage(isoCode).then((value) {
        alllanguageData.value = value;

        // print(alllanguageData.toJson()["language_data"]);

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
