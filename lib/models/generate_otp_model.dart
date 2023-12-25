// To parse this JSON data, do
//
//     final restaurantsModel = restaurantsModelFromJson(jsonString);

import 'dart:convert';

RestaurantsModel restaurantsModelFromJson(String str) =>
    RestaurantsModel.fromJson(json.decode(str));

String restaurantsModelToJson(RestaurantsModel data) =>
    json.encode(data.toJson());

class RestaurantsModel {
  int? status;
  String? message;

  RestaurantsModel({
    this.status,
    this.message,
  });

  factory RestaurantsModel.fromJson(Map<String, dynamic> json) =>
      RestaurantsModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
