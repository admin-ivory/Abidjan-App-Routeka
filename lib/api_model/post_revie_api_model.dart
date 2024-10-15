// To parse this JSON data, do
//
//     final postreview = postreviewFromJson(jsonString);

import 'dart:convert';

Postreview postreviewFromJson(String str) => Postreview.fromJson(json.decode(str));

String postreviewToJson(Postreview data) => json.encode(data.toJson());

class Postreview {
  String responseCode;
  String result;
  String responseMsg;

  Postreview({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory Postreview.fromJson(Map<String, dynamic> json) => Postreview(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}
