// To parse this JSON data, do
//
//     final profileEdite = profileEditeFromJson(jsonString);

import 'dart:convert';

ProfileEdite profileEditeFromJson(String str) => ProfileEdite.fromJson(json.decode(str));

String profileEditeToJson(ProfileEdite data) => json.encode(data.toJson());

class ProfileEdite {
  UserLogin userLogin;
  String responseCode;
  String result;
  String responseMsg;

  ProfileEdite({
    required this.userLogin,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory ProfileEdite.fromJson(Map<String, dynamic> json) => ProfileEdite(
    userLogin: UserLogin.fromJson(json["UserLogin"]),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "UserLogin": userLogin.toJson(),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class UserLogin {
  String id;
  String name;
  String mobile;
  String password;
  DateTime rdate;
  String status;
  String ccode;
  String code;
  dynamic refercode;
  String wallet;
  String email;

  UserLogin({
    required this.id,
    required this.name,
    required this.mobile,
    required this.password,
    required this.rdate,
    required this.status,
    required this.ccode,
    required this.code,
    required this.refercode,
    required this.wallet,
    required this.email,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
    id: json["id"],
    name: json["name"],
    mobile: json["mobile"],
    password: json["password"],
    rdate: DateTime.parse(json["rdate"]),
    status: json["status"],
    ccode: json["ccode"],
    code: json["code"],
    refercode: json["refercode"],
    wallet: json["wallet"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile": mobile,
    "password": password,
    "rdate": rdate.toIso8601String(),
    "status": status,
    "ccode": ccode,
    "code": code,
    "refercode": refercode,
    "wallet": wallet,
    "email": email,
  };
}
