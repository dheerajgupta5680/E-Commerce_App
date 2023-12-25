// To parse this JSON data, do
//
//     final updateProfileModle = updateProfileModleFromJson(jsonString);

import 'dart:convert';

UpdateProfileModle updateProfileModleFromJson(String str) =>
    UpdateProfileModle.fromJson(json.decode(str));

String updateProfileModleToJson(UpdateProfileModle data) =>
    json.encode(data.toJson());

class UpdateProfileModle {
  int status;
  String? message;
  Data data;

  UpdateProfileModle({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdateProfileModle.fromJson(Map<String, dynamic> json) =>
      UpdateProfileModle(
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
  String token;
  String fname;
  String lname;
  String email;
  String phone;
  String username;
  String img;

  Data({
    required this.token,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.username,
    required this.img,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        fname: json["fname"],
        lname: json["lname"],
        email: json["email"],
        phone: json["phone"],
        username: json["username"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "fname": fname,
        "lname": lname,
        "email": email,
        "phone": phone,
        "username": username,
        "img": img,
      };
}
