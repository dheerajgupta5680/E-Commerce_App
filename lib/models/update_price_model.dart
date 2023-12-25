// To parse this JSON data, do
//
//     final updatePriceModle = updatePriceModleFromJson(jsonString);

import 'dart:convert';

UpdatePriceModle updatePriceModleFromJson(String str) =>
    UpdatePriceModle.fromJson(json.decode(str));

String updatePriceModleToJson(UpdatePriceModle data) =>
    json.encode(data.toJson());

class UpdatePriceModle {
  int status;
  String? message;

  UpdatePriceModle({
    required this.status,
    required this.message,
  });

  factory UpdatePriceModle.fromJson(Map<String, dynamic> json) =>
      UpdatePriceModle(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
