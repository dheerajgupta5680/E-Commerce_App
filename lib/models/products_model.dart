// To parse this JSON data, do
//
//     final productListModel = productListModelFromJson(jsonString);

import 'dart:convert';

ProductListModel productListModelFromJson(String str) =>
    ProductListModel.fromJson(json.decode(str));

String productListModelToJson(ProductListModel data) =>
    json.encode(data.toJson());

class ProductListModel {
  String? message;
  List<ProductData>? data;

  ProductListModel({
    this.message,
    this.data,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) =>
      ProductListModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ProductData>.from(
                json["data"]!.map((x) => ProductData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ProductData {
  int? id;
  String? name;
  String? slug;
  String? img;
  double? mrp;
  double? sp;
  String? description;

  ProductData({
    this.id,
    this.name,
    this.slug,
    this.img,
    this.mrp,
    this.sp,
    this.description,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        img: json["img"],
        mrp: json["mrp"] ?? 0,
        sp: json["sp"] ?? 0,
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "img": img,
        "mrp": mrp,
        "sp": sp,
        "description": description,
      };
}
