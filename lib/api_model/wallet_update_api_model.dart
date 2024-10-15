// To parse this JSON data, do
//
//     final walletUpdate = walletUpdateFromJson(jsonString);

import 'dart:convert';

WalletUpdate walletUpdateFromJson(String str) => WalletUpdate.fromJson(json.decode(str));

String walletUpdateToJson(WalletUpdate data) => json.encode(data.toJson());

class WalletUpdate {
  String wallet;
  String responseCode;
  String result;
  String responseMsg;

  WalletUpdate({
    required this.wallet,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory WalletUpdate.fromJson(Map<String, dynamic> json) => WalletUpdate(
    wallet: json["wallet"],
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "wallet": wallet,
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}
