import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:watandaronline/controllers/time_zone_controller.dart';

final TimeZoneController timeZoneController = Get.put(TimeZoneController());

Text convertToDate(
  String utcTimeString,
) {
  String localTimeString;
  try {
    // Parse the UTC time
    DateTime utcTime = DateTime.parse(utcTimeString);

    // Calculate the offset duration
    Duration offset = Duration(
      hours: int.parse(timeZoneController.hour),
      minutes: int.parse(timeZoneController.minute),
    );

    // Apply the offset (subtracting for negative)

    if (timeZoneController.sign == "+") {
      DateTime localTime = utcTime.add(offset);
      String formattedTime =
          DateFormat('yyyy-MM-dd', 'en_US').format(localTime);
      localTimeString = '$formattedTime';
    } else {
      DateTime localTime = utcTime.subtract(offset);
      String formattedTime =
          DateFormat('yyyy-MM-dd', 'en_US').format(localTime);

      localTimeString = '$formattedTime';
    }
  } catch (e) {
    localTimeString = '';
  }
  return Text(
    localTimeString,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  );
}

Text convertToLocalTime(
  String utcTimeString,
) {
  String localTimeString;
  try {
    // Parse the UTC time
    DateTime utcTime = DateTime.parse(utcTimeString);

    // Calculate the offset duration
    Duration offset = Duration(
      hours: int.parse(timeZoneController.hour),
      minutes: int.parse(timeZoneController.minute),
    );

    // Apply the offset (subtracting for negative)

    if (timeZoneController.sign == "+") {
      DateTime localTime = utcTime.add(offset);
      String formattedTime =
          DateFormat('hh:mm:ss a', 'en_US').format(localTime);
      localTimeString = '$formattedTime';
    } else {
      DateTime localTime = utcTime.subtract(offset);
      String formattedTime =
          DateFormat('hh:mm:ss a', 'en_US').format(localTime);

      localTimeString = '$formattedTime';
    }
  } catch (e) {
    localTimeString = '';
  }
  return Text(
    localTimeString,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  );
}
