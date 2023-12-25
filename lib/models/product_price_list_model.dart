// To parse this JSON data, do
//
//     final productPriceListModel = productPriceListModelFromJson(jsonString);

import 'dart:convert';

ProductPriceListModel productPriceListModelFromJson(String str) =>
    ProductPriceListModel.fromJson(json.decode(str));

String productPriceListModelToJson(ProductPriceListModel data) =>
    json.encode(data.toJson());

class ProductPriceListModel {
  int status;
  String? message;
  List<ProductsData> productsData;

  ProductPriceListModel({
    required this.status,
    required this.message,
    required this.productsData,
  });

  factory ProductPriceListModel.fromJson(Map<String, dynamic> json) =>
      ProductPriceListModel(
        status: json["status"],
        message: json["message"],
        productsData: List<ProductsData>.from(
            json["data"].map((x) => ProductsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(productsData.map((x) => x.toJson())),
      };
}

class ProductsData {
  int id;
  double price;
  DateTime date;
  int product;

  ProductsData({
    required this.id,
    required this.price,
    required this.date,
    required this.product,
  });

  factory ProductsData.fromJson(Map<String, dynamic> json) => ProductsData(
        id: json["id"],
        price: json["price"],
        date: DateTime.parse(json["date"]),
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "date": date.toIso8601String(),
        "product": product,
      };
}
