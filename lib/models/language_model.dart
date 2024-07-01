// To parse this JSON data, do
//
//     final languageModel = languageModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LanguageModel languageModelFromJson(String str) =>
    LanguageModel.fromJson(json.decode(str));

String languageModelToJson(LanguageModel data) => json.encode(data.toJson());

class LanguageModel {
  final bool? status;
  final String? message;
  final Map<String, String>? languageData;

  LanguageModel({
    this.status,
    this.message,
    this.languageData,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        status: json["status"],
        message: json["message"],
        languageData: Map.from(json["language_data"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "language_data": Map.from(languageData!)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
