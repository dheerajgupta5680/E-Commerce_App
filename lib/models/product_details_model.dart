// To parse this JSON data, do
//
//     final productDetailsModle = productDetailsModleFromJson(jsonString);

import 'dart:convert';

ProductDetailsModle productDetailsModleFromJson(String str) =>
    ProductDetailsModle.fromJson(json.decode(str));

String productDetailsModleToJson(ProductDetailsModle data) =>
    json.encode(data.toJson());

class ProductDetailsModle {
  int status;
  String? message;
  Data data;

  ProductDetailsModle({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductDetailsModle.fromJson(Map<String, dynamic> json) =>
      ProductDetailsModle(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int id;
  String description;

  Data({
    required this.id,
    required this.description,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
      };
}
