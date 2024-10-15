// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_import, unused_field, must_be_immutable, use_super_parameters, prefer_final_fields, avoid_print, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../Common_Code/common_button.dart';
import '../config/light_and_dark.dart';
import 'user_payment_screen.dart';

enum SingingCharacter { lafayette, jefferson }

class Passenger_Information extends StatefulWidget {
  final String busTitle;
  final String selectIndex;
  final String selectIndex1;
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
  final String uid;
  final String wallet;
  final String trip_date;
  final String busAc;
  final String isSleeper;
  final String totlSeat;
  final String differencePickDrop;
  final String currency;
  final String bus_id;
  final String pick_id;
  final String dropId;
  final String boarding_id;
  final String drop_id;
  final String Difference_pick_drop;
  final String pick_time;
  final String pickTime;
  final String pick_place;
  final String pick_address;
  final String pick_mobile;
  final String dropTime;
  final String drop_time;
  final String drop_place;
  final String drop_address;
  final String pickMobile;
  final String agentCommission;
  final String com_per;
  final String is_verify;

  const Passenger_Information({Key? key,
    required this.busTitle, required this.selectIndex, required this.selectIndex1,required this.to,required this.from, required this.length, required this.selectset, required this.selectset1, required this.bottom, required this.busImg, required this.ticketPrice, required this.boardingCity, required this.dropCity, required this.busPicktime, required this.busDroptime, required this.uid, required this.pickTime, required this.dropTime, required this.wallet, required this.trip_date, required this.busAc, required this.isSleeper, required this.totlSeat, required this.differencePickDrop, required this.currency, required this.bus_id, required this.pick_id, required this.dropId, required this.boarding_id, required this.drop_id, required this.Difference_pick_drop, required this.pick_place, required this.pick_address, required this.pick_mobile, required this.drop_place, required this.drop_address, required this.pick_time, required this.drop_time, required this.pickMobile, required this.agentCommission, required this.com_per, required this.is_verify}) : super(key: key);

  @override
  State<Passenger_Information> createState() => _Passenger_InformationState();
}

