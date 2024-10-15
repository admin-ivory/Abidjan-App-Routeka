// To parse this JSON data, do
//
//     final newrequist = newrequistFromJson(jsonString);

import 'dart:convert';

Newrequist newrequistFromJson(String str) => Newrequist.fromJson(json.decode(str));

String newrequistToJson(Newrequist data) => json.encode(data.toJson());

class Newrequist {
  String responseCode;
  String result;
  String responseMsg;
  List<Tickethistory> tickethistory;

  Newrequist({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.tickethistory,
  });

  factory Newrequist.fromJson(Map<String, dynamic> json) => Newrequist(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    tickethistory: List<Tickethistory>.from(json["tickethistory"].map((x) => Tickethistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "tickethistory": List<dynamic>.from(tickethistory.map((x) => x.toJson())),
  };
}

class Tickethistory {
  String ticketId;
  String busName;
  String busNo;
  String driverMobile;
  String driverName;
  String busImg;
  int cancleShow;
  String isAc;
  String ticketPrice;
  String boardingCity;
  String dropCity;
  String busPicktime;
  String busDroptime;
  String differencePickDrop;
  String totalSeat;
  String couAmt;
  String wallAmt;
  DateTime bookDate;
  String total;
  String isRate;
  String subtotal;
  String tax;
  String taxAmt;
  String transactionId;
  String pMethodName;
  String contactName;
  String contactEmail;
  String contactMobile;
  String subPickTime;
  String subPickPlace;
  String subPickAddress;
  String subPickMobile;
  String subDropTime;
  String subDropPlace;
  String subDropAddress;
  List<OrderProductDatum> orderProductData;

  Tickethistory({
    required this.ticketId,
    required this.busName,
    required this.busNo,
    required this.driverMobile,
    required this.driverName,
    required this.busImg,
    required this.cancleShow,
    required this.isAc,
    required this.ticketPrice,
    required this.boardingCity,
    required this.dropCity,
    required this.busPicktime,
    required this.busDroptime,
    required this.differencePickDrop,
    required this.totalSeat,
    required this.couAmt,
    required this.wallAmt,
    required this.bookDate,
    required this.total,
    required this.isRate,
    required this.subtotal,
    required this.tax,
    required this.taxAmt,
    required this.transactionId,
    required this.pMethodName,
    required this.contactName,
    required this.contactEmail,
    required this.contactMobile,
    required this.subPickTime,
    required this.subPickPlace,
    required this.subPickAddress,
    required this.subPickMobile,
    required this.subDropTime,
    required this.subDropPlace,
    required this.subDropAddress,
    required this.orderProductData,
  });

  factory Tickethistory.fromJson(Map<String, dynamic> json) => Tickethistory(
    ticketId: json["ticket_id"],
    busName: json["bus_name"],
    busNo: json["bus_no"],
    driverMobile: json["driver_mobile"],
    driverName: json["driver_name"],
    busImg: json["bus_img"],
    cancleShow: json["cancle_show"],
    isAc: json["is_ac"],
    ticketPrice: json["ticket_price"],
    boardingCity: json["boarding_city"],
    dropCity: json["drop_city"],
    busPicktime: json["bus_picktime"],
    busDroptime: json["bus_droptime"],
    differencePickDrop: json["Difference_pick_drop"],
    totalSeat: json["total_seat"],
    couAmt: json["cou_amt"],
    wallAmt: json["wall_amt"],
    bookDate: DateTime.parse(json["book_date"]),
    total: json["total"],
    isRate: json["is_rate"],
    subtotal: json["subtotal"],
    tax: json["tax"],
    taxAmt: json["tax_amt"],
    transactionId: json["transaction_id"],
    pMethodName: json["p_method_name"],
    contactName: json["contact_name"],
    contactEmail: json["contact_email"],
    contactMobile: json["contact_mobile"],
    subPickTime: json["sub_pick_time"],
    subPickPlace: json["sub_pick_place"],
    subPickAddress: json["sub_pick_address"],
    subPickMobile: json["sub_pick_mobile"],
    subDropTime: json["sub_drop_time"],
    subDropPlace: json["sub_drop_place"],
    subDropAddress: json["sub_drop_address"],
    orderProductData: List<OrderProductDatum>.from(json["Order_Product_Data"].map((x) => OrderProductDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ticket_id": ticketId,
    "bus_name": busName,
    "bus_no": busNo,
    "driver_mobile": driverMobile,
    "driver_name": driverName,
    "bus_img": busImg,
    "cancle_show": cancleShow,
    "is_ac": isAc,
    "ticket_price": ticketPrice,
    "boarding_city": boardingCity,
    "drop_city": dropCity,
    "bus_picktime": busPicktime,
    "bus_droptime": busDroptime,
    "Difference_pick_drop": differencePickDrop,
    "total_seat": totalSeat,
    "cou_amt": couAmt,
    "wall_amt": wallAmt,
    "book_date": "${bookDate.year.toString().padLeft(4, '0')}-${bookDate.month.toString().padLeft(2, '0')}-${bookDate.day.toString().padLeft(2, '0')}",
    "total": total,
    "is_rate": isRate,
    "subtotal": subtotal,
    "tax": tax,
    "tax_amt": taxAmt,
    "transaction_id": transactionId,
    "p_method_name": pMethodName,
    "contact_name": contactName,
    "contact_email": contactEmail,
    "contact_mobile": contactMobile,
    "sub_pick_time": subPickTime,
    "sub_pick_place": subPickPlace,
    "sub_pick_address": subPickAddress,
    "sub_pick_mobile": subPickMobile,
    "sub_drop_time": subDropTime,
    "sub_drop_place": subDropPlace,
    "sub_drop_address": subDropAddress,
    "Order_Product_Data": List<dynamic>.from(orderProductData.map((x) => x.toJson())),
  };
}

class OrderProductDatum {
  String name;
  String age;
  String gender;
  String seatNo;

  OrderProductDatum({
    required this.name,
    required this.age,
    required this.gender,
    required this.seatNo,
  });

  factory OrderProductDatum.fromJson(Map<String, dynamic> json) => OrderProductDatum(
    name: json["name"],
    age: json["age"],
    gender: json["gender"],
    seatNo: json["seat_no"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "age": age,
    "gender": gender,
    "seat_no": seatNo,
  };
}
