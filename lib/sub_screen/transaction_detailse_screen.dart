// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';

import '../config/config.dart';
import 'search_bus_screen.dart';

class Transaction_Screen extends StatefulWidget {
  final String busTitle;
  final String busAc;
  final String isSleeper;
  final String totlSeat;
  final String busImg;
  final String currency;
  final String ticketPrice;
  final String boardingCity;
  final String busPicktime;
  final String differencePickDrop;
  final String dropCity;
  final String busDroptime;
  final String trip_date;


  const Transaction_Screen({super.key, required this.busTitle, required this.busAc, required this.isSleeper, required this.totlSeat, required this.busImg, required this.currency, required this.ticketPrice, required this.boardingCity, required this.busPicktime, required this.differencePickDrop, required this.dropCity, required this.busDroptime, required this.trip_date});

  @override
  State<Transaction_Screen> createState() => _Transaction_ScreenState();
}

class _Transaction_ScreenState extends State<Transaction_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2C2C2C),
        elevation: 0,
        title: Transform.translate(offset: const Offset(-5, 0), child: const Text('Transction Detailse',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold))),
      ),
      body:  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Container(
              // height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
              ),
              child:  Padding(
                padding: const EdgeInsets.only(left: 0,right: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        const Image(image: AssetImage('assets/Rectangle 2.png'),height: 40),
                        const SizedBox(width: 15,),
                        Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(65),
                                image: DecorationImage(image: NetworkImage('${config().baseUrl}/${widget.busImg}'),fit: BoxFit.fill))
                        ),
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.busTitle,style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black)),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                if(widget.busAc == '1') const Text('AC Seater '),
                                if(widget.isSleeper == '1') const Text('/ Sleeper  '),
                                Text('${widget.totlSeat} Seat',style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              ],
                            )
                          ],
                        ),
                        const Spacer(),
                        const SizedBox(width: 4,),
                        Text('${widget.currency} ${widget.ticketPrice}',style: const TextStyle(color: Color(0xff7D2AFF),fontSize: 16,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(widget.boardingCity,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              const SizedBox(height: 8,),
                              Text(convertTimeTo12HourFormat(widget.busPicktime),style: const TextStyle(fontWeight: FontWeight.bold,color: Color(0xff7D2AFF)),),
                              const SizedBox(height: 8,),
                              Text(widget.trip_date.toString().split(" ").first,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 8,),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              const Image(image: AssetImage('assets/Auto Layout Horizontal.png'),height: 50,width: 140,color: Color(0xff7D2AFF)),
                              Text(widget.differencePickDrop),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(widget.dropCity,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              const SizedBox(height: 8,),
                              Text(convertTimeTo12HourFormat(widget.busDroptime),style: const TextStyle(fontWeight: FontWeight.bold,color: Color(0xff7D2AFF)),),
                              const SizedBox(height: 8,),
                              Text(widget.trip_date.toString().split(" ").first,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 8,),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