class _Passenger_InformationState extends State<Passenger_Information> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController FullnameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  List NameController = [];
  List ageController = [];

  List DataStore = [];

  List<DynamicWidget> listDynamic = [];
  List<DynamicWidget1> listDynamicage = [];

  bool light = true;
  bool light1 = false;
  bool light2 = false;

  SingingCharacter? _character = SingingCharacter.lafayette;

  List siteNumber = [];
  List manadf = [];

  @override
  void initState() {
    super.initState();

    print(widget.selectset1);
    print(widget.selectset);
    print(
        "////////////////////////1254638455///////////////////////////////////////////  ${widget.busPicktime}");

    for (int a = 0; a < widget.length; a++) {
      listDynamic.add(DynamicWidget());
      listDynamicage.add(DynamicWidget1());
    }

    setState(() {
      siteNumber = widget.selectset + widget.selectset1;
    });
  }

  bool error = false;
  bool error1 = false;
  bool error2 = false;

  int ma_fe = 0;

  // bool selectman = false;
  ColorNotifier notifier = ColorNotifier();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Form(
      key: _formKey,
      child: Scaffold(
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: notifier.containercoloreproper,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Amount :'.tr,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: notifier.textColor),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${widget.currency} ${widget.bottom.toStringAsFixed(2)}',
                                  style:  TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: notifier.theamcolorelight),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '(Exclusive of Taxes)'.tr,
                                  style: TextStyle(
                                      fontSize: 10, color: notifier.textColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8,)
                          ],
                        ),
                        const Spacer(),
                        const Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: CommonButton(containcolore: notifier.theamcolorelight, txt1: 'PROCEED'.tr, context: context,onPressed1: () {
                      if(FullnameController.text.isNotEmpty){
                        setState(() {

                          error = false;
                        });
                      }else{
                        setState(() {

                          error = true;
                        });
                      }


                      if(EmailController.text.isNotEmpty){
                        setState(() {

                          error1 = false;
                        });
                      }else{
                        setState(() {

                          error1 = true;
                        });
                      }


                      if(mobileController.text.isNotEmpty){
                        setState(() {

                          error2 = false;
                        });
                      }else{
                        setState(() {

                          error2 = true;
                        });
                      }
                      submitData();
                      submitData1();


                      data.remove("");
                      data1.remove("");



                      print("-+-+-+-+-+-1 2 3 4 5+-+-+--+-+-+-+-+-${data.isEmpty}");
                      print("-+-+-+-+-+-+6 7 8 9 10-+-+--++-++-+-${listDynamic.length}");
                      print("-+-+-+-+-+-+11 12 13 14 15-+-+--+-+-+-+-+-${data}");

                      if (widget.length == manadf.length && data.length == widget.length && data1.length == widget.length) {
                        print(manadf.isNotEmpty);
                        print(manadf);
                        print("-+-+-+-+-+-+ 6 7 8 9 10 -+-+--++-++-+-${data.length}");
                        print("-+-+-+-+-+-+ 6 7 8 9 10 -+-+--++-++-+-${data}");
                        print("-+-+-+-+-+-+ 6 7 8 9 10 -+-+--++-++-+-${data.isNotEmpty}");
                        if (mobileController.text.isNotEmpty && EmailController.text.isNotEmpty && FullnameController.text.isNotEmpty && manadf.isNotEmpty && listDynamic.isNotEmpty && listDynamicage.isNotEmpty) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Payment_Screen(
                              is_verify: widget.is_verify,
                              agentCommission: widget.agentCommission,com_per: widget.com_per,
                                pickMobile: widget.pickMobile,
                                drop_time: widget.drop_time,
                                pick_time: widget.pick_time,
                                pick_mobile: widget.pick_mobile,
                                pick_address: widget.pick_address,
                                pick_place: widget.pick_place,
                                dropTime: widget.dropTime,
                                pickTime: widget.dropTime,
                                drop_address: widget.drop_address,
                                drop_place: widget.drop_place,
                                Difference_pick_drop: widget.differencePickDrop,
                                boarding_id: widget.boarding_id,
                                drop_id: widget.drop_id,
                                manadf: manadf,
                                siteNumber: siteNumber,
                                listDynamicage: listDynamicage,
                                listDynamic: listDynamic,
                                trip_date: widget.trip_date,
                                dropId: widget.dropId,
                                pick_id: widget.pick_id,
                                bus_id: widget.bus_id,
                                currency: widget.currency,
                                busAc: widget.busAc,
                                differencePickDrop: widget.differencePickDrop,
                                totlSeat: widget.totlSeat,
                                isSleeper: widget.isSleeper,
                                data: data,
                                data1: data1,
                                ma_fe: manadf,
                                wallet: widget.wallet,
                                bottom: widget.bottom,
                                selectIndex: widget.selectIndex,
                                selectIndex1: widget.selectIndex1,
                                DataStore: DataStore,
                                uid: widget.uid,
                                EmailController: EmailController.text,
                                FullnameController: FullnameController.text,
                                mobileController: mobileController.text,
                                busPicktime: widget.busPicktime,
                                busDroptime: widget.busDroptime,
                                boardingCity: widget.boardingCity,
                                dropCity: widget.dropCity,
                                ticketPrice: widget.ticketPrice,
                                busImg: widget.busImg,
                                busTitle: widget.busTitle,
                                selectset: widget.selectset,
                                selectset1: widget.selectset1),));
                        } else{
                          data.add("");
                          data1.add("");

                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(content: Text('Please select gender'.tr), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                            // );
                          }
                          if(manadf.isEmpty || manadf.length != widget.length){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select gender'.tr), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                            );
                          }
                        }

                      } else {
                        data.add("");
                        data1.add("");

                        print(manadf.length);
                        print(manadf.isEmpty);
                        print(manadf);
                        print(widget.length);

                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text('Please select gender'.tr), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                          // );
                        }
                        if(manadf.isEmpty || manadf.length != widget.length){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select gender'.tr), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                          );
                        }

                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: notifier.backgroundgray,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          elevation: 0,
          backgroundColor: notifier.appbarcolore,
          title: Transform.translate(
            offset: const Offset(-15, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.boardingCity}  to  ${widget.dropCity}', style: const TextStyle(color: Colors.white, fontSize: 13)),
                const SizedBox(height: 5,),
                Text(widget.trip_date.toString().split(" ").first, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [

              const SizedBox(height: 10,),

              Container(
                // height: 120,
                width: MediaQuery.of(context).size.width,
                color: notifier.containercoloreproper,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              width: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.selectIndex, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: notifier.textColor)),
                                  Text(widget.from, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: notifier.textColor)),
                                  const SizedBox(height: 13,),
                                  Text(widget.pickTime, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 12, color: notifier.textColor)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Column(
                            children: [
                              Image(
                                image: AssetImage('assets/Group 3.png'),
                                width: 20,
                                height: 80,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            child: SizedBox(
                              width: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(widget.selectIndex1,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: notifier.textColor)),
                                  Text(widget.to,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: notifier.textColor)),
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  Text(widget.dropTime,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: notifier.textColor)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              Container(
                width: MediaQuery.of(context).size.width,
                color: notifier.containercoloreproper,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        const Image(image: AssetImage('assets/Rectangle_2.png'), height: 40),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
                          child: Text('Passenger Details'.tr, style: TextStyle(color: notifier.textColor, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
      
                    const SizedBox(
                      height: 10,
                    ),
      
                    ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 15,
                            height: 25,
                          );
                        },
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listDynamic.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text('Passenger'.tr,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: notifier.textColor),
                                                  maxLines: 1),
                                              Text(' ${index + 1} || ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: notifier.textColor),
                                                  maxLines: 1),
                                              Text('Seats'.tr,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: notifier.textColor),
                                                  maxLines: 1),
                                              Text('-${siteNumber[index]}',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: notifier.textColor),
                                                  maxLines: 1),
                                            ],
                                          ),
                                          const SizedBox(height: 6,),
                                          listDynamic[index],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Age'.tr,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: notifier.textColor),
                                              maxLines: 1),
                                          const SizedBox(height: 6,),
                                          listDynamicage[index],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Gender'.tr, style: TextStyle(fontSize: 11, color: notifier.textColor), maxLines: 1),
                                          const SizedBox(height: 6,),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (manadf.contains("MALE-$index") == true) {
                                                  manadf.remove("MALE-$index");
                                                } else {
                                                  manadf.remove("FEMALE-$index");
                                                  manadf.add("MALE-$index");
                                                }
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: manadf.contains("MALE-$index") ? notifier.theamcolorelight : Colors.grey.withOpacity(0.4),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Center(
                                                  child: Image(image: AssetImage('assets/Group.png'),
                                                height: 30,
                                                width: 30,
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (manadf.contains(
                                                        "FEMALE-$index") ==
                                                    true) {
                                                  manadf.remove("FEMALE-$index");
                                                } else {
                                                  manadf.remove("MALE-$index");
                                                  manadf.add("FEMALE-$index");
                                                }
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: manadf.contains("FEMALE-$index") ? notifier.theamcolorelight : Colors.grey.withOpacity(0.4),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Center(
                                                  child: Image(
                                                image: AssetImage('assets/Group1.png'),
                                                height: 30,
                                                width: 30,
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
      
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
      
              const SizedBox(height: 10,),

              Container(
                // height: 120,
                width: MediaQuery.of(context).size.width,
                color: notifier.containercoloreproper,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        const Image(
                            image: AssetImage('assets/Rectangle_2.png'),
                            height: 40),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 15, bottom: 10),
                          child: Text(
                            'Contact Details'.tr,
                            style: TextStyle(
                                color: notifier.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name'.tr, style: TextStyle(fontSize: 14, color: notifier.textColor), maxLines: 1),
                              const SizedBox(
                                height: 6,
                              ),
                              TextFormField(
                                controller: FullnameController,
                                style: TextStyle(color: notifier.textColor),
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return '';
                                //   }
                                //   // value.trim().length>0? error=false: error=true; return null;
                                //   return null;
                                // },
                                onChanged: (value) {
                                  if(FullnameController.text.isNotEmpty){
                                    setState(() {
                                      error = false;
                                    });
                                  }else{
                                    setState(() {
                                      error = true;
                                    });
                                  }
                                  // if (_formKey.currentState!.validate()) {
                                  //   // If the form is valid, display a snackbar. In the real world,
                                  //   // you'd often call a server or save the information in a database.
                                  //   // ScaffoldMessenger.of(context).showSnackBar(
                                  //   //   SnackBar(content: Text('Please select gender'.tr), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                  //   // );
                                  // }
                                },
                                decoration: InputDecoration(
                                  errorStyle: const TextStyle(fontSize: 0.1),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 13,horizontal: 10 ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.pink)),
                                  focusedBorder:  OutlineInputBorder(
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(10)),
                                      borderSide:
                                          BorderSide(color: notifier.theamcolorelight)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: error ?Colors.red  : Colors.grey.withOpacity(0.4))),
                                  hintText: 'Enter Your Name'.tr,
                                  hintStyle: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email Id'.tr,
                                  style: TextStyle(
                                      fontSize: 14, color: notifier.textColor),
                                  maxLines: 1),
                              const SizedBox(
                                height: 6,
                              ),
                              TextFormField(
                                style: TextStyle(color: notifier.textColor),
                                controller: EmailController,
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return '';
                                //   }
                                //   return null;
                                // },
                                onChanged: (value) {
                                  if(EmailController.text.isNotEmpty){
                                    setState(() {

                                      error1 = false;
                                    });
                                  }else{
                                    setState(() {

                                      error1 = true;
                                    });
                                  }
                                  // if (_formKey.currentState!.validate()) {
                                  //   // If the form is valid, display a snackbar. In the real world,
                                  //   // you'd often call a server or save the information in a database.
                                  //   // ScaffoldMessenger.of(context).showSnackBar(
                                  //   //   SnackBar(content: Text('Please select gender'.tr), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                  //   // );
                                  // }
                                },
                                decoration: InputDecoration(
                                    errorStyle: const TextStyle(fontSize: 0.1),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 13,horizontal: 10 ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.pink)),
                                    focusedBorder:  OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: notifier.theamcolorelight)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color:
                                            error1 ?Colors.red  : Colors.grey.withOpacity(0.4))),
                                    hintText: 'Enter Email id'.tr,
                                    hintStyle: const TextStyle(
                                        fontSize: 13, color: Colors.grey)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Contact Details'.tr,
                                  style: TextStyle(
                                      fontSize: 14, color: notifier.textColor),
                                  maxLines: 1),
                              const SizedBox(
                                height: 6,
                              ),
                              TextFormField(
                                style: TextStyle(color: notifier.textColor),
                                keyboardType: TextInputType.number,
                                controller: mobileController,
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return '';
                                //   }
                                //   return null;
                                // },
                                onChanged: (value) {
                                  if(mobileController.text.isNotEmpty){
                                    setState(() {

                                    error2 = false;
                                    });
                                  }else{
                                    setState(() {

                                    error2 = true;
                                    });
                                  }
                                  // if (_formKey.currentState!.validate()) {
                                  //   // If the form is valid, display a snackbar. In the real world,
                                  //   // you'd often call a server or save the information in a database.
                                  //   // ScaffoldMessenger.of(context).showSnackBar(
                                  //   //   SnackBar(content: Text('Please select gender'.tr), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                  //   // );
                                  // }
                                },
                                decoration: InputDecoration(
                                    errorStyle: const TextStyle(fontSize: 0.1),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 13,horizontal: 10 ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.pink)),
                                    focusedBorder:  OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: notifier.theamcolorelight)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color:
                                            error2 ?Colors.red  : Colors.grey.withOpacity(0.4))),
                                    hintText: 'Enter Mobile Number'.tr,
                                    hintStyle: const TextStyle(fontSize: 13, color: Colors.grey)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15,),

              const SizedBox(height: 15,),

            ],
          ),
        ),
      ),
    );
  }

  List<String> data = [];
  submitData() {
    data = [];

    for (int a=0; a< listDynamic.length ; a++) {

      data.add(listDynamic[a].controller.text);
    }

    setState(() {});
    print(data.length);
    print(data);
  }

  List<String> data1 = [];
  submitData1() {
    data1 = [];
    for (int a=0; a< listDynamicage.length ; a++) {
      data1.add(listDynamicage[a].controller1.text);
    }

    setState(() {});
    print(data1.length);
    print(data1);
  }
}



class DynamicWidget extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  DynamicWidget({super.key});
  ColorNotifier notifier = ColorNotifier();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return TextFormField(
      style: TextStyle(color: notifier.textColor),
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        }
        return null;
      },
      decoration: InputDecoration(
          errorStyle: const TextStyle(fontSize: 0.1),
           isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 13,horizontal: 10 ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.pink)),
          focusedBorder:  OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: notifier.theamcolorelight)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
          hintText: 'Enter Full Name'.tr,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey)),
    );
  }
}

class DynamicWidget1 extends StatelessWidget {
  TextEditingController controller1 = TextEditingController();

  DynamicWidget1({super.key});
  ColorNotifier notifier = ColorNotifier();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return TextFormField(
      style: TextStyle(color: notifier.textColor),
      controller: controller1,
      maxLength: 2,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        }
        return null;
      },
      decoration: InputDecoration(
          errorStyle: const TextStyle(fontSize: 0.1),
          counterText: "",
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 13,horizontal: 10 ),
          // contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.pink)),
          focusedBorder:  OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: notifier.theamcolorelight)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
          hintText: 'Age'.tr,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey)),
    );
  }
}
