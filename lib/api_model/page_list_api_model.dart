// To parse this JSON data, do
//
//     final pageList = pageListFromJson(jsonString);

import 'dart:convert';

PageList pageListFromJson(String str) => PageList.fromJson(json.decode(str));

String pageListToJson(PageList data) => json.encode(data.toJson());

class PageList {
  List<Pagelist> pagelist;
  String responseCode;
  String result;
  String responseMsg;

  PageList({
    required this.pagelist,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory PageList.fromJson(Map<String, dynamic> json) => PageList(
    pagelist: List<Pagelist>.from(json["pagelist"].map((x) => Pagelist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "pagelist": List<dynamic>.from(pagelist.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Pagelist {
  String title;
  String description;

  Pagelist({
    required this.title,
    required this.description,
  });

  factory Pagelist.fromJson(Map<String, dynamic> json) => Pagelist(
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
  };
}
