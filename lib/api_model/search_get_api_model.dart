// To parse this JSON data, do
//
//     final fromtoModel = fromtoModelFromJson(jsonString);

import 'dart:convert';

FromtoModel fromtoModelFromJson(String str) => FromtoModel.fromJson(json.decode(str));

String fromtoModelToJson(FromtoModel data) => json.encode(data.toJson());

class FromtoModel {
  List<Citylist> citylist;
  String responseCode;
  String result;
  String responseMsg;

  FromtoModel({
    required this.citylist,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory FromtoModel.fromJson(Map<String, dynamic> json) => FromtoModel(
    citylist: List<Citylist>.from(json["citylist"].map((x) => Citylist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "citylist": List<dynamic>.from(citylist.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Citylist {
  String id;
  String title;


  Citylist({
    required this.id,
    required this.title,
  });

  factory Citylist.fromJson(Map<String, dynamic> json) => Citylist(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
