// To parse this JSON data, do
//
//     final sellModle = sellModleFromJson(jsonString);

import 'dart:convert';

SellModle sellModleFromJson(String str) => SellModle.fromJson(json.decode(str));

String sellModleToJson(SellModle data) => json.encode(data.toJson());

class SellModle {
  int status;
  String message;
  Info info;

  SellModle({
    required this.status,
    required this.message,
    required this.info,
  });

  factory SellModle.fromJson(Map<String, dynamic> json) => SellModle(
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
