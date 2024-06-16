// To parse this JSON data, do
//
//     final dashboardDataModel = dashboardDataModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DashboardDataModel dashboardDataModelFromJson(String str) =>
    DashboardDataModel.fromJson(json.decode(str));

String dashboardDataModelToJson(DashboardDataModel data) =>
    json.encode(data.toJson());

class DashboardDataModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  DashboardDataModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      DashboardDataModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        payload: List<dynamic>.from(json["payload"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "code": code,
        "message": message,
        "data": data!.toJson(),
        "payload": List<dynamic>.from(payload!.map((x) => x)),
      };
}

class Data {
  final UserInfo? userInfo;
  final List<AdvertisementSlider>? advertisementSliders;
  final String? balance;
  final String? loanBalance;
  final int? totalSoldAmount;
  final int? totalRevenue;
  final int? todaySale;
  final int? todayProfit;

  Data({
    this.userInfo,
    this.advertisementSliders,
    this.balance,
    this.loanBalance,
    this.totalSoldAmount,
    this.totalRevenue,
    this.todaySale,
    this.todayProfit,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userInfo: UserInfo.fromJson(json["user_info"]),
        advertisementSliders: List<AdvertisementSlider>.from(
            json["advertisement_sliders"]
                .map((x) => AdvertisementSlider.fromJson(x))),
        balance: json["balance"] == null ? null : json["balance"],
        loanBalance: json["loan_balance"] == null ? null : json["loan_balance"],
        totalSoldAmount: json["total_sold_amount"] == null
            ? null
            : json["total_sold_amount"],
        totalRevenue:
            json["total_revenue"] == null ? null : json["total_revenue"],
        todaySale: json["today_sale"] == null ? null : json["today_sale"],
        todayProfit: json["today_profit"] == null ? null : json["today_profit"],
      );

  Map<String, dynamic> toJson() => {
        "user_info": userInfo!.toJson(),
        "advertisement_sliders":
            List<dynamic>.from(advertisementSliders!.map((x) => x.toJson())),
        "balance": balance,
        "loan_balance": loanBalance,
        "total_sold_amount": totalSoldAmount,
        "total_revenue": totalRevenue,
        "today_sale": todaySale,
        "today_profit": todayProfit,
      };
}

class AdvertisementSlider {
  final int? id;
  final String? advertisementTitle;
  final String? adSliderImageUrl;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;

  AdvertisementSlider({
    this.id,
    this.advertisementTitle,
    this.adSliderImageUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory AdvertisementSlider.fromJson(Map<String, dynamic> json) =>
      AdvertisementSlider(
        id: json["id"],
        advertisementTitle: json["advertisement_title"] == null
            ? null
            : json["advertisement_title"],
        adSliderImageUrl: json["ad_slider_image_url"] == null
            ? null
            : json["ad_slider_image_url"],
        status: json["status"] == null ? null : json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "advertisement_title": advertisementTitle,
        "ad_slider_image_url": adSliderImageUrl,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class UserInfo {
  final int? id;
  final String? userId;
  final dynamic? parentId;
  final String? uuid;
  final String? resellerName;
  final String? contactName;
  final String? resellerType;
  final dynamic? emailVerifiedAt;
  final String? accountPassword;
  final String? personalPin;
  final dynamic? rememberToken;
  final String? profileImageUrl;
  final String? email;
  final String? phone;
  final String? countryId;
  final String? provinceId;
  final dynamic? districtsId;
  final String? isResellerVerified;
  final String? status;
  final String? balance;
  final String? loanBalance;
  final dynamic? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;

  UserInfo({
    this.id,
    this.userId,
    this.parentId,
    this.uuid,
    this.resellerName,
    this.contactName,
    this.resellerType,
    this.emailVerifiedAt,
    this.accountPassword,
    this.personalPin,
    this.rememberToken,
    this.profileImageUrl,
    this.email,
    this.phone,
    this.countryId,
    this.provinceId,
    this.districtsId,
    this.isResellerVerified,
    this.status,
    this.balance,
    this.loanBalance,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        uuid: json["uuid"] == null ? null : json["uuid"],
        resellerName:
            json["reseller_name"] == null ? null : json["reseller_name"],
        contactName: json["contact_name"] == null ? null : json["contact_name"],
        resellerType:
            json["reseller_type"] == null ? null : json["reseller_type"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : json["email_verified_at"],
        accountPassword:
            json["account_password"] == null ? null : json["account_password"],
        personalPin: json["personal_pin"] == null ? null : json["personal_pin"],
        rememberToken:
            json["remember_token"] == null ? null : json["remember_token"],
        profileImageUrl: json["profile_image_url"] == null
            ? null
            : json["profile_image_url"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        provinceId: json["province_id"] == null ? null : json["province_id"],
        districtsId: json["districts_id"] == null ? null : json["districts_id"],
        isResellerVerified: json["is_reseller_verified"] == null
            ? null
            : json["is_reseller_verified"],
        status: json["status"] == null ? null : json["status"],
        balance: json["balance"] == null ? null : json["balance"],
        loanBalance: json["loan_balance"] == null ? null : json["loan_balance"],
        fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "parent_id": parentId,
        "uuid": uuid,
        "reseller_name": resellerName,
        "contact_name": contactName,
        "reseller_type": resellerType,
        "email_verified_at": emailVerifiedAt,
        "account_password": accountPassword,
        "personal_pin": personalPin,
        "remember_token": rememberToken,
        "profile_image_url": profileImageUrl,
        "email": email,
        "phone": phone,
        "country_id": countryId,
        "province_id": provinceId,
        "districts_id": districtsId,
        "is_reseller_verified": isResellerVerified,
        "status": status,
        "balance": balance,
        "loan_balance": loanBalance,
        "fcm_token": fcmToken,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
