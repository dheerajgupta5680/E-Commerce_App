// To parse this JSON data, do
//
//     final termConditionModel = termConditionModelFromJson(jsonString);

import 'dart:convert';

TermConditionModel termConditionModelFromJson(String str) =>
    TermConditionModel.fromJson(json.decode(str));

String termConditionModelToJson(TermConditionModel data) =>
    json.encode(data.toJson());

class TermConditionModel {
  int? status;
  String? message;
  Data? data;

  TermConditionModel({
    this.status,
    this.message,
    this.data,
  });

  factory TermConditionModel.fromJson(Map<String, dynamic> json) =>
      TermConditionModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? slug;
  String? description;
  DateTime? lastUpdate;

  Data({
    this.id,
    this.slug,
    this.description,
    this.lastUpdate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        slug: json["slug"],
        description: json["description"],
        lastUpdate: json["last_update"] == null
            ? null
            : DateTime.parse(json["last_update"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "description": description,
        "last_update": lastUpdate?.toIso8601String(),
      };
}
