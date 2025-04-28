import 'package:get/get.dart';
import 'package:watandaronline/services/country_list_service.dart';

import '../models/country_list_model.dart';

class CountryListController extends GetxController {
  @override
  void onInit() {
    fetchCountryData();
    super.onInit();
  }

  var isLoading = false.obs;
  var finalCountryList = [];

  var allcountryListData = CountryListModel().obs;

  void fetchCountryData() async {
    try {
      isLoading(true);
      await CountryListApi().fetchCountryList().then((value) {
        allcountryListData.value = value;
        // print(allcountryListData.toJson()['data']['vehicles']);
        finalCountryList = allcountryListData.toJson()['data']['countries'];
        print(finalCountryList);

        // print(allcountryListData.toJson());
        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
