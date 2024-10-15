// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';

class Ticket_Detail_Screen extends StatefulWidget {
  const Ticket_Detail_Screen({super.key});

  @override
  State<Ticket_Detail_Screen> createState() => _Ticket_Detail_ScreenState();
}

class _Ticket_Detail_ScreenState extends State<Ticket_Detail_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Transform.translate(
          offset: const Offset(-15, 0),
          child: const Text('Your ticket details',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
             height: 270,
             width: MediaQuery.of(context).size.width,
             color: Colors.red,
             child: const Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                        child: Column(
                          children: [
                            Icon(Icons.home,color: Colors.white,),
                            Text('|',style: TextStyle(color: Colors.white)),
                            Text('|',style: TextStyle(color: Colors.white)),
                            Text('|',style: TextStyle(color: Colors.white)),
                            Icon(Icons.home,color: Colors.white,),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text('Surat',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          Text('Laskana Char Rasta',style: TextStyle(color: Colors.white),),
                          SizedBox(height: 30,),
                          Text('Bhayavader',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          Text('Bhayavader Bus Stande',style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ],
                  ),
                 SizedBox(height: 10,),
                 Divider(color: Colors.white,thickness: 1,),
                 SizedBox(height: 10,),
                 Padding(
                   padding: EdgeInsets.only(left: 10,right: 10),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text('06:50 PM - 07:45 AM',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                       SizedBox(height: 8,),
                       Text('Duration : 12.55',style: TextStyle(color: Colors.white),),
                       SizedBox(height: 8,),
                       Text('7 Sep  Thursday',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                       SizedBox(height: 8,),
                       Text('Dharti Travels Matavadi',style: TextStyle(color: Colors.white),),
                       SizedBox(height: 8,),
                       Text('NON A/C Sleeper (2+1)',style: TextStyle(color: Colors.white),),
                     ],
                   ),
                 )
               ],
             ),
           ),
        ],
      ),
    );
  }
}