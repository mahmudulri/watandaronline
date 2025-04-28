import 'package:meta/meta.dart';
import 'dart:convert';

CategoriesModel categoriesModelFromJson(String str) =>
    CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) =>
    json.encode(data.toJson());

class CategoriesModel {
  final bool? success;

  final String? message;
  late final Data? data;

  CategoriesModel({
    this.success,
    this.message,
    this.data,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  late final List<Servicecategory> servicecategories;

  Data({
    required this.servicecategories,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        servicecategories: List<Servicecategory>.from(
            json["servicecategories"].map((x) => Servicecategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "servicecategories":
            List<dynamic>.from(servicecategories.map((x) => x.toJson())),
      };
}

class Servicecategory {
  final int? id;
  final String? categoryName;
  final String? type;

  final List<Service>? services;

  Servicecategory({
    this.id,
    this.categoryName,
    this.type,
    this.services,
  });

  factory Servicecategory.fromJson(Map<String, dynamic> json) =>
      Servicecategory(
        id: json["id"] == null ? null : json["id"],
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        type: json["type"] == null ? null : json["type"],
        services: List<Service>.from(
            json["services"].map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "type": type,
        "services": List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}

class Service {
  final int? id;
  final String? serviceCategoryId;
  final String? companyId;
  final Company? company;

  Service({
    this.id,
    this.serviceCategoryId,
    this.companyId,
    this.company,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"] == null ? null : json["id"],
        serviceCategoryId: json["service_category_id"] == null
            ? null
            : json["service_category_id"],
        companyId: json["company_id"] == null ? null : json["company_id"],
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_category_id": serviceCategoryId,
      };
}

class Company {
  final int? id;
  final String? companyName;
  final String? companyLogo;
  final String? countryId;
  final String? telegramChatId;
  final Country? country;

  Company({
    this.id,
    this.companyName,
    this.companyLogo,
    this.countryId,
    this.telegramChatId,
    this.country,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"] == null ? null : json["id"],
        companyName: json["company_name"] == null ? null : json["company_name"],
        companyLogo: json["company_logo"] == null ? null : json["company_logo"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        telegramChatId:
            json["telegram_chat_id"] == null ? null : json["telegram_chat_id"],
        country:
            json["country"] == null ? null : Country.fromJson(json["country"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "company_logo": companyLogo,
        "country_id": countryId,
        "telegram_chat_id": telegramChatId,
        "country": country!.toJson(),
      };
}

class Country {
  final int? id;
  final String? countryName;
  final String? countryFlagImageUrl;
  final String? phoneNumberLength;

  Country({
    this.id,
    this.countryName,
    this.countryFlagImageUrl,
    required this.phoneNumberLength,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        countryName: json["country_name"]!,
        countryFlagImageUrl: json["country_flag_image_url"] == null
            ? null
            : json["country_flag_image_url"],
        phoneNumberLength: json["phone_number_length"] == null
            ? null
            : json["phone_number_length"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_name": countryName,
        "country_flag_image_url": countryFlagImageUrl,
        "phone_number_length": phoneNumberLength,
      };
}
