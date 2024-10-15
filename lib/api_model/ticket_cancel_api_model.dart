// To parse this JSON data, do
//
//     final cancleTicket = cancleTicketFromJson(jsonString);

import 'dart:convert';

CancleTicket cancleTicketFromJson(String str) => CancleTicket.fromJson(json.decode(str));

String cancleTicketToJson(CancleTicket data) => json.encode(data.toJson());

class CancleTicket {
  String responseCode;
  String result;
  String responseMsg;

  CancleTicket({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory CancleTicket.fromJson(Map<String, dynamic> json) => CancleTicket(
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
