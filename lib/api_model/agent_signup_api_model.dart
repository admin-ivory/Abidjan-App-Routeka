// To parse this JSON data, do
//
//     final agentsignup = agentsignupFromJson(jsonString);

import 'dart:convert';

Agentsignup agentsignupFromJson(String str) => Agentsignup.fromJson(json.decode(str));

String agentsignupToJson(Agentsignup data) => json.encode(data.toJson());

class Agentsignup {
  String responseCode;
  String result;
  String responseMsg;
  String agentStatus;

  Agentsignup({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.agentStatus,
  });

  factory Agentsignup.fromJson(Map<String, dynamic> json) => Agentsignup(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    agentStatus: json["agent_status"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "agent_status": agentStatus,
  };
}
