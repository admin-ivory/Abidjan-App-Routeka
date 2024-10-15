// To parse this JSON data, do
//
//     final requestWithdraw = requestWithdrawFromJson(jsonString);

import 'dart:convert';

RequestWithdraw requestWithdrawFromJson(String str) => RequestWithdraw.fromJson(json.decode(str));

String requestWithdrawToJson(RequestWithdraw data) => json.encode(data.toJson());

class RequestWithdraw {
  String responseCode;
  String result;
  String responseMsg;

  RequestWithdraw({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory RequestWithdraw.fromJson(Map<String, dynamic> json) => RequestWithdraw(
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
