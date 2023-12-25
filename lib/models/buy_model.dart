// To parse this JSON data, do
//
//     final buyModle = buyModleFromJson(jsonString);

import 'dart:convert';

BuyModle buyModleFromJson(String str) => BuyModle.fromJson(json.decode(str));

String buyModleToJson(BuyModle data) => json.encode(data.toJson());

class BuyModle {
  int status;
  String? message;
  Info info;

  BuyModle({
    required this.status,
    required this.message,
    required this.info,
  });

  factory BuyModle.fromJson(Map<String, dynamic> json) => BuyModle(
        status: json["status"],
        message: json["message"],
        info: Info.fromJson(json["info"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "info": info.toJson(),
      };
}

class Info {
  int product;
  String firstname;
  String lastname;
  String email;
  String contact;
  String subject;
  String message;

  Info({
    required this.product,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.contact,
    required this.subject,
    required this.message,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        product: json["product"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        contact: json["contact"],
        subject: json["subject"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "product": product,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "contact": contact,
        "subject": subject,
        "message": message,
      };
}
