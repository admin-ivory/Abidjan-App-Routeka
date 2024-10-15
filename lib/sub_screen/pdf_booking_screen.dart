// ignore_for_file: depend_on_referenced_packages, camel_case_types, non_constant_identifier_names, avoid_init_to_null, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API_MODEL/new_request_api_model.dart';
import 'package:http/http.dart' as http;

import '../Common_Code/common_button.dart';
import '../config/config.dart';
import 'search_bus_screen.dart';

class Pdf_Booking_ extends StatefulWidget {
  final String ticket_id;
  const Pdf_Booking_({super.key, required this.ticket_id});

  @override
  State<Pdf_Booking_> createState() => _Pdf_Booking_State();
}

class _Pdf_Booking_State extends State<Pdf_Booking_> {


  
  final pdf = pw.Document();
  late File? file = null;
  Newrequist? data1;
  bool isloading = true;

  @override
  void initState() {
    // TODO: implement initState
    getlocledata();
    super.initState();
  }

  double? totalPayment;
  String subtotal = "";
  String tax = "";

  var userData;
  var searchbus;
  getlocledata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData  = jsonDecode(prefs.getString("loginData")!);
      searchbus = jsonDecode(prefs.getString('currency')!);
      New_Requist(userData["id"], widget.ticket_id).then((value){
        setState(() {
          subtotal = data1!.tickethistory[0].subtotal;
          tax = data1!.tickethistory[0].taxAmt;

          totalPayment =  int.parse(subtotal) * int.parse(tax) / 100 ;
        });
      });

