// ignore_for_file: camel_case_types, file_names, depend_on_referenced_packages, unused_local_variable, unused_field, non_constant_identifier_names, avoid_print, use_super_parameters, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../API_MODEL/set_api_model.dart';
import '../Common_Code/common_button.dart';
import '../config/config.dart';
import '../config/light_and_dark.dart';
import 'set_location_screen.dart';


class Seat_Book_ extends StatefulWidget {
  final String busTitle;
  final String uid;
  final String bus_id;
  final String trip_date;
  final String boardingCity;
  final String dropCity;
  final String id_pickup_drop;
  final String to;
  final String from;
  final String busImg;
  final String ticketPrice;
  final String busPicktime;
  final String busDroptime;
  final String busRate;
  final String busAc;
  final String isSleeper;
  final String totlSeat;
  final String differencePickDrop;
  final String currency;
  final String boarding_id;
  final String drop_id;
  final String Difference_pick_drop;
  final String agentCommission;
  final String com_per;
  final String is_verify;


  const Seat_Book_({Key? key, required this.busTitle,  required this.trip_date, required this.uid, required this.bus_id, required this.boardingCity, required this.dropCity, required this.id_pickup_drop, required this.to, required this.from, required this.busImg, required this.ticketPrice, required this.busPicktime, required this.busDroptime, required this.busRate, required this.busAc, required this.isSleeper, required this.totlSeat, required this.differencePickDrop, required this.currency, required this.boarding_id, required this.drop_id, required this.Difference_pick_drop, required this.agentCommission, required this.com_per, required this.is_verify}) : super(key: key);

  @override
  State<Seat_Book_> createState() => _Seat_Book_State();
}

class _Seat_Book_State extends State<Seat_Book_> {
  List selectIndex = [];
  List selectIndex1 = [];

  String uid = "";
  Buslayout?  data;
  var daat;

  Future searchBusApi(String uid,bus_id,trip_date) async {

    Map body = {
      'uid' : uid,
      'bus_id' : bus_id,
      'trip_date' : trip_date,
    };

    print("+++ $body");

    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/bus_layout.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){
        setState(() {
          daat = response.body;
          data = buslayoutFromJson(response.body);
          isloading = false;
          print("////////////////////////1254638455///////////////////////////////////////////${widget.busPicktime}");

        });
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }



  List seledctSite = [];

  @override
  void initState() {
    _resetSelectedDate();
    searchBusApi(widget.uid, widget.bus_id, widget.trip_date.toString().split(" ").first).then((value) {
      var decode = jsonDecode(daat);

    print( widget.trip_date);
    });
    super.initState();
  }

  num bottom = 0;
  List list = [];
  late DateTime _selectedDate;
  void _resetSelectedDate() {
    print(DateTime.parse(widget.trip_date));
    _selectedDate = (DateTime.parse(widget.trip_date)).add(const Duration(seconds: 1));
  }

  List selectset = [];
  List selectset1 = [];

  bool isloading = true;

