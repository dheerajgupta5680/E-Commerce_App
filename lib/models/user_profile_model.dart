// To parse this JSON data, do
//
//     final userProfileModle = userProfileModleFromJson(jsonString);

import 'dart:convert';

UserProfileModle userProfileModleFromJson(String str) =>
    UserProfileModle.fromJson(json.decode(str));

String userProfileModleToJson(UserProfileModle data) =>
    json.encode(data.toJson());

class UserProfileModle {
  int status;
  String message;
  User user;

  UserProfileModle({
    required this.status,
    required this.message,
    required this.user,
  });

  factory UserProfileModle.fromJson(Map<String, dynamic> json) =>
      UserProfileModle(
        status: json["status"],
        message: json["message"],
        user: json["user"] != null
            ? User.fromJson(json["user"])
            : User(
                token: "",
                fname: "",
                lname: "",
                email: "",
                phone: "",
                username: "",
                img: "",
                isAdmin: false,
              ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user": user.toJson(),
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
    required this.token,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.username,
    required this.img,
    required this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        isAdmin: json["is_admin"] ?? false,
        token: json["token"] ?? "",
        fname: json["fname"] ?? "",
        lname: json["lname"] ?? "",
        email: json["email"] ?? "",
        phone: json["phone"] ?? "",
        username: json["username"] ?? "",
        img: json["img"] ?? "",
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
