// To parse this JSON data, do
//
//     final homedata = homedataFromJson(jsonString);

import 'dart:convert';

Homedata homedataFromJson(String str) => Homedata.fromJson(json.decode(str));

String homedataToJson(Homedata data) => json.encode(data.toJson());

class Homedata {
  String responseCode;
  String result;
  String responseMsg;
  List<Tickethistory> tickethistory;
  List<Banner> banner;
  String isVerify;
  String isBlock;
  String withdrawLimit;
  String currency;
  String tax;

  Homedata({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.tickethistory,
    required this.banner,
    required this.isVerify,
    required this.isBlock,
    required this.withdrawLimit,
    required this.currency,
    required this.tax,
  });

  factory Homedata.fromJson(Map<String, dynamic> json) => Homedata(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    tickethistory: List<Tickethistory>.from(json["tickethistory"].map((x) => Tickethistory.fromJson(x))),
    banner: List<Banner>.from(json["banner"].map((x) => Banner.fromJson(x))),
    isVerify: json["is_verify"],
    isBlock: json["is_block"],
    withdrawLimit: json["withdraw_limit"],
    currency: json["currency"],
    tax: json["tax"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "tickethistory": List<dynamic>.from(tickethistory.map((x) => x.toJson())),
    "banner": List<dynamic>.from(banner.map((x) => x.toJson())),
    "is_verify": isVerify,
    "is_block": isBlock,
    "withdraw_limit": withdrawLimit,
    "currency": currency,
    "tax": tax,
  };
}

class Banner {
  String id;
  String img;

  Banner({
    required this.id,
    required this.img,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json["id"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "img": img,
  };
}

class Tickethistory {
  String ticketId;
  String busName;
  String busNo;
  String busImg;
  String isAc;
  String ticketPrice;
  String boardingCity;
  String dropCity;
  String busPicktime;
  String busDroptime;
  String differencePickDrop;

  Tickethistory({
    required this.ticketId,
    required this.busName,
    required this.busNo,
    required this.busImg,
    required this.isAc,
    required this.ticketPrice,
    required this.boardingCity,
    required this.dropCity,
    required this.busPicktime,
    required this.busDroptime,
    required this.differencePickDrop,
  });

  factory Tickethistory.fromJson(Map<String, dynamic> json) => Tickethistory(
    ticketId: json["ticket_id"],
    busName: json["bus_name"],
    busNo: json["bus_no"],
    busImg: json["bus_img"],
    isAc: json["is_ac"],
    ticketPrice: json["ticket_price"],
    boardingCity: json["boarding_city"],
    dropCity: json["drop_city"],
    busPicktime: json["bus_picktime"],
    busDroptime: json["bus_droptime"],
    differencePickDrop: json["Difference_pick_drop"],
  );

  Map<String, dynamic> toJson() => {
    "ticket_id": ticketId,
    "bus_name": busName,
    "bus_no": busNo,
    "bus_img": busImg,
    "is_ac": isAc,
    "ticket_price": ticketPrice,
    "boarding_city": boardingCity,
    "drop_city": dropCity,
    "bus_picktime": busPicktime,
    "bus_droptime": busDroptime,
    "Difference_pick_drop": differencePickDrop,
  };
}
