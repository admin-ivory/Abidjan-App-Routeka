// ignore_for_file: avoid_print, depend_on_referenced_packages, camel_case_types, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API_MODEL/booking_history_api_model.dart';
import '../Sub_Screen/booking_details_screen.dart';
import '../Sub_Screen/search_bus_screen.dart';
import '../config/config.dart';
import 'package:http/http.dart' as http;
import '../config/light_and_dark.dart';

class Booking_Screen extends StatefulWidget {
  const Booking_Screen({super.key});

  @override
  State<Booking_Screen> createState() => _Booking_ScreenState();
}

class _Booking_ScreenState extends State<Booking_Screen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getlocledata();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  bool isloading = true;


  late BookingHistory data;
  late BookingHistory data1;
  late BookingHistory data2;
  String uid = "";
  var userData;
  var searchbus;


  getlocledata() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

      userData  = jsonDecode(_prefs.getString("loginData")!);
      searchbus = jsonDecode(_prefs.getString('currency')!);

      Booking_history_api(userData["id"],"Pending").then((value) {
        if(value.statusCode == 200){
          setState(() {
            data = bookingHistoryFromJson(value.body);
          });
          Booking_history_api(userData["id"],"Completed").then((value) {
            if(value.statusCode == 200){
              setState(() {
                data1 = bookingHistoryFromJson(value.body);
              });
              Booking_history_api(userData["id"],"cancel").then((value) {
                if(value.statusCode == 200){
                  setState(() {
                    data2 = bookingHistoryFromJson(value.body);
                  });
                  setState(() {
                    isloading = false;
                  });
                }else {
                  print('failed');
                }
              });

            }else {
              print('failed');
            }
          });
        }else {
          print('failed');
        }
      });
      print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${userData["mobile"]}');

  }

  Future Booking_history_api(String uid,String status) async {

    Map body = {
      'uid' : uid,
      "status": status
    };

    print("+++--++ $body");

    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/booking_history.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      return response;
    }catch(e){
      print(e.toString());
    }
  }

  ColorNotifier notifier = ColorNotifier();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      // backgroundColor: const Color(0xffF5F5F5),
      backgroundColor: notifier.backgroundgray,
      appBar: AppBar(
        backgroundColor:  notifier.appbarcolore,
        elevation: 0,
        automaticallyImplyLeading: false,
        title:  Center(child: Text('My Tickets'.tr,style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold))),
      ),
      body: isloading ?  Center(child: CircularProgressIndicator(color: notifier.theamcolorelight)) :  Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 0,right: 0),
              child: Column(
                children: [
                  const SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: notifier.theamcolorelight,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      controller: _tabController,
                      indicatorColor: Colors.red,
                      labelColor: Colors.white,
                      unselectedLabelColor: notifier.textColor,
                      dividerColor: Colors.transparent,
                      labelStyle: const TextStyle(fontSize: 11),
                      tabs: <Widget>[
                        Tab(text: 'Upcoming Trips'.tr),
                        Tab(text: 'Completed Trips'.tr),
                        Tab(text: 'Cancel Trips'.tr),
                      ],
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children:   <Widget>[


                        if (data.tickethistory.isEmpty)  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(image: AssetImage('assets/amyticket.png'),height: 70,width: 70,),
                          const SizedBox(height: 15,),
                          Text('No booking found'.tr,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: notifier.textColor),),
                          const SizedBox(height: 25,),
                          Text('You dont`t have any booking records!'.tr,style: const TextStyle(color: Colors.grey),),
                        ],
                      ) else ListView.separated(
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 0);
                            },
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: data.tickethistory.length,
                            itemBuilder: (BuildContext context, int index) {


                              return Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Booking_Details(isDownload: true,ticket_id: data.tickethistory[index].ticketId,cancel: true),));
                                  },
                                  child: Container(
                                    // height: 200,
                                    width: MediaQuery.of(context).size.width*0.8,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: notifier.containercoloreproper,
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child:  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      color: const Color(0xff7D2AFF),
                                                      borderRadius: BorderRadius.circular(65),
                                                      image: DecorationImage(image: NetworkImage('${config().baseUrl}/${data.tickethistory[index].busImg}'),fit: BoxFit.fill))
                                              ),
                                              const SizedBox(width: 10,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(data.tickethistory[index].busName,style:  TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notifier.textColor)),
                                                  const SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      if(data.tickethistory[index].isAc == '1')  Text('AC Seater'.tr,style: TextStyle(fontSize: 12,color: notifier.textColor)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const Spacer(),
                                              const SizedBox(width: 4,),
                                              Text('$searchbus${data.tickethistory[index].subtotal}',style:  TextStyle(color: notifier.theamcolorelight,fontSize: 15,fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          const SizedBox(height: 15,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: SizedBox(
                                                  width: 100,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(data.tickethistory[index].boardingCity,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor),maxLines: 1,overflow: TextOverflow.ellipsis),
                                                      const SizedBox(height: 8,),
                                                      Text(convertTimeTo12HourFormat(data.tickethistory[index].busPicktime),style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.theamcolorelight)),
                                                      const SizedBox(height: 8,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Image(image: const AssetImage('assets/Auto Layout Horizontal.png'),color:notifier.theamcolorelight,width: 120,height: 50,),
                                                  Text(data.tickethistory[index].differencePickDrop,style:  TextStyle(fontSize: 12,color: notifier.textColor)),
                                                ],
                                              ),
                                              const SizedBox(width: 10,),
                                              Flexible(
                                                child: SizedBox(
                                                  width: 100,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(data.tickethistory[index].dropCity,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor),maxLines: 1,overflow: TextOverflow.ellipsis),
                                                      const SizedBox(height: 8,),
                                                      Text(convertTimeTo12HourFormat(data.tickethistory[index].busDroptime),style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.theamcolorelight)),
                                                      const SizedBox(height: 8,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),


                        data1.tickethistory.isEmpty ?  Column (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(image: AssetImage('assets/amyticket.png'),height: 70,width: 70,),
                            const SizedBox(height: 15,),
                            Text('No booking found'.tr,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: notifier.textColor),),
                            const SizedBox(height: 25,),
                            Text('You dont`t have any booking records!'.tr,style: const TextStyle(color: Colors.grey),),
                          ],
                        ) : ListView.separated(
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 0);
                            },
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: data1.tickethistory.length,
                            itemBuilder: (BuildContext context, int index) {

                              return Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Booking_Details(isDownload: false,ticket_id: data1.tickethistory[index].ticketId,cancel: true),));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*0.8,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: notifier.containercoloreproper,
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child:  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      color: const Color(0xff7D2AFF),
                                                      borderRadius: BorderRadius.circular(65),
                                                      image: DecorationImage(image: NetworkImage('${config().baseUrl}/${data1.tickethistory[index].busImg}'),fit: BoxFit.fill))
                                              ),
                                              const SizedBox(width: 10,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('${data1?.tickethistory[index].busName}',style:  TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notifier.textColor)), // ignore: invalid_null_aware_operator
                                                  const SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      if(data1.tickethistory[index].isAc == '1')  Text('AC Seater '.tr,style: TextStyle(fontSize: 12,color: notifier.textColor)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const Spacer(),
                                              const SizedBox(width: 4,),
                                              Text('$searchbus${data1.tickethistory[index].ticketPrice}',style:  TextStyle(color: notifier.theamcolorelight,fontSize: 15,fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          const SizedBox(height: 15,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: SizedBox(
                                                  width: 100,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(data1.tickethistory[index].boardingCity,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor),maxLines: 1,overflow: TextOverflow.ellipsis),
                                                      const SizedBox(height: 8,),
                                                      Text(convertTimeTo12HourFormat(data1.tickethistory[index].busPicktime),style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.theamcolorelight),),
                                                      const SizedBox(height: 8,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Image(image: const AssetImage('assets/Auto Layout Horizontal.png'),height: 50,width: 120,color: notifier.theamcolorelight),
                                                  Text(data1.tickethistory[index].differencePickDrop,style:  TextStyle(fontSize: 12,color: notifier.textColor)),
                                                ],
                                              ),
                                              const SizedBox(width: 10,),
                                              Flexible(
                                                child: SizedBox(
                                                  width: 100,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(data1.tickethistory[index].dropCity,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor),maxLines: 1,overflow: TextOverflow.ellipsis),
                                                      const SizedBox(height: 8,),
                                                      Text(convertTimeTo12HourFormat(data1.tickethistory[index].busDroptime),style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.theamcolorelight),),
                                                      const SizedBox(height: 8,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),


                        data2.tickethistory.isEmpty ?  Column (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(image: AssetImage('assets/amyticket.png'),height: 70,width: 70,),
                            const SizedBox(height: 15,),
                            Text('No booking found'.tr,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: notifier.textColor),),
                            const SizedBox(height: 25,),
                            Text('You dont`t have any booking records!'.tr,style: const TextStyle(color: Colors.grey),),
                          ],
                        ) : ListView.separated(
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 0);
                            },
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: data2.tickethistory.length,
                            itemBuilder: (BuildContext context, int index) {

                              return Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Booking_Details(cancel: false,isDownload: false,ticket_id: data2.tickethistory[index].ticketId),));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*0.8,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: notifier.containercoloreproper,
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child:  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      color: const Color(0xff7D2AFF),
                                                      borderRadius: BorderRadius.circular(65),
                                                      image: DecorationImage(image: NetworkImage('${config().baseUrl}/${data2.tickethistory[index].busImg}'),fit: BoxFit.fill))
                                              ),
                                              const SizedBox(width: 10,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('${data2?.tickethistory[index].busName}',style:  TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notifier.textColor)), // ignore: invalid_null_aware_operator
                                                  const SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      if(data2.tickethistory[index].isAc == '1')  Text('AC Seater '.tr,style: TextStyle(fontSize: 12,color: notifier.textColor)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const Spacer(),
                                              const SizedBox(width: 4,),
                                              Text('$searchbus${data2.tickethistory[index].ticketPrice}',style:  TextStyle(color: notifier.theamcolorelight,fontSize: 15,fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          const SizedBox(height: 15,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: SizedBox(
                                                  width: 100,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(data2.tickethistory[index].boardingCity,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor),maxLines: 1,overflow: TextOverflow.ellipsis),
                                                      const SizedBox(height: 8,),
                                                      Text(convertTimeTo12HourFormat(data2.tickethistory[index].busPicktime),style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.theamcolorelight),),
                                                      const SizedBox(height: 8,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Image(image: const AssetImage('assets/Auto Layout Horizontal.png'),height: 50,width: 120,color: notifier.theamcolorelight),
                                                  Text(data2.tickethistory[index].differencePickDrop,style:  TextStyle(fontSize: 12,color: notifier.textColor)),
                                                ],
                                              ),
                                              const SizedBox(width: 10,),
                                              Flexible(
                                                child: SizedBox(
                                                  width: 100,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(data2.tickethistory[index].dropCity,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor),maxLines: 1,overflow: TextOverflow.ellipsis),
                                                      const SizedBox(height: 8,),
                                                      Text(convertTimeTo12HourFormat(data2.tickethistory[index].busDroptime),style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.theamcolorelight),),
                                                      const SizedBox(height: 8,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}