// To parse this JSON data, do
//
//     final isoCodeModel = isoCodeModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

IsoCodeModel isoCodeModelFromJson(String str) =>
    IsoCodeModel.fromJson(json.decode(str));

String isoCodeModelToJson(IsoCodeModel data) => json.encode(data.toJson());

class IsoCodeModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  IsoCodeModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory IsoCodeModel.fromJson(Map<String, dynamic> json) => IsoCodeModel(
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
  final List<Language> languages;

  Data({
    required this.languages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        languages: List<Language>.from(
            json["languages"].map((x) => Language.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "languages": List<dynamic>.from(languages.map((x) => x.toJson())),
      };
}

class Language {
  final String? languageName;
  final String? direction;
  final String? language_code;

  Language({
    this.languageName,
    this.direction,
    this.language_code,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
      languageName: json["language_name"],
      direction: json["direction"],
      language_code: json["language_code"]);

  Map<String, dynamic> toJson() => {
        "language_name": languageName,
        "direction": direction,
        "language_code": direction,
      };
}
