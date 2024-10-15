// ignore_for_file: camel_case_types, file_names, unused_local_variable, depend_on_referenced_packages, non_constant_identifier_names, use_super_parameters, avoid_print, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../API_MODEL/page_list_api_model.dart';
import '../API_MODEL/review_list_api_model.dart';
import '../API_MODEL/search_bus_api_model.dart';
import '../config/config.dart';
import '../config/light_and_dark.dart';
import 'seat_book_screen.dart';

class Search_Bus_Screen extends StatefulWidget {
 final String boarding_id;
 final String drop_id;
 final String trip_date;
 final String to;
 final String from;
 final String is_verify;
 const Search_Bus_Screen({Key? key, required this.boarding_id, required this.drop_id, required this.trip_date, required this.to, required this.from, required this.is_verify}) : super(key: key);

  @override
  State<Search_Bus_Screen> createState() => _Search_Bus_ScreenState();
}

class _Search_Bus_ScreenState extends State<Search_Bus_Screen> {
  late SearchBus data;
  //Search bus api
  String uid = "";

  Future searchBusApi(String uid,boarding_id,drop_id,trip_date) async {

    Map body = {
      'uid' : uid,
      'boarding_id' : boarding_id,
      'drop_id' : drop_id,
      'trip_date' : trip_date
    };
    print("+++ $body");
    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/bus_search.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){
        setState(() {
        data = searchBusFromJson(response.body.toString());
        isloading = false;
        });
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString("bussearch", jsonEncode(data.busData));
        _prefs.setString("bussearch1", jsonEncode(data.currency));
        print(data);
        return data;
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }


  Reviewlist? data1;

