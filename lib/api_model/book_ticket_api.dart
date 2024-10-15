// To parse this JSON data, do
//
//     final ticketBookApi = ticketBookApiFromJson(jsonString);

import 'dart:convert';

TicketBookApi ticketBookApiFromJson(String str) => TicketBookApi.fromJson(json.decode(str));

String ticketBookApiToJson(TicketBookApi data) => json.encode(data.toJson());

class TicketBookApi {
  String responseCode;
  String result;
  String responseMsg;
  String wallet;

  TicketBookApi({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.wallet,
  });

  factory TicketBookApi.fromJson(Map<String, dynamic> json) => TicketBookApi(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    wallet: json["wallet"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "wallet": wallet,
  };
}
