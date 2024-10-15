// ignore_for_file: camel_case_types, depend_on_referenced_packages, non_constant_identifier_names, use_super_parameters, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../API_MODEL/pickup_and_dropStops_api_model.dart';
import '../config/config.dart';
import '../config/light_and_dark.dart';
import 'passenger_information_screen.dart';
import 'search_bus_screen.dart';


enum SingingCharacter { lafayette, jefferson }

class Set_Location extends StatefulWidget {

  final String uid;
  final String id_pickup_drop;
  final String busTitle;
  final String to;
  final String from;
  final int length;
  final List selectset;
  final List selectset1;
  final num bottom;
  final String busImg;
  final String ticketPrice;
  final String boardingCity;
  final String dropCity;
  final String busPicktime;
  final String busDroptime;
  final String wallet;
  final String trip_date;
  final String busAc;
  final String isSleeper;
  final String totlSeat;
  final String differencePickDrop;
  final String currency;
  final String bus_id;
  final String boarding_id;
  final String drop_id;
  final String Difference_pick_drop;
  final String agentCommission;
  final String com_per;
  final String is_verify;

  const Set_Location({Key? key, required this.uid, required this.id_pickup_drop, required this.busTitle, required this.to, required this.from, required this.length, required this.selectset, required this.selectset1, required this.bottom, required this.busImg, required this.ticketPrice, required this.boardingCity, required this.dropCity, required this.busPicktime, required this.busDroptime, required this.wallet, required this.trip_date, required this.busAc, required this.isSleeper, required this.totlSeat, required this.differencePickDrop, required this.currency, required this.bus_id, required this.boarding_id, required this.drop_id, required this.Difference_pick_drop, required this.agentCommission, required this.com_per, required this.is_verify}) : super(key: key);

  @override
  State<Set_Location> createState() => _Set_LocationState();
}

class _Set_LocationState extends State<Set_Location>  with TickerProviderStateMixin {



  PickupAndDrop? data;

  String pickuptime = '';
  String droptime = '';
  Future Pickup_And_Drop_Api(String uid,id_pickup_drop,bus_id) async {

    Map body = {
      'bus_id' : bus_id,
      'uid' : uid,
      'id_pickup_drop' : id_pickup_drop,
    };

    print("+++ $body");
    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/boarding_dropping_point.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){

        setState(()  {
          data = pickupAndDropFromJson(response.body);

          isloading = false;

        });
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }



