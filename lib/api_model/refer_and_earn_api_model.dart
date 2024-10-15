// To parse this JSON data, do
//
//     final referearn = referearnFromJson(jsonString);

import 'dart:convert';

Referearn referearnFromJson(String str) => Referearn.fromJson(json.decode(str));

String referearnToJson(Referearn data) => json.encode(data.toJson());

class Referearn {
  String responseCode;
  String result;
  String responseMsg;
  String code;
  String signupcredit;
  String refercredit;
  String tax;

  Referearn({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.code,
    required this.signupcredit,
    required this.refercredit,
    required this.tax,
  });

  factory Referearn.fromJson(Map<String, dynamic> json) => Referearn(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    code: json["code"],
    signupcredit: json["signupcredit"],
    refercredit: json["refercredit"],
    tax: json["tax"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "code": code,
    "signupcredit": signupcredit,
    "refercredit": refercredit,
    "tax": tax,
  };
}
