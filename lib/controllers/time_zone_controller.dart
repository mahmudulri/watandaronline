import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class TimeZoneController extends GetxController {
  final box = GetStorage();

  String sign = '';
  String hour = '';
  String minute = '';

  Future<void> fetchTimeData() async {
    final response = await http.get(Uri.parse(
        'https://worldtimeapi.org/api/timezone/${box.read("timezone")}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final utcOffset = data['utc_offset'];

      box.write("sign", utcOffset[0]);
      box.write("hour", utcOffset.substring(1, 3));
      box.write("minute", utcOffset.substring(4, 6));

      sign = utcOffset[0];
      hour = utcOffset.substring(1, 3);
      minute = utcOffset.substring(4, 6);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