  ScrollController scroll = ScrollController();
  ColorNotifier notifier = ColorNotifier();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      bottomNavigationBar: bottom == 0 ? const SizedBox() : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: notifier.containercoloreproper,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft:Radius.circular(10))
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5,left: 10,right: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                        data!.busLayoutData[0].upperLayout.isEmpty ? Column(
                        crossAxisAlignment:  CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Text('Lower Seat'.tr,style:  TextStyle(color: notifier.textColor,fontSize: 15),),
                                    Text('-(${selectset.length}) -'.tr,style:  TextStyle(color: notifier.textColor,fontSize: 15),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                                Flexible(child: Text(selectset.join(","),style:  TextStyle(color: notifier.textColor,fontSize: 15),maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                        ],
                      ) : Column(
                        crossAxisAlignment:  CrossAxisAlignment.start,
                        children: [
                          selectset.isEmpty?  const SizedBox(): SizedBox(
                            width: MediaQuery.of(context).size.width/1.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Lower Seat'.tr,style:  TextStyle(color: notifier.textColor,fontSize: 15),),
                                    Text('-(${selectset.length}) -'.tr,style:  TextStyle(color: notifier.textColor,fontSize: 15),maxLines: 2,overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                                Flexible(child: Text(selectset.join(","),style:  TextStyle(color: notifier.textColor,fontSize: 15),maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5,),
                          selectset1.isEmpty?  const SizedBox(): SizedBox(
                            width: MediaQuery.of(context).size.width/1.5,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Text('Upper Seat'.tr,style:  TextStyle(color: notifier.textColor,fontSize: 15),),
                                    Text('-(${selectset1.length}) -'.tr,style:  TextStyle(color: notifier.textColor,fontSize: 15),maxLines: 2,overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                                Flexible(child: Text(selectset1.join(","),style:  TextStyle(color: notifier.textColor,fontSize: 15),maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 10,),
                      const Spacer(),
                      Text("${widget.currency} ${bottom.toStringAsFixed(2)}",style:  TextStyle(color: notifier.textColor,fontWeight: FontWeight.bold,fontSize: 17)),

                    ],
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: CommonButton(containcolore: notifier.theamcolorelight,txt1: 'PROCEED'.tr,context: context,onPressed1: () {
                      print("${selectset.length+selectset1.length}");
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  Set_Location(is_verify: widget.is_verify,agentCommission: widget.agentCommission,com_per: widget.com_per,Difference_pick_drop: widget.differencePickDrop,boarding_id: widget.boarding_id,drop_id: widget.drop_id,bus_id: widget.bus_id,currency: widget.currency,busAc: widget.busAc,differencePickDrop: widget.differencePickDrop,totlSeat: widget.totlSeat,isSleeper: widget.isSleeper,trip_date: widget.trip_date,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,boardingCity: widget.boardingCity,dropCity: widget.dropCity,ticketPrice: widget.ticketPrice,busImg: widget.busImg,bottom: double.parse(bottom.toStringAsFixed(2)),selectset1: selectset1,selectset: selectset,length: selectset.length + selectset1.length,from: widget.from,to: widget.to,uid: widget.uid,id_pickup_drop: widget.id_pickup_drop,busTitle: widget.busTitle,wallet: data!.wallet),));
                    },),
                  ),
                  const SizedBox(height: 10,)
                ],
              ),
            ),
          )
        ],
      ),
      // backgroundColor: Colors.grey[300],
      backgroundColor: notifier.backgroundgray,
      appBar: AppBar(
        toolbarHeight: 70,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: notifier.appbarcolore,
        title: Transform.translate(
          offset: const Offset(-15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.busTitle,style: const TextStyle(color: Colors.white,fontSize: 13)),
              const SizedBox(height: 5,),
              // Text('${widget.trip_date.toString().split(" ").first}',style: const TextStyle(color: Colors.white,fontSize: 15),),
              Text(widget.trip_date.toString().split(" ").first,style: const TextStyle(color: Colors.white,fontSize: 12),),
              const SizedBox(height: 5,),
              Text('${widget.boardingCity} - ${widget.dropCity}',style: const TextStyle(color: Colors.white,fontSize: 12),),
              // const SizedBox(height: 3,),
            ],
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              children: [
                const SizedBox(height: 7,),
                Container(
                  height: 20,
                  width: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFB733),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(child: Row(
                    children: [
                      const Spacer(),
                      const Icon(Icons.star,color: Colors.white,size: 12),
                      const SizedBox(width: 2,),
                      Text(widget.busRate,style: const TextStyle(fontSize: 12)),
                      const Spacer(),
                    ],
                  )),
                ),
                const SizedBox(height: 5,),
                 Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: InkWell(
                      onTap: () {
                      widget.isSleeper == '1' ?  Get.bottomSheet(isScrollControlled: true,StatefulBuilder(
                            builder: (context, setState)  {
                              return Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Container(
                                  // height: 200,
                                  decoration:  BoxDecoration(
                                    color: notifier.containercoloreproper,
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                                  ),
                                  child:  Padding(
                                    padding:  const EdgeInsets.only(left: 10,right: 10,top: 10),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 10,),
                                          Text('Know about seat types'.tr,style: TextStyle(fontSize: 20,fontFamily: 'SofiaProBold',color: notifier.textColor),),
                                          const SizedBox(height: 20,),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Image(image: AssetImage('assets/selections 2.png'),height: 50,width: 50,),
                                                  const SizedBox(width: 10,),
                                                  Text('Available'.tr,style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              const SizedBox(height: 20,),
                                              Row(
                                                children: [
                                                  const Image(image: AssetImage('assets/selection_set.png'),height: 50,width: 50,),
                                                  const SizedBox(width: 10,),
                                                  Text('Booked by Others'.tr,style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              const SizedBox(height: 20,),
                                              Row(
                                                children: [
                                                  const Image(image: AssetImage('assets/selections 1.png'),height: 50,width: 50,),
                                                  const SizedBox(width: 10,),
                                                  Text('Selected by you'.tr,style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              const SizedBox(height: 20,),
                                              Row(
                                                children: [
                                                  const Image(image: AssetImage('assets/Ldise_Set.png'),height: 50,width: 50,),
                                                  const SizedBox(width: 10,),
                                                  Text('Booked by female passenger'.tr,style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              const SizedBox(height: 20,),
                                            ],
                                          ),
                                          const SizedBox(height: 20,),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        )) : Get.bottomSheet(isScrollControlled: true,StatefulBuilder(
                          builder: (context, setState)  {
                            return Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Container(
                                // height: 200,
                                decoration:  BoxDecoration(
                                  color: notifier.containercoloreproper,
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                                ),
                                child:  Padding(
                                  padding:  const EdgeInsets.only(left: 10,right: 10,top: 10),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 10,),
                                        Text('Know about seat types'.tr,style: TextStyle(fontSize: 20,fontFamily: 'SofiaProBold',color: notifier.textColor),),
                                        const SizedBox(height: 20,),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Image(image: AssetImage('assets/Available.png'),height: 50,width: 50,),
                                                const SizedBox(width: 10,),
                                                Text('Available'.tr,style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                            const SizedBox(height: 20,),
                                            Row(
                                              children: [
                                                const Image(image: AssetImage('assets/Selec_Sit_Setter.png'),height: 50,width: 50,),
                                                const SizedBox(width: 10,),
                                                Text('Booked by Others'.tr,style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                            const SizedBox(height: 20,),
                                            Row(
                                              children: [
                                                const Image(image: AssetImage('assets/Selected By you.png'),height: 50,width: 50,),
                                                const SizedBox(width: 10,),
                                                Text('Selected by you'.tr,style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                            const SizedBox(height: 20,),
                                            Row(
                                              children: [
                                                const Image(image: AssetImage('assets/Booked by female passenger.png'),height: 50,width: 50,),
                                                const SizedBox(width: 10,),
                                                Text('Booked by female passenger'.tr,style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                            const SizedBox(height: 20,),
                                          ],
                                        ),
                                        const SizedBox(height: 20,),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                      ));
                      },
                      child: const Image(image: AssetImage('assets/info-circle1.png'),color: Colors.white,height: 20,width: 20,)),
                )
              ],
            ),
          ),
        ],
        elevation: 0,
      ),
      body: isloading ?  Center(child: CircularProgressIndicator(color: notifier.theamcolorelight)) :  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 5,),

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    data!.busLayoutData[0].upperLayout.isEmpty ?   Container(
                      // height: 650,
                      width: double.parse((57 * data!.busLayoutData[0].lowerLayout[0].length).toString()),
                      decoration: BoxDecoration(
                          color: notifier.containercoloreproper,
                          // color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            if(data!.busLayoutData[0].driverDirection == "0")
                              lowwer()
                            else
                              lowwerRiverse(),

                            const Divider(color: Colors.black,),


                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: data?.busLayoutData[0].lowerLayout.length,
                                itemBuilder: (BuildContext context, int index1) {

                                  return SizedBox(
                                    height: 60,
                                    width: 100,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: data?.busLayoutData[0].lowerLayout[0].length,
                                        itemBuilder: (BuildContext context, int index) {

                                          return data?.busLayoutData[0].lowerLayout[index1][index].seatNumber == "" ?  Container(
                                            width: 35,
                                            margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                          ) : InkWell(
                                            onTap: () {

                                              print(index+index1);
                                              setState(() {
                                                print(data!.busLayoutData[0].lowerLayout[0][index].seatNumber);

                                                if(data!.busLayoutData[0].lowerLayout[index1][index].isBooked) {


                                                  if (data!.busLayoutData[0].lowerLayout[index1][index].gender == 'FEMALE'){
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content:  Text('Booked by Female passenger'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                    );
                                                  }else{
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content:  Text('Booked by Others'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                    );
                                                  }

                                                }else{
                                                  if (selectset.contains(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber) == true) {
                                                    setState(() {
                                                      bottom -= double.parse(data!.busLayoutData[0].ticketPrice);
                                                      selectset.remove(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber);
                                                    });
                                                  }
                                                  else {
                                                    if (selectset.length + selectset1.length == int.parse(data!.busLayoutData[0].bookLimit)) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('You can not add more than ${data!.busLayoutData[0].bookLimit} passengers to a single booking with this operator'), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                      );
                                                    } else {
                                                      setState(() {
                                                        print("-*+-+-+-+*---+--+-${data!.busLayoutData[0].ticketPrice}");
                                                        bottom += double.parse(data!.busLayoutData[0].ticketPrice.toString());
                                                        // selectset.add("$index1 - $index");
                                                        selectset.add(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber);
                                                      });
                                                    }
                                                  }
                                                }
                                              });
                                            },
                                            child:  widget.isSleeper == '1' ?    Container(
                                              height: 60,
                                              width: 35,
                                              margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                              decoration: BoxDecoration(
                                                  image:data!.busLayoutData[0].lowerLayout[index1][index].gender=='FEMALE' ? const DecorationImage(image: AssetImage('assets/Ldise_Set.png'),fit: BoxFit.fill): data!.busLayoutData[0].lowerLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage('assets/selection_set.png'),fit: BoxFit.fill) :  selectset.contains(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage('assets/selections 1.png'),fit: BoxFit.fill) : const DecorationImage(image: AssetImage('assets/selections 2.png'),fit: BoxFit.fill)
                                              ),
                                              child: Center(child: Text(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber,style: const TextStyle(fontSize: 10,color: Colors.grey),)),
                                            ) : Container(
                                              height: 46,
                                              width: 45,
                                              margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                              decoration: BoxDecoration(
                                                  image: data!.busLayoutData[0].lowerLayout[index1][index].gender=='FEMALE' ? const DecorationImage(image: AssetImage('assets/Booked by female passenger.png'),fit: BoxFit.fill): data!.busLayoutData[0].lowerLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage('assets/Selec_Sit_Setter.png'),fit: BoxFit.fill) :  selectset.contains(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage('assets/Selected By you.png'),fit: BoxFit.fill) : const DecorationImage(image: AssetImage('assets/Available.png'),fit: BoxFit.fill)
                                              ),
                                              child: Center(child: Text(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber,style: const TextStyle(fontSize: 10,color: Colors.grey),)),
                                            ),
                                          );
                                        }),
                                  );
                                }),
                          ],
                        ),
                      ),
                    )  : Container(
                      // height: 650,
                      width: widget.isSleeper == '1' ?   double.parse((50 * data!.busLayoutData[0].lowerLayout[0].length).toString()) : double.parse((61 * data!.busLayoutData[0].lowerLayout[0].length).toString()),
                      // width: 175 ,
                      decoration: BoxDecoration(
                          color: notifier.containercoloreproper,
                          borderRadius: BorderRadius.circular(5),
                      ),
                      child:   Padding(
                        padding:  const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            if(data!.busLayoutData[0].driverDirection == "0")
                               lowwer()
                            else
                              lowwerRiverse(),

                            const Divider(color: Colors.black,),



                            ListView.builder(
                              physics:  const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: data?.busLayoutData[0].lowerLayout.length,
                                itemBuilder: (BuildContext context, int index1) {

                                  return SizedBox(
                                    height:  widget.isSleeper == '1' ?  80 : 58,
                                    width: 100,
                                    child: ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: data?.busLayoutData[0].lowerLayout[0].length,
                                        itemBuilder: (BuildContext context, int index) {


                                          return data?.busLayoutData[0].lowerLayout[index1][index].seatNumber == "" ?  Container(
                                            height: 60,
                                            width: widget.isSleeper == '1' ?  35 : 45,
                                            margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                          ) : InkWell(
                                            onTap: () {
                                              setState(() {
                                                print(data!.busLayoutData[0].lowerLayout[0][index].seatNumber);

                                                if(data!.busLayoutData[0].lowerLayout[index1][index].isBooked) {

                                                  if (data!.busLayoutData[0].lowerLayout[index1][index].gender == 'FEMALE'){
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content:  Text('Booked by Female passenger'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                    );
                                                  }else{
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content:  Text('Booked by Others'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                    );
                                                  }



                                                }else {
                                                  if (selectset.contains(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber) == true) {
                                                    setState(() {
                                                      bottom -= double.parse(data!.busLayoutData[0].ticketPrice.toString());
                                                      selectset.remove(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber);
                                                    });
                                                  }
                                                  else {
                                                    if (selectset.length + selectset1.length == int.parse(data!.busLayoutData[0].bookLimit)) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('You can not add more than ${data!.busLayoutData[0].bookLimit} passengers to a single booking with this operator'), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                      );
                                                    } else {
                                                      setState(() {
                                                        bottom += double.parse(data!.busLayoutData[0].ticketPrice);
                                                        selectset.add(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber);
                                                      });
                                                    }
                                                  }
                                                }
                                              });
                                            },
                                            child: widget.isSleeper == '1' ?    Container(
                                              height: 60,
                                              width: 35,
                                              margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                              decoration: BoxDecoration(
                                                image:data!.busLayoutData[0].lowerLayout[index1][index].gender=='FEMALE' ? const DecorationImage(image: AssetImage('assets/Ldise_Set.png'),fit: BoxFit.fill): data!.busLayoutData[0].lowerLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage('assets/selection_set.png'),fit: BoxFit.fill) :  selectset.contains(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage('assets/selections 1.png'),fit: BoxFit.fill) : const DecorationImage(image: AssetImage('assets/selections 2.png'),fit: BoxFit.fill)
                                              ),
                                              child: Center(child: Text(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber,style: const TextStyle(fontSize: 10,color: Colors.grey),)),
                                            ) : Container(
                                              height: 60,
                                              width: 45,
                                              margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                              decoration: BoxDecoration(
                                                image: data!.busLayoutData[0].lowerLayout[index1][index].gender=='FEMALE' ? const DecorationImage(image: AssetImage('assets/Booked by female passenger.png'),fit: BoxFit.fill): data!.busLayoutData[0].lowerLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage('assets/Selec_Sit_Setter.png'),fit: BoxFit.fill) :  selectset.contains(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage('assets/Selected By you.png'),fit: BoxFit.fill) : const DecorationImage(image: AssetImage('assets/Available.png'),fit: BoxFit.fill)
                                              ),
                                              child: Center(child: Text(data!.busLayoutData[0].lowerLayout[index1][index].seatNumber,style: const TextStyle(fontSize: 10,color: Colors.grey),)),
                                            ),
                                          );
                                        }),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),


                    const SizedBox(width: 10,),


                    data!.busLayoutData[0].upperLayout.isEmpty ? const  SizedBox()  :  Container(
                      // height: 650,
                      width: widget.isSleeper == '1' ?  double.parse((50 * data!.busLayoutData[0].upperLayout[0].length).toString()) : double.parse((61 * data!.busLayoutData[0].upperLayout[0].length).toString()),

                      decoration: BoxDecoration(
                        color: notifier.containercoloreproper,
                        borderRadius:  BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(data!.busLayoutData[0].driverDirection == "0")
                              upper()
                            else
                              upperRiverse(),


                          const Divider(color: Colors.black,),



                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: data?.busLayoutData[0].upperLayout.length,
                                itemBuilder: (BuildContext context, int index1) {

                                  return SizedBox(
                                    height: widget.isSleeper== '1' ?  80 : 58,
                                    width: 100,
                                    child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: data?.busLayoutData[0].upperLayout[0].length,
                                        itemBuilder: (BuildContext context, int index) {



                                          return data?.busLayoutData[0].upperLayout[index1][index].seatNumber == "" ? Container(
                                            height:  widget.isSleeper == '1' ?  80 : 60,
                                            width: widget.isSleeper == '1' ?  35 : 45,
                                            margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                          ) : InkWell(
                                            onTap: () {
                                              setState(() {

                                                print(data!.busLayoutData[0].upperLayout[0][index].seatNumber);

                                                if(data!.busLayoutData[0].upperLayout[index1][index].isBooked) {
                                                 if (data!.busLayoutData[0].upperLayout[index1][index].gender == 'FEMALE'){
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content:  Text('Booked by Female passenger'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                  );
                                                }else{
                                                   ScaffoldMessenger.of(context).showSnackBar(
                                                     SnackBar(content:  Text('Booked by Others'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                   );
                                                 }

                                                } else{
                                                  if (selectset1.contains(
                                                      data!.busLayoutData[0].upperLayout[index1][index].seatNumber) ==
                                                      true) {
                                                    setState(() {
                                                      bottom -= double.parse(data!.busLayoutData[0].ticketPrice);
                                                      selectset1.remove(data!.busLayoutData[0].upperLayout[index1][index].seatNumber);
                                                    });
                                                  }
                                                  else {
                                                    if (selectset.length + selectset1.length == int.parse(data!.busLayoutData[0].bookLimit)) {
                                                      ScaffoldMessenger.of(
                                                          context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text('You can not add more than ${data!.busLayoutData[0].bookLimit} passengers to a single booking with this operator'), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                      );
                                                    } else {
                                                      setState(() {
                                                        // bottom += int.parse(data!.busLayoutData[0].ticketPrice);
                                                        bottom += double.parse(data!.busLayoutData[0].ticketPrice.toString());
                                                        selectset1.add(data!.busLayoutData[0].upperLayout[index1][index].seatNumber);
                                                      });
                                                    }
                                                  }
                                                }


                                              });
                                            },
                                            child: Row(
                                              children: [
                                                widget.isSleeper == '1' ? Container(
                                                  height: 70,
                                                  width: 35,
                                                  margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                                  decoration: BoxDecoration(
                                                      image: data!.busLayoutData[0].upperLayout[index1][index].gender=='FEMALE' ? const DecorationImage(image: AssetImage('assets/Ldise_Set.png'),fit: BoxFit.fill): data!.busLayoutData[0].upperLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage('assets/selection_set.png'),fit: BoxFit.fill) :  selectset1.contains(data!.busLayoutData[0].upperLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage('assets/selections 1.png'),fit: BoxFit.fill) : const DecorationImage(image: AssetImage('assets/selections 2.png'),fit: BoxFit.fill)
                                                  ),
                                                  child: Center(child: Text(data!.busLayoutData[0].upperLayout[index1][index].seatNumber,style: const TextStyle(fontSize: 10,color: Colors.grey),)),
                                                ) : Container(
                                                  height: 48,
                                                  width: 45,
                                                  margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                                  decoration: BoxDecoration(
                                                      image: data!.busLayoutData[0].upperLayout[index1][index].gender == 'FEMALE' ? const DecorationImage(image: AssetImage('assets/Booked by female passenger.png'),fit: BoxFit.fill): data!.busLayoutData[0].upperLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage('assets/Selec_Sit_Setter.png'),fit: BoxFit.fill) :  selectset1.contains(data!.busLayoutData[0].upperLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage('assets/Selected By you.png'),fit: BoxFit.fill) : const DecorationImage(image: AssetImage('assets/Available.png'),fit: BoxFit.fill)
                                                  ),
                                                  child: Center(child: Text(data!.busLayoutData[0].upperLayout[index1][index].seatNumber,style: const TextStyle(fontSize: 10,color: Colors.grey),)),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }



  Widget lowwer (){
    return  Row(
      children: [
        Text('Lower Berth'.tr,style: TextStyle(color: notifier.textColor),overflow: TextOverflow.ellipsis,maxLines: 1,),
        const Spacer(),
        Image(image: const AssetImage('assets/staring.png'),height: 30,width: 30,color: notifier.textColor),
      ],
    );
  }

  Widget lowwerRiverse(){
    return  Row(
      children: [
        Image(image: const AssetImage('assets/staring.png'),height: 30,width: 30,color: notifier.textColor),
        const Spacer(),
        Text('Lower Berth'.tr,style: TextStyle(color: notifier.textColor),overflow: TextOverflow.ellipsis,maxLines: 1,),
      ],
    );
  }

  Widget upper(){
    return   Row(
      children: [
        const Spacer(),
        const SizedBox(height: 30,width: 30,),
        Text('Upper Berth'.tr,style: TextStyle(color: notifier.textColor),overflow: TextOverflow.ellipsis,maxLines: 1,),
      ],
    );
  }

  Widget upperRiverse(){
    return   Row(
      children: [
        const Spacer(),
        const SizedBox(height: 30,width: 30,),
        Text('Upper Berth'.tr,style: TextStyle(color: notifier.textColor),overflow: TextOverflow.ellipsis,maxLines: 1,),
      ],
    );
  }



}


