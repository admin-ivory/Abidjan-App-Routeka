// To parse this JSON data, do
//
//     final faqlist = faqlistFromJson(jsonString);

import 'dart:convert';

Faqlist faqlistFromJson(String str) => Faqlist.fromJson(json.decode(str));

String faqlistToJson(Faqlist data) => json.encode(data.toJson());

class Faqlist {
  List<FaqDatum> faqData;
  String responseCode;
  String result;
  String responseMsg;

  Faqlist({
    required this.faqData,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory Faqlist.fromJson(Map<String, dynamic> json) => Faqlist(
    faqData: List<FaqDatum>.from(json["FaqData"].map((x) => FaqDatum.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "FaqData": List<dynamic>.from(faqData.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class FaqDatum {
  String id;
  String question;
  String answer;
  String status;

  FaqDatum({
    required this.id,
    required this.question,
    required this.answer,
    required this.status,
  });

  factory FaqDatum.fromJson(Map<String, dynamic> json) => FaqDatum(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "status": status,
  };
}
