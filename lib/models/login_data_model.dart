// To parse this JSON data, do
//
//     final loginDataModel = loginDataModelFromJson(jsonString);

import 'dart:convert';

LoginDataModel loginDataModelFromJson(String str) =>
    LoginDataModel.fromJson(json.decode(str));

String loginDataModelToJson(LoginDataModel data) => json.encode(data.toJson());

class LoginDataModel {
  int? status;
  String? message;
  User? user;

  LoginDataModel({
    this.status,
    this.message,
    this.user,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) => LoginDataModel(
        status: json["status"],
        message: json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user": user?.toJson(),
      };
}

class User {
  String? token;
  String? fname;
  String? lname;
  String? email;
  String? phone;
  String? username;
  String? img;
  bool? isAdmin;

  User({
    this.token,
    this.fname,
    this.lname,
    this.email,
    this.phone,
    this.username,
    this.img,
    this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        isAdmin: json["is_admin"] ?? false,
        token: json["token"],
        fname: json["fname"],
        lname: json["lname"],
        email: json["email"],
        phone: json["phone"],
        username: json["username"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "is_admin": isAdmin,
        "token": token,
        "fname": fname,
        "lname": lname,
        "email": email,
        "phone": phone,
        "username": username,
        "img": img,
      };
}




//-----