  bool isloading = true;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    Pickup_And_Drop_Api(widget.uid, widget.id_pickup_drop,widget.bus_id);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener((){
      setState(() {
        _tabController.index = _tabController.index;
      });
      print("////////////////////////1254638455///////////////////////////////////////////  ${widget.busPicktime}");

    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

   String selectedOption = '';
   String selectedOption1 = "";
   String pickupid = "";
   String dropid = "";



   String selectBoring = "";
   String selectDrop = "";

  List selectIndex = [];
  List selectIndex1 = [];

  int lenth = 0 ;
  int lenth1 = 0;

  ColorNotifier notifier = ColorNotifier();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      // backgroundColor: const Color(0xffF5F5F5),
      backgroundColor: notifier.backgroundgray,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        elevation: 0,
        backgroundColor: notifier.appbarcolore,
        title: Transform.translate(
          offset: const Offset(-15, 0),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.boardingCity}  to  ${widget.dropCity}',style: const TextStyle(color: Colors.white,fontSize: 13)),
              const SizedBox(height: 5,),
              Text(widget.trip_date.toString().split(" ").first,style: const TextStyle(color: Colors.white,fontSize: 12)),
            ],
          ),
        ),
      ),
      body: isloading ?   Center(child: CircularProgressIndicator(color: notifier.theamcolorelight),) :  Column(
        children: [
          Expanded(
            child: Column(
              children: [
                 const SizedBox(height: 5,),
                TabBar(
                  onTap: (value) {
                  },
                  controller: _tabController,
                  indicatorColor: notifier.theamcolorelight,
                  labelColor: notifier.textColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  // unselectedLabelColor: Colors.grey,
                  tabs: <Widget>[
                    Tab(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Boarding Point'.tr,style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold),),
                      ],
                    )),
                    Tab(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Droping Point'.tr,style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold),),
                      ],
                    )),
                  ],
                ),



                Expanded(
                  child: TabBarView(
                    // physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children:  <Widget>[
                      SizedBox(
                          height: 500,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              for(int i = 0; i < data!.pickUpStops.length; i++) Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                // height: 50,
                                width: MediaQuery.of(context).size.width,
                                color: notifier.containercoloreproper,
                                child: ListTile(
                                  onTap: () {
                                    setState(() {

                                      lenth= i;

                                      selectedOption = data!.pickUpStops[i].pickPlace;
                                      selectBoring = data!.pickUpStops[i].pickPlace;
                                      pickupid = data!.pickUpStops[i].pickId;
                                      pickuptime = convertTimeTo12HourFormat(data!.pickUpStops[i].pickTime);
                                      print('+++++++++++++++++++++++$lenth');
                                      print('+++++++++++++++++++++++${data!.pickUpStops[i].pickPlace}');
                                      _tabController.index = 1;

                                    });
                                  },
                                  subtitle:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5,),
                                      Text(data!.pickUpStops[i].pickAddress,style:  TextStyle(fontWeight: FontWeight.bold,color: notifier.textColor,fontSize: 12)),
                                      const SizedBox(height: 5,),
                                      Text(convertTimeTo12HourFormat(data!.pickUpStops[i].pickTime),style:  TextStyle(fontWeight: FontWeight.bold,color: notifier.textColor,fontSize: 12)),
                                      const SizedBox(height: 8,),
                                    ],
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text('${data?.pickUpStops[i].pickPlace}',style:  TextStyle(fontWeight: FontWeight.bold,color: notifier.textColor,fontSize: 14)),
                                  ),
                                  trailing: Radio(
                                    value: data!.pickUpStops[i].pickPlace,
                                    groupValue: selectedOption,
                                    fillColor:  WidgetStatePropertyAll(notifier.theamcolorelight),
                                    onChanged: (value) {
                                      print(value);
                                      setState(() {

                                        lenth = i;
                                        selectedOption = value.toString();
                                        selectBoring = data!.pickUpStops[i].pickPlace;
                                        pickupid = data!.pickUpStops[i].pickId;
                                        pickuptime = convertTimeTo12HourFormat(data!.pickUpStops[i].pickTime);
                                        _tabController.index = 1;

                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
                      SizedBox(
                        height: 500,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            for(int i =0;i < data!.dropStops.length ; i++) SizedBox(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                // height: 50,
                                width: MediaQuery.of(context).size.width,
                                color: notifier.containercoloreproper,
                                child: ListTile(
                                  onTap: () {
                                    setState(() {

                                       lenth1 = i;
                                       selectedOption1 = data!.dropStops[i].dropPlace;
                                       selectDrop = data!.dropStops[i].dropPlace;
                                       dropid = data!.dropStops[i].dropId;
                                       droptime = convertTimeTo12HourFormat(data!.dropStops[i].dropTime);

                                    });
                                  },
                                  trailing: Radio(
                                    value: data!.dropStops[i].dropPlace,
                                    groupValue: selectedOption1,
                                    fillColor:  WidgetStatePropertyAll(notifier.theamcolorelight),
                                    onChanged: (value) {
                                      print(value);
                                      setState(() {
                                        lenth1 = i;
                                        selectedOption1 = value.toString();
                                        selectDrop = data!.dropStops[i].dropPlace;
                                        dropid = data!.dropStops[i].dropId;
                                        droptime = convertTimeTo12HourFormat(data!.dropStops[i].dropTime);
                                      });
                                    },
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text('${data?.dropStops[i].dropPlace}',style:  TextStyle(fontWeight: FontWeight.bold,color: notifier.textColor,fontSize: 14)),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5,),
                                      Text(data!.dropStops[i].dropAddress,style:  TextStyle(fontWeight: FontWeight.bold,color: notifier.textColor,fontSize: 12)),
                                      const SizedBox(height: 5,),
                                      Text(convertTimeTo12HourFormat(data!.dropStops[i].dropTime),style:  TextStyle(fontWeight: FontWeight.bold,color: notifier.textColor,fontSize: 12)),
                                      const SizedBox(height: 8,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            color: notifier.containercoloreproper,
            child:  Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                children: [
                   Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _tabController.index == 0 ?   Text('Boarding Point'.tr,style: TextStyle(fontSize: 14,color: notifier.textColor),) :  Text('Droping Point'.tr,style: TextStyle(fontSize: 14,color: notifier.textColor),),
                          const SizedBox(height: 5,),
                          Text(_tabController.index == 0? selectedOption  : selectedOption1,maxLines: 1,style: TextStyle(fontWeight: FontWeight.bold,color: notifier.textColor)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: selectedOption.isEmpty  ?  Container(
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xffD6C1F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:  Center(child : Text('Next Step'.tr,style: const TextStyle(color: Colors.black),)),
                    ) : Container(
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                        color: notifier.theamcolorelight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:  ElevatedButton(
                          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(notifier.theamcolorelight),shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))),
                          onPressed:  () {
                            setState(() {

                              if(selectedOption.isNotEmpty && selectedOption1.isNotEmpty){
                                if(_tabController.index == 0){
                                  _tabController.index = 1;
                                }else{
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Passenger_Information(is_verify: widget.is_verify,agentCommission: widget.agentCommission,com_per: widget.com_per,pickMobile: data!.pickUpStops[lenth1].pickMobile,drop_time: data!.dropStops[lenth1].dropTime,pick_time: data!.pickUpStops[lenth].pickTime,drop_address: data!.dropStops[0].dropAddress,drop_place: data!.dropStops[lenth1].dropPlace,pick_mobile: data!.pickUpStops[0].pickMobile,pick_address: data!.pickUpStops[0].pickAddress,pick_place: data!.pickUpStops[lenth].pickPlace,Difference_pick_drop: widget.differencePickDrop,boarding_id: widget.boarding_id,drop_id: widget.drop_id,dropId: dropid,pick_id: pickupid,bus_id: widget.bus_id,currency: widget.currency,busAc: widget.busAc,differencePickDrop: widget.differencePickDrop,totlSeat: widget.totlSeat,isSleeper: widget.isSleeper,trip_date: widget.trip_date,wallet: widget.wallet,dropTime: droptime,pickTime: pickuptime,uid: widget.uid,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,boardingCity: widget.boardingCity,dropCity: widget.dropCity,ticketPrice: widget.ticketPrice,busImg: widget.busImg,bottom: widget.bottom,selectset1: widget.selectset1,selectset: widget.selectset,length:  widget.length,from: widget.from,to: widget.to,busTitle: widget.busTitle,selectIndex: selectBoring,selectIndex1: selectDrop),));
                                }
                              }else{

                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     duration: const Duration(seconds: 1),
                                //     content:  Text('Plese Select Boarding And Drop Point'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                // );

                                if(selectedOption.isEmpty){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please select Boarding point'.tr), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                  );
                                }
                                if(selectedOption1.isEmpty){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please select Droping point'.tr), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                  );
                                }
                              }

                              _tabController.index = 1;
                            });
                          },
                          child: Center(child : Text('Next Step'.tr,style: const TextStyle(color: Colors.white),))),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}



