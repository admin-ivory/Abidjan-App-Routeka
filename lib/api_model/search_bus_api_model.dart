// To parse this JSON data, do
//
//     final searchBus = searchBusFromJson(jsonString);

import 'dart:convert';

SearchBus searchBusFromJson(String str) => SearchBus.fromJson(json.decode(str));

String searchBusToJson(SearchBus data) => json.encode(data.toJson());

class SearchBus {
  List<BusDatum> busData;
  String currency;
  String responseCode;
  String result;
  String responseMsg;

  SearchBus({
    required this.busData,
    required this.currency,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory SearchBus.fromJson(Map<String, dynamic> json) => SearchBus(
    busData: List<BusDatum>.from(json["BusData"].map((x) => BusDatum.fromJson(x))),
    currency: json["currency"],
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "BusData": List<dynamic>.from(busData.map((x) => x.toJson())),
    "currency": currency,
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class BusDatum {
  String busId;
  String idPickupDrop;
  String busTitle;
  String busNo;
  String busImg;
  String agentCommission;
  String busPicktime;
  String busDroptime;
  String boardingCity;
  String dropCity;
  String busRate;
  String differencePickDrop;
  String ticketPrice;
  String decker;
  String leftSeat;
  String totlSeat;
  String bookLimit;
  String busAc;
  String isSleeper;
  int totalReview;
  List<BusFacility> busFacilities;

  BusDatum({
    required this.busId,
    required this.idPickupDrop,
    required this.busTitle,
    required this.busNo,
    required this.busImg,
    required this.agentCommission,
    required this.busPicktime,
    required this.busDroptime,
    required this.boardingCity,
    required this.dropCity,
    required this.busRate,
    required this.differencePickDrop,
    required this.ticketPrice,
    required this.decker,
    required this.leftSeat,
    required this.totlSeat,
    required this.bookLimit,
    required this.busAc,
    required this.isSleeper,
    required this.totalReview,
    required this.busFacilities,
  });

  factory BusDatum.fromJson(Map<String, dynamic> json) => BusDatum(
    busId: json["bus_id"],
    idPickupDrop: json["id_pickup_drop"],
    busTitle: json["bus_title"],
    busNo: json["bus_no"],
    busImg: json["bus_img"],
    agentCommission: json["agent_commission"],
    busPicktime: json["bus_picktime"],
    busDroptime: json["bus_droptime"],
    boardingCity: json["boarding_city"],
    dropCity: json["drop_city"],
    busRate: json["bus_rate"],
    differencePickDrop: json["Difference_pick_drop"],
    ticketPrice: json["ticket_price"],
    decker: json["decker"],
    leftSeat: json["left_seat"],
    totlSeat: json["totl_seat"],
    bookLimit: json["book_limit"],
    busAc: json["bus_ac"],
    isSleeper: json["is_sleeper"],
    totalReview: json["total_review"],
    busFacilities: List<BusFacility>.from(json["bus_facilities"].map((x) => BusFacility.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bus_id": busId,
    "id_pickup_drop": idPickupDrop,
    "bus_title": busTitle,
    "bus_no": busNo,
    "bus_img": busImg,
    "agent_commission": agentCommission,
    "bus_picktime": busPicktime,
    "bus_droptime": busDroptime,
    "boarding_city": boardingCity,
    "drop_city": dropCity,
    "bus_rate": busRate,
    "Difference_pick_drop": differencePickDrop,
    "ticket_price": ticketPrice,
    "decker": decker,
    "left_seat": leftSeat,
    "totl_seat": totlSeat,
    "book_limit": bookLimit,
    "bus_ac": busAc,
    "is_sleeper": isSleeper,
    "total_review": totalReview,
    "bus_facilities": List<dynamic>.from(busFacilities.map((x) => x.toJson())),
  };
}

class BusFacility {
  String facilityname;
  String facilityimg;

  BusFacility({
    required this.facilityname,
    required this.facilityimg,
  });

  factory BusFacility.fromJson(Map<String, dynamic> json) => BusFacility(
    facilityname: json["facilityname"],
    facilityimg: json["facilityimg"],
  );

  Map<String, dynamic> toJson() => {
    "facilityname": facilityname,
    "facilityimg": facilityimg,
  };
}