      print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${userData["mobile"]}');
    });
  }


  Future New_Requist(String uid, String ticket_id) async {

    Map body = {
      'uid' : uid,
      'ticket_id' : widget.ticket_id,
    };

    print("+++--++ $body");

    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/booking_details.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);

      if(response.statusCode == 200){
        setState(() {
          data1 = newrequistFromJson(response.body);
        });
        setState(() {
          isloading = false;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("tickethistory", jsonEncode(data1?.tickethistory[0].ticketId));
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }


  final image1 =  imageFromAssetBundle('assets/Auto Layout Horizontal.png');

  writeOnPDF() {
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.SizedBox(height: 10,),
            pw.ListView.builder(
                itemCount: data1!.tickethistory.length,
                itemBuilder: (context, int index) {

                  return pw.Padding(
                    padding:  const pw.EdgeInsets.only(top: 0),
                    child: pw.Container(
                      // height: 200,
                      // width: MediaQuery.of(context).size.width*0.8,
                      margin: const pw.EdgeInsets.only(bottom: 0),
                      decoration: pw.BoxDecoration(
                        // color: Colors.white,
                        borderRadius: pw.BorderRadius.circular(0),
                      ),
                      child:  pw.Padding(
                        padding: const pw. EdgeInsets.only(top: 15,bottom: 15),
                        child: pw.Column(
                          children: [
                            pw.Padding(
                              padding: const pw. EdgeInsets.only(right: 15),
                              child: pw.Row(
                                children: [
                                  pw. SizedBox(width: 15,),
                                  pw.Container(
                                      height: 40,
                                      width: 40,
                                      decoration: pw.BoxDecoration(
                                          borderRadius: pw.BorderRadius.circular(65),
                                      )
                                  ),
                                  pw. SizedBox(width: 10,),
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text('${data1?.tickethistory[index].busName}',style: pw. TextStyle(fontSize: 17,fontWeight: pw.FontWeight.bold,)),
                                      pw. SizedBox(height: 5,),
                                      pw.Row(
                                        children: [
                                          if(data1?.tickethistory[index].isAc == '1') pw. Text('AC Seater '),
                                        ],
                                      )
                                    ],
                                  ),
                                  pw. Spacer(),
                                  pw. SizedBox(width: 4,),
                                  pw.Text('$searchbus${data1?.tickethistory[0].total}',style: pw. TextStyle(fontSize: 16,fontWeight: pw.FontWeight.bold),),
                                ],
                              ),
                            ),
                            pw. SizedBox(height: 15,),
                            pw.Padding(
                              padding: const pw. EdgeInsets.only(left: 15,right: 15),
                              child: pw.Row(
                                children: [
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    mainAxisAlignment: pw.MainAxisAlignment.start,
                                    children: [
                                      pw.Text(data1!.tickethistory[index].boardingCity,style: pw. TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 16),),
                                      pw. SizedBox(height: 8,),
                                      pw.Text(convertTimeTo12HourFormat(data1!.tickethistory[index].busPicktime),style: pw. TextStyle(fontWeight: pw.FontWeight.bold,),),
                                      pw. SizedBox(height: 8,),
                                    ],
                                  ),
                                  pw. Spacer(),
                                  pw.Column(
                                    children: [
                                      pw.Text('${data1?.tickethistory[index].differencePickDrop}'),
                                    ],
                                  ),
                                  pw. Spacer(),
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                                    mainAxisAlignment: pw.MainAxisAlignment.end,
                                    children: [
                                      pw.Text('${data1?.tickethistory[index].dropCity}',style: pw. TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 16),),
                                      pw. SizedBox(height: 8,),
                                      pw.Text(convertTimeTo12HourFormat(data1!.tickethistory[index].busDroptime),style: pw. TextStyle(fontWeight: pw. FontWeight.bold),),
                                      pw. SizedBox(height: 8,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                ),
            pw.SizedBox(height: 10,),
            pw.Container(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw. SizedBox(height: 10,),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left:15,right: 15),
                    child: pw.Row(
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(data1!.tickethistory[0].subPickPlace,style: const pw. TextStyle(fontSize: 16)),
                            pw.Text(data1!.tickethistory[0].boardingCity,style: const pw. TextStyle(fontSize: 16)),
                            pw. SizedBox(height: 13,),
                            pw.Text(data1!.tickethistory[0].busPicktime,style: const pw. TextStyle(fontSize: 12)),
                          ],
                        ),
                        pw. Spacer(),
                        pw. Spacer(),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(data1!.tickethistory[0].subDropPlace,style: const pw. TextStyle(fontSize: 16)),
                            pw.Text(data1!.tickethistory[0].dropCity,style: const pw. TextStyle(fontSize: 16)),
                            pw. SizedBox(height: 13,),
                            pw.Text(data1!.tickethistory[0].subDropTime,style: const pw.TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw. SizedBox(height: 10,),
                ],
              ),
            ),
            pw. SizedBox(height: 10,),

            pw. Container(
              decoration: const pw. BoxDecoration(
              ),
              child:   pw.Padding(
                padding: const pw. EdgeInsets.all(0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw. SizedBox(height: 10,),
                    pw. Row(
                      children: [
                        pw.SizedBox(width: 15,),
                        pw.Text('Bus Details',style: const pw.TextStyle(fontSize: 17),),
                      ],
                    ),
                    pw. SizedBox(height: 20,),
                    pw.Padding(
                      padding: const pw. EdgeInsets.only(left: 15,right: 15),
                      child: pw.Column(
                        children: [
                          pw.Row(
                            children: [
                              pw. Text('Ticket Id',),
                              pw. Spacer(),
                              pw.Text('${data1?.tickethistory[0].ticketId}',),
                            ],
                          ),
                          pw. SizedBox(height: 15,),
                          pw.Row(
                            children: [
                              pw. Text('Bus Number'),
                              pw. Spacer(),
                              pw.Text('${data1?.tickethistory[0].busNo}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw. SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
            pw. SizedBox(height: 10,),

            pw.Container(
              decoration: const pw. BoxDecoration(
              ),
              child: pw.Padding(
                padding: const pw. EdgeInsets.all(0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw. SizedBox(height: 10,),
                    pw. Row(
                      children: [
                        pw.SizedBox(width: 15,),
                        pw.Text('Passenger(S)',style: const pw.TextStyle(fontSize: 17),),
                      ],
                    ),
                    pw. SizedBox(height: 20,),
                    pw.Padding(
                      padding: const pw. EdgeInsets.only(left: 15,right: 15),
                      child: pw.Column(
                        children: [
                          pw.Table(
                            columnWidths: <int, pw.TableColumnWidth>{
                              0: const pw.FixedColumnWidth(250),
                              1: const pw.FixedColumnWidth(40),
                              2: const pw.FixedColumnWidth(40),
                              3: const pw.FixedColumnWidth(40),
                            },
                            children: <pw.TableRow>[
                              pw.TableRow(
                                children: <pw.Widget>[
                                  pw.Text('Name',),
                                  pw.Center(child: pw.Text('Age')),
                                  pw.Center(child: pw.Text('Seat')),
                                ],
                              ),
                              for(int a = 0; a<data1!.tickethistory[0].orderProductData.length; a++)  pw.TableRow(
                                children: <pw.Widget>[
                                  pw.Padding(
                                    padding: const pw. EdgeInsets.only(top: 15),
                                    child: pw.Text('${data1?.tickethistory[0].orderProductData[a].name} (${data1?.tickethistory[0].orderProductData[a].gender})'),
                                  ),

                                  pw.Padding(
                                    padding: const pw. EdgeInsets.only(top: 15),
                                    child: pw.Center(child: pw.Text('${data1?.tickethistory[0].orderProductData[a].age}',)),
                                  ),
                                  // Text(widget.DataStore[index]["Age"],style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                  pw.Padding(
                                    padding: const pw. EdgeInsets.only(top: 15),
                                    child: pw.Center(child: pw.Text('${data1?.tickethistory[0].orderProductData[a].seatNo}')),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw. SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
            pw. SizedBox(height: 10,),
            pw.Container(
              decoration: const pw. BoxDecoration(
              ),
              child:  pw.Padding(
                padding: const pw. EdgeInsets.all(0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw. SizedBox(height: 10,),
                    pw. Row(
                      children: [
                        pw.SizedBox(width: 15,),
                        pw.Text('Contact Details'),
                      ],
                    ),
                    pw. SizedBox(height: 20,),
                    pw.Padding(
                      padding: const pw. EdgeInsets.only(left: 15,right: 15),
                      child: pw.Column(
                        children: [
                          pw.Row(
                            children: [
                              pw. Text('Full Name'),
                              pw. Spacer(),
                              pw.Text('${data1?.tickethistory[0].contactName}',),
                            ],
                          ),
                          pw. SizedBox(height: 15,),
                          pw.Row(
                            children: [
                              pw. Text('Email'),
                              pw. Spacer(),
                              pw.Text('${data1?.tickethistory[0].contactEmail}',),
                            ],
                          ),
                          pw. SizedBox(height: 15,),
                          pw.Row(
                            children: [
                              pw. Text('Phone Number'),
                              pw. Spacer(),
                              pw.Text('${data1?.tickethistory[0].contactMobile}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw. SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          pw. SizedBox(height: 10,),
          pw.Container(
              decoration: const pw. BoxDecoration(
              ),
              child:  pw.Padding(
                padding: const pw. EdgeInsets.all(0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
          pw. SizedBox(height: 10,),
          pw. Row(
                      children: [
                      pw. SizedBox(width: 15,),
          pw. Text('Price Details',style: const pw.TextStyle(fontSize: 17)),
                      ],
                    ),
          pw.Padding(
                      padding: const pw. EdgeInsets.only(left: 15,right: 15),
                      child: pw.Column(
                        children: [
          pw. SizedBox(height: 15,),
          pw.Row(
                            children: [
          pw. Text('Price'),
          pw. Spacer(),
          pw.Text('$searchbus ${data1?.tickethistory[0].subtotal}',style: const pw. TextStyle(),),
                            ],
                          ),
                            pw. SizedBox(height: 15,),
          pw.Row(
                            children: [
          pw.Text('Tax(${data1?.tickethistory[0].taxAmt}%)'),
          pw. Spacer(),
          pw.Text('$searchbus $totalPayment',style: const pw. TextStyle(),),
                            ],
                          ),
          pw. SizedBox(height: 15,),
          pw.Row(
                            children: [
          pw. Text('Discount'),
          pw. Spacer(),
          pw.Text('$searchbus ${data1?.tickethistory[0].couAmt}',style: const pw. TextStyle(),),
                            ],
                          ),
                          pw. SizedBox(height: 15,),
          pw.Row(
                            children: [
          pw. Text('Wallet'),
          pw. Spacer(),
          pw.Text('$searchbus ${data1?.tickethistory[0].wallAmt}',style: const pw. TextStyle(),),
                            ],
                          ),
          pw. SizedBox(height: 8,),
          pw.Divider(),
          pw. SizedBox(height: 8,),
          pw.Row(
                            children: [
          pw. Text('Total Price'),
          pw. Spacer(),
          pw.Text('$searchbus ${data1?.tickethistory[0].total} ',style: const pw. TextStyle(),),
                            ],
                          ),
          pw. SizedBox(height: 15,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          pw. SizedBox(height: 20,),


          ];
        }));
  }

  Future savePDF() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String assets = documentDirectory.path;

    File file = File("$assets/label.pdf");
    print("$assets/label.pdf");
    file.writeAsBytes(await pdf.save());
    Printing.layoutPdf(onLayout: (format) => pdf.save(),);

    setState(() {
      file = file;
    });
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: CommonButton(containcolore: const Color(0xff7D2AFF),txt1:  'Download Ticket',context: context,onPressed1: () {
          writeOnPDF();
          savePDF();
        }),
      ),
  body:

    file != null
      ? PDFView(filePath: file!.path)
      : const Center(
      child: Text("NO PDF\nClick Me Show PDF Button", style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
   ),
    );
  }







}