  Future Review_list(String bus_id) async {

    Map body = {
      'bus_id' : bus_id,
    };
    print("+++ $body");
    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/ratelist.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){
        setState(() {
          data1 = reviewlistFromJson(response.body.toString());
          data1!.reviewdata.isEmpty ? ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:  Text('No reviews found'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
          ) : Get.bottomSheet(isScrollControlled: true,StatefulBuilder(
              builder: (context, setState)  {
                return Container(
                  // height: 200,
                  decoration:  BoxDecoration(
                    color: notifier.background,
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: SingleChildScrollView(
                      // scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [



                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: data1?.reviewdata.length,
                            // scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                            return  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 5,
                                  leading: CircleAvatar(backgroundColor: Colors.grey.withOpacity(0.2),radius: 25,child: Text('${data1?.reviewdata[index].userTitle[0]}',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xff7D2AFF))),),
                                  title: Text('${data1?.reviewdata[index].userTitle}',style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: notifier.textColor)),
                                  subtitle: Text('${data1?.reviewdata[index].reviewDate.toString().split(" ").first}',style:  TextStyle(fontSize: 14,color: notifier.textColor)),
                                  trailing: Container(
                                    height: 25,
                                    width: 55,
                                    decoration: BoxDecoration(
                                      // color: Colors.red,
                                      border: Border.all(color: const Color(0xff7D2AFF)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.star,color: Color(0xff7D2AFF),size: 10),
                                        const SizedBox(width: 5,),
                                        Text('${data1?.reviewdata[index].userRate}',style: const TextStyle(color: Color(0xff7D2AFF),fontSize: 14,fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                  child: Text('${data1?.reviewdata[index].userDesc}',style: TextStyle(color: notifier.textColor)),
                                ),
                                const SizedBox(height: 10,),
                              ],
                            );
                          },)


                        ],
                      ),
                    ),
                  ),
                );
              }
          ));
        });
        print(data1);
        return data1;
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }



  @override
    void initState() {
    getDataFromLocal();
    _resetSelectedDate();
    getlocledata();
    pagelistapi();
      super.initState();
    }

  getDataFromLocal() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
  var data = preferences.getString("loginData");
  print(jsonDecode(data!));

  var decode = jsonDecode(data);
  setState(() {
      uid = decode["id"];
  });
  print(uid);
  searchBusApi(uid, widget.boarding_id, widget.drop_id, widget.trip_date);
  }

  int selected = 0;
  bool isloading = true;
  String formattedDate = DateFormat.yMMMEd().format(DateTime.now());



   late DateTime _selectedDate;

  void _resetSelectedDate() {
    print(DateTime.parse(widget.trip_date));
    _selectedDate = (DateTime.parse(widget.trip_date)).add(const Duration(seconds: 1));
  }

  int a= 0;

  List GridviewList = [];



  late PageList from12;

  //  GET API CALLING

  Future pagelistapi() async {
    var response1 = await http.get(Uri.parse('${config().baseUrl}/api/pagelist.php'),);
    if (response1.statusCode == 200) {
      var jsonData = json.decode(response1.body);
      print(jsonData["PageList"]);
      setState(() {
        from12 = pageListFromJson(response1.body);
      });
    }
  }

  var userData;
  var ticketid;
  getlocledata() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      userData  = jsonDecode(_prefs.getString("loginData")!);
      ticketid  = jsonDecode(_prefs.getString("tickethistory")!);


      print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${userData["mobile"]}');
      print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${ticketid}');

    });
  }


  ColorNotifier notifier = ColorNotifier();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: notifier.appbarcolore,
        elevation: 0,
        actions: [
          const SizedBox(width: 60,),
          SizedBox(
            height: 70,
            width: 200,
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Row(
                  children: [
                    Flexible(child: Text(widget.from,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 13,),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                    const SizedBox(width: 5,),
                    const Image(image: AssetImage('assets/arrow-right.png'),color: Colors.white,height: 12,width: 12),
                    const SizedBox(width: 5,),
                    Flexible(child: Text(widget.to,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 13),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                  ],
                ),
              ),
              subtitle: Text(_selectedDate.toString().split(" ").first,style: const TextStyle(color: Colors.white,fontSize: 12)),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 21,bottom: 21),
            child: InkWell(
              onTap: () {
                selectDateAndTime(context);
              },
              child: Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  Center(child: Text('Change'.tr,style: const TextStyle(color: Colors.white,fontSize: 12),)),
              ),
            ),
          ),
          const SizedBox(width: 10,),
        ],
      ),
      backgroundColor: notifier.backgroundgray,
      // backgroundColor: notifier.background,
      body: isloading ?  Center(child: CircularProgressIndicator(color: notifier.theamcolorelight),) :  Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [



          const SizedBox(height: 15,),

          data.busData.isEmpty ?  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(image: AssetImage('assets/notavilabale_bus_image.png'),width: 250,height: 250,),
              // SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Text('Zigzag fulfilled buses are not available at this time.'.tr,textAlign: TextAlign.center,style: const TextStyle(fontSize: 16,color: Colors.grey ,fontFamily: 'SofiaProBold'),),
              ),
            ],
          ) : Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 15);
                },
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: data.busData.length,
                itemBuilder: (BuildContext context, int index) {

                  var date1 = DateFormat("HH:mm").parse(convertTimeTo12HourFormat(data.busData[index].busPicktime));
                  var date2 = DateFormat("HH:mm").parse(convertTimeTo12HourFormat(data.busData[index].busDroptime));

                  return Container(
                    // height: 200,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: notifier.containercoloreproper,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child:  Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                               Navigator.push(context, MaterialPageRoute(builder: (context) =>  Seat_Book_(is_verify: widget.is_verify,agentCommission: (double.parse(data.busData[index].ticketPrice) * double.parse(data.busData[index].agentCommission) / 100).toStringAsFixed(2),com_per: data.busData[index].agentCommission,boarding_id: widget.boarding_id,drop_id: widget.drop_id,currency: data.currency,differencePickDrop: data.busData[index].differencePickDrop,Difference_pick_drop: data.busData[index].differencePickDrop,totlSeat: data.busData[index].totlSeat,isSleeper: data.busData[index].isSleeper,busAc: data.busData[index].busAc,busRate: data.busData[index].busRate,busPicktime: data.busData[index].busPicktime,busDroptime: data.busData[index].busDroptime,ticketPrice: data.busData[index].ticketPrice.toString(),busImg: data.busData[index].busImg,id_pickup_drop: data.busData[index].idPickupDrop,busTitle: data.busData[index].busTitle,bus_id: data.busData[index].busId,trip_date: _selectedDate.toString(),uid: uid,boardingCity: data.busData[index].boardingCity,dropCity: data.busData[index].dropCity,from: widget.from,to: widget.to, ),));
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          color: notifier.theamcolorelight,
                                          borderRadius: BorderRadius.circular(65),
                                          image: DecorationImage(image: NetworkImage('${config().baseUrl}/${data.busData[index].busImg}'),fit: BoxFit.fill))
                                        ),
                                    const SizedBox(width: 10,),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(data.busData[index].busTitle,style:  TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notifier.textColor)),
                                          const SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              if(data.busData[index].busAc == '1')  Flexible(child: Text('AC Seater'.tr,style: TextStyle(fontSize: 13,color: notifier.textColor),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                              if(data.busData[index].isSleeper == '1')  Flexible(child: Text('/ Sleeper'.tr,style: TextStyle(fontSize: 13,color: notifier.textColor),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                              const SizedBox(width: 5,),
                                              Container(
                                                  height: 22,
                                                  width: 65,
                                                 decoration: BoxDecoration(
                                                   border: Border.all(color: notifier.seatbordercolore),
                                                   color: notifier.seatcontainere,
                                                   borderRadius: BorderRadius.circular(5)
                                                 ),
                                                  child: Center(child: Padding(
                                                    padding: const EdgeInsets.only(top: 3),
                                                    child: Text('${data.busData[index].totlSeat} Seats',style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.seattextcolore),overflow: TextOverflow.ellipsis,maxLines: 1,),
                                                  ))),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4,),
                                    Column(
                                      children: [
                                        Text('${data.currency}${data.busData[index].ticketPrice}',style: TextStyle(color: notifier.theamcolorelight,fontSize: 15,fontWeight: FontWeight.bold),),
                                        const SizedBox(height: 5,),
                                        Tooltip(
                                          margin: const EdgeInsets.only(left: 30,right: 30),
                                          triggerMode: TooltipTriggerMode.tap,
                                          showDuration: const Duration(seconds: 2),
                                          message: 'Per ticket, you received the commission of ${(double.parse(data.busData[index].ticketPrice) * double.parse(data.busData[index].agentCommission) / 100).toStringAsFixed(2)}${data.currency}',
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              userData['user_type']=='AGENT' ? Padding(padding: const EdgeInsets.only(top: 4), child: Text('${data.currency} ${(double.parse(data.busData[index].ticketPrice) * double.parse(data.busData[index].agentCommission) / 100).toStringAsFixed(2) }',style: const TextStyle(color: Colors.green,fontSize: 15,fontWeight: FontWeight.bold)),) : const SizedBox(),
                                              const SizedBox(width: 5,),
                                              userData['user_type']=='AGENT' ?  const Image(image: AssetImage('assets/agenticon.png'),height: 15,width: 15,color: Colors.green,):const SizedBox()
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
                                            Text(data.busData[index].boardingCity,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor),overflow: TextOverflow.ellipsis,),
                                            const SizedBox(height: 8,),
                                            Text(convertTimeTo12HourFormat(data.busData[index].busPicktime),style:   TextStyle(fontWeight: FontWeight.bold,color: notifier.theamcolorelight,fontSize: 12),overflow: TextOverflow.ellipsis),
                                            const SizedBox(height: 8,),
                                            Text(_selectedDate.toString().split(" ").first,style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.textColor),overflow: TextOverflow.ellipsis),
                                            const SizedBox(height: 8,),
                                            // Text('Seat : ${data.busData[index].totlSeat}',style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    Column(
                                      children: [
                                        Image(image: const AssetImage('assets/Auto Layout Horizontal.png'),height: 50,width: 120,color: notifier.theamcolorelight),
                                        Text(data.busData[index].differencePickDrop,style: TextStyle(fontSize: 12,color: notifier.textColor)),
                                      ],
                                    ),
                                    const SizedBox(width: 5,),
                                    Flexible(
                                      child: SizedBox(
                                        width: 100,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(data.busData[index].dropCity,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor),overflow: TextOverflow.ellipsis,),
                                            const SizedBox(height: 8,),
                                            Text(convertTimeTo12HourFormat(data.busData[index].busDroptime),style:  TextStyle(fontWeight: FontWeight.bold,color: notifier.theamcolorelight ,fontSize: 12),overflow: TextOverflow.ellipsis,),
                                            const SizedBox(height: 8,),
                                            Text(_selectedDate.toString().split(" ").first,style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.textColor),overflow: TextOverflow.ellipsis),
                                            const SizedBox(height: 8,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.grey.withOpacity(0.4)),
                                const SizedBox(height: 8,),
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 0,right: 0),
                                child: Row(
                                  children: [
                                    // const Spacer(),
                                    Expanded(flex: 4,child: InkWell(
                                        onTap: () {
                                          if(GridviewList.contains(index) == true){
                                            setState(() {
                                              GridviewList.remove(index);
                                            });
                                          }else{
                                            setState(() {
                                              GridviewList.add(index);
                                            });
                                          }
                                        },
                                        child:  Text('Amenities'.tr,style:  TextStyle(color: notifier.theamcolorelight,fontWeight: FontWeight.bold,fontSize: 12),))),
                                    Expanded(flex: 4,child: InkWell(
                                        onTap: () {
                                          Review_list(data.busData[index].busId);
                                        },
                                        child:  Padding(
                                          padding:  const EdgeInsets.only(left: 15),
                                          child:  Text('Review'.tr,style:  TextStyle(color: notifier.theamcolorelight,fontWeight: FontWeight.bold,fontSize: 12),),
                                        ))),
                                    Expanded(flex: 4,child: InkWell(
                                        onTap: () {
                                          Get.bottomSheet(isScrollControlled: true,StatefulBuilder(
                                              builder: (context, setState)  {
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 100),
                                                  child: Container(
                                                    // height: 200,
                                                    decoration:  BoxDecoration(
                                                      color: notifier.background,
                                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                                                      child: SingleChildScrollView(
                                                        scrollDirection: Axis.vertical,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(from12.pagelist[3].title,style:  TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: notifier.textColor)),
                                                            const SizedBox(height: 20,),
                                                            HtmlWidget(
                                                             from12.pagelist[3].description,
                                                              textStyle:  TextStyle(
                                                                  color: notifier.textColor,
                                                                  fontSize: 20,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                          ));
                                        },
                                        child:  Text('Cancellation Policy'.tr,style:  TextStyle(color: notifier.theamcolorelight,fontWeight: FontWeight.bold,fontSize: 12),))),
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 15,),
                              GridviewList.contains(index) ?
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: GridView.builder(
                                   shrinkWrap: true,
                                    gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 20,
                                      mainAxisSpacing: 10,
                                    ),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: data.busData[index].busFacilities.length,
                                    itemBuilder: (BuildContext context, int index1) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Row(
                                          children: [
                                            Image(image: NetworkImage('${config().baseUrl}/${data.busData[index].busFacilities[index1].facilityimg}'),color: notifier.textColor),
                                            const SizedBox(width: 10,),
                                            Text(data.busData[index].busFacilities[index1].facilityname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor)),
                                          ],
                                        ),
                                      );
                                    },
                                ),
                              ) : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),

          const SizedBox(height: 15,),

        ],
      ),
    );
  }



  var selectedDateAndTime = DateTime.now();

  Future<void> selectDateAndTime(context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff7D2AFF), // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Color(0xff7D2AFF), // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    print(pickedDate);
    if (pickedDate != null && pickedDate != _selectedDate) {

      setState(() {
        _selectedDate = pickedDate;
      });
      searchBusApi(uid, widget.boarding_id, widget.drop_id, _selectedDate.toString().split(" ").first);
    }
  }
}



String convertTimeTo12HourFormat(String time24Hour) {
  // Parse the input time in 24-hour format
  final inputFormat = DateFormat('HH:mm:ss');
  final inputTime = inputFormat.parse(time24Hour);

  // Format the time in 12-hour format
  final outputFormat = DateFormat('h:mm a');
  final formattedTime = outputFormat.format(inputTime);

  return formattedTime;
}
