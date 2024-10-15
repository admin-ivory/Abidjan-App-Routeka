// To parse this JSON data, do
//
//     final referdata = referdataFromJson(jsonString);

import 'dart:convert';

Referdata referdataFromJson(String str) => Referdata.fromJson(json.decode(str));

String referdataToJson(Referdata data) => json.encode(data.toJson());

class Referdata {
  String responseCode;
  String result;
  String responseMsg;
  String code;
  String signupcredit;
  String refercredit;
  String tax;


  Referdata({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.code,
    required this.signupcredit,
    required this.refercredit,
    required this.tax,
  });

  factory Referdata.fromJson(Map<String, dynamic> json) => Referdata(
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
