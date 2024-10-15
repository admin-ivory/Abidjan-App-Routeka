// To parse this JSON data, do
//
//     final payoutApi = payoutApiFromJson(jsonString);

import 'dart:convert';

PayoutApi payoutApiFromJson(String str) => PayoutApi.fromJson(json.decode(str));

String payoutApiToJson(PayoutApi data) => json.encode(data.toJson());

class PayoutApi {
  String responseCode;
  String result;
  String responseMsg;
  List<Payoutlist> payoutlist;

  PayoutApi({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.payoutlist,
  });

  factory PayoutApi.fromJson(Map<String, dynamic> json) => PayoutApi(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    payoutlist: List<Payoutlist>.from(json["Payoutlist"].map((x) => Payoutlist.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "Payoutlist": List<dynamic>.from(payoutlist.map((x) => x.toJson())),
  };
}

class Payoutlist {
  String payoutId;
  String amt;
  String status;
  dynamic proof;
  DateTime rDate;
  String rType;
  String accNumber;
  String bankName;
  String accName;
  String ifscCode;
  String upiId;
  String paypalId;

  Payoutlist({
    required this.payoutId,
    required this.amt,
    required this.status,
    required this.proof,
    required this.rDate,
    required this.rType,
    required this.accNumber,
    required this.bankName,
    required this.accName,
    required this.ifscCode,
    required this.upiId,
    required this.paypalId,
  });

  factory Payoutlist.fromJson(Map<String, dynamic> json) => Payoutlist(
    payoutId: json["payout_id"],
    amt: json["amt"],
    status: json["status"],
    proof: json["proof"],
    rDate: DateTime.parse(json["r_date"]),
    rType: json["r_type"],
    accNumber: json["acc_number"],
    bankName: json["bank_name"],
    accName: json["acc_name"],
    ifscCode: json["ifsc_code"],
    upiId: json["upi_id"],
    paypalId: json["paypal_id"],
  );

  Map<String, dynamic> toJson() => {
    "payout_id": payoutId,
    "amt": amt,
    "status": status,
    "proof": proof,
    "r_date": rDate.toIso8601String(),
    "r_type": rType,
    "acc_number": accNumber,
    "bank_name": bankName,
    "acc_name": accName,
    "ifsc_code": ifscCode,
    "upi_id": upiId,
    "paypal_id": paypalId,
  };
}
