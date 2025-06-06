import 'package:meta/meta.dart';
import 'dart:convert';

BundleModel bundleModelFromJson(String str) =>
    BundleModel.fromJson(json.decode(str));

String bundleModelToJson(BundleModel data) => json.encode(data.toJson());

class BundleModel {
  final bool? success;
  final Data? data;
  final Payload? payload;

  BundleModel({
    this.success,
    this.data,
    this.payload,
  });

  factory BundleModel.fromJson(Map<String, dynamic> json) => BundleModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        payload:
            json["payload"] == null ? null : Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "payload": payload?.toJson(),
      };
}

class Data {
  final List<Bundle>? bundles;

  Data({
    this.bundles,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        bundles: json["bundles"] == null
            ? null
            : List<Bundle>.from(json["bundles"].map((x) => Bundle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bundles": bundles == null
            ? null
            : List<dynamic>.from(bundles!.map((x) => x.toJson())),
      };
}

class Bundle {
  final int? id;
  final String? bundleCode;
  final String? bundleTitle;
  final String? bundleDescription;
  final String? validityType;
  final String? adminBuyingPrice;
  final String? buyingPrice;
  final String? sellingPrice;
  final Service? service;
  final Currency? currency;

  Bundle({
    this.id,
    this.bundleCode,
    this.bundleTitle,
    this.bundleDescription,
    this.validityType,
    this.adminBuyingPrice,
    this.buyingPrice,
    this.sellingPrice,
    this.service,
    this.currency,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) => Bundle(
        id: json["id"] == null ? null : json["id"],
        bundleCode: json["bundle_code"] == null ? null : json["bundle_code"],
        bundleTitle: json["bundle_title"] == null ? null : json["bundle_title"],
        bundleDescription: json["bundle_description"] == null
            ? null
            : json["bundle_description"],
        validityType:
            json["validity_type"] == null ? null : json["validity_type"],
        adminBuyingPrice: json["admin_buying_price"] == null
            ? null
            : json["admin_buying_price"],
        buyingPrice: json["buying_price"] == null ? null : json["buying_price"],
        sellingPrice:
            json["selling_price"] == null ? null : json["selling_price"],
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bundle_code": bundleCode,
        "bundle_title": bundleTitle,
        "bundle_description": bundleDescription,
        "validity_type": validityType,
        "admin_buying_price": adminBuyingPrice,
        "buying_price": buyingPrice,
        "selling_price": sellingPrice,
        "service": service?.toJson(),
        "currency": currency?.toJson(),
      };
}

class Currency {
  final String? code;

  Currency({
    this.code,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
      };
}

class Service {
  final int? id;
  final String? serviceCategoryID;
  final Company? company;

  Service({
    this.id,
    this.serviceCategoryID,
    this.company,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"] == null ? null : json["id"],
        serviceCategoryID: json["service_category_id"] == null
            ? null
            : json["service_category_id"],
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_category_id": serviceCategoryID,
        "company": company?.toJson(),
      };
}

class Company {
  final int? id;
  final String? companyName;
  final String? companyLogo;

  Company({
    this.id,
    this.companyName,
    this.companyLogo,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"] == null ? null : json["id"],
        companyName: json["company_name"] == null ? null : json["company_name"],
        companyLogo: json["company_logo"] == null ? null : json["company_logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "company_logo": companyLogo,
      };
}

class Payload {
  final Pagination? pagination;

  Payload({
    this.pagination,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  final int? currentPage;
  final int? totalItems;
  final int? totalPages;

  Pagination({
    this.currentPage,
    this.totalItems,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        totalItems: json["total_items"] == null ? null : json["total_items"],
        totalPages: json["total_pages"] == null ? null : json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "total_items": totalItems,
        "total_pages": totalPages,
      };
}
