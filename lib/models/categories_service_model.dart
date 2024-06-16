// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CategoriesModel categoriesModelFromJson(String str) =>
    CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) =>
    json.encode(data.toJson());

class CategoriesModel {
  final bool? success;

  final String? message;
  final Data? data;

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
  final List<Servicecategory> servicecategories;

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

  Service({
    this.id,
    this.serviceCategoryId,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"] == null ? null : json["id"],
        serviceCategoryId: json["service_category_id"] == null
            ? null
            : json["service_category_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_category_id": serviceCategoryId,
      };
}
