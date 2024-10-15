// ignore_for_file: unused_field, unused_element, depend_on_referenced_packages, camel_case_types, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, avoid_init_to_null, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zigzag/config/demo2.dart';

import '../API_MODEL/new_request_api_model.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'dart:ui' as ui;

import '../API_MODEL/post_revie_api_model.dart';
import '../All_Screen/bottom_navigation_bar_screen.dart';
import '../Common_Code/common_button.dart';
import '../Common_Code/homecontroller.dart';
import '../api_model/ticket_cancel_api_model.dart';
import '../config/config.dart';
import '../config/light_and_dark.dart';
import 'search_bus_screen.dart';

class Booking_Details extends StatefulWidget {
  final String ticket_id;
  final bool isDownload;
  final bool cancel;
  const Booking_Details(
      {super.key, required this.ticket_id, required this.isDownload, required this.cancel});

  @override
  State<Booking_Details> createState() => _Booking_DetailsState();
}

class _Booking_DetailsState extends State<Booking_Details> {
  @override
  void initState() {
    getlocledata();

    setState(() {
    });

    super.initState();
  }

  var userData;
  var searchbus;

  getlocledata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = jsonDecode(prefs.getString("loginData")!);
      searchbus = jsonDecode(prefs.getString('currency')!);

      New_Requist(userData["id"], widget.ticket_id).then((value) {
        setState(() {
          subtotal = data1!.tickethistory[0].subtotal;
          tax = data1!.tickethistory[0].taxAmt;
          numbers = data1!.tickethistory[0].subPickMobile.toString().split(",");
          print(numbers);
          totalPayment = double.parse(subtotal) * double.parse(tax) / 100;
        });
      });


      print(
          '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${userData["mobile"]}');
    });
  }

  bool isloading = true;
  Newrequist? data1;

  double? totalPayment;

  String subtotal = "";
  String tax = "";

  var capturedFile;
  var imagePath;

  Future New_Requist(String uid, String ticket_id) async {
    Map body = {
      'uid': uid,
      'ticket_id': widget.ticket_id,
    };

    print("+++--++ $body");

    try {
      var response = await http.post(
          Uri.parse('${config().baseUrl}/api/booking_details.php'),
          body: jsonEncode(body),
          headers: {
            'Content-Type': 'application/json',
          });

      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          data1 = newrequistFromJson(response.body);
        });
        setState(() {
          isloading = false;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("tickethistory", jsonEncode(data1?.tickethistory[0].ticketId));
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Postreview? data;
  TextEditingController reviwcontroller = TextEditingController();
  List numbers = [];

  Future Post_Revie_Api(String uid, String ticket_id) async {
    Map body = {
      'uid': uid,
      'ticket_id': widget.ticket_id,
      "total_rate": raing,
      "rate_text": reviwcontroller.text
    };

    print("+++--++ $body");

    try {
      var response = await http.post(
          Uri.parse('${config().baseUrl}/api/u_rate_update.php'),
          body: jsonEncode(body),
          headers: {
            'Content-Type': 'application/json',
          });

      print(response.body);

      if (response.statusCode == 200) {

        setState(() {
          data = postreviewFromJson(response.body);
        });
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data!.responseMsg.toString()),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
        );
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  final GlobalKey _globalKey = GlobalKey();

  final double _userRating = 3.0;

  IconData? _selectedIcon;
  final bool _isVertical = false;
  double raing = 0;

  final pdf = pw.Document();
  late File? file = null;
  final netImage = networkImage('https://www.nfet.net/nfet.jpg');


  Future savePDF() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String assets = documentDirectory.path;

    File file = File("$assets/label.pdf");
    print("$assets/label.pdf");
    file.writeAsBytes(await pdf.save());
    Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
    );
    Printing.sharePdf(bytes: await pdf.save(), filename: 'zigzag.pdf');

    setState(() {
      file = file;
    });
  }

  _makingPhoneCall(String number) async {
    var url = Uri.parse("tel:$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }


TextEditingController note = TextEditingController();
  CancleTicket? data2;
  Future Ticket_Cancel_Api(String uid, String ticket_id) async {
    Map body = {
      'ticket_id': widget.ticket_id,
      "uid": uid,
      "total": data1?.tickethistory[0].total == "0" ? data1?.tickethistory[0].wallAmt : data1?.tickethistory[0].total,
      "comment_reject": rejectmsg == "Others".tr
          ? note.text
          : rejectmsg,
    };

    print("+++--++ $body");

    try {
      var response = await http.post(
          Uri.parse('${config().baseUrl}/api/ticket_cancle.php'),
          body: jsonEncode(body),
          headers: {
            'Content-Type': 'application/json',
          });

      print(response.body);

      if (response.statusCode == 200) {

        setState(() {
          data2 = cancleTicketFromJson(response.body);
        });
        // setState(() {
        //   isloading = false;
        // });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data2!.responseMsg.toString()),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
        );
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }


  ColorNotifier notifier = ColorNotifier();
  List cancelList = [
    {"id": 1, "title": "Financing fell through".tr},
    {"id": 2, "title": "Inspection issues".tr},
    {"id": 3, "title": "Change in financial situation".tr},
    {"id": 4, "title": "Title issues".tr},
    {"id": 5, "title": "Seller changes their mind".tr},
    {"id": 6, "title": "Competing offer".tr},
    {"id": 7, "title": "Personal reasons".tr},
    {"id": 8, "title": "Others".tr},
  ];

  HomeController homeController = Get.put(HomeController());
  var selectedRadioTile;
  String rejectmsg = "";

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      bottomNavigationBar: (widget.isDownload || data1?.tickethistory[0].isRate == "0")  ?    Container(
        height: widget.cancel ? 70 : 0,
        width: MediaQuery.of(context).size.width,
        color: notifier.containercoloreproper,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: widget.isDownload ? CommonButton(containcolore: const Color(0xff7D2AFF), txt1: 'Download Ticket'.tr, context: context,onPressed1: () async {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return PdfPreviewPage(
                        data1: data1,
                        searchbus: searchbus,
                        totalPayment: totalPayment,
                      );
                    },
                  ));
                })
                    : (data1?.tickethistory[0].isRate == "0" && widget.cancel) ?  CommonButton(containcolore: const Color(0xff7D2AFF), txt1: 'Review'.tr, context: context,onPressed1: () {
                          Get.bottomSheet(isScrollControlled: true,
                              StatefulBuilder(builder: (context, setState) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 100),
                                  child: Container(
                                    // height: 200,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 5,),
                                            Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                    color: const Color(0xff7D2AFF),
                                                    borderRadius: BorderRadius.circular(65),
                                                    image: DecorationImage(image: NetworkImage('${config().baseUrl}/${data1?.tickethistory[0].busImg}'), fit: BoxFit.fill))),

                                            Text('${data1?.tickethistory[0].busName}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                                            RatingBar.builder(
                                                initialRating: 0,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                unratedColor: const Color(0xffEEEEEE),
                                                itemPadding: const EdgeInsets.only(right: 10),
                                                itemBuilder: (context, _) => const Icon(Icons.star, color: Color(0xff7D2AFF), size: 10),
                                                onRatingUpdate: (rating) {
                                                  raing = rating;
                                                  print(rating);
                                                }),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextField(
                                                    controller: reviwcontroller,
                                                    keyboardType: TextInputType.multiline,
                                                    maxLines: 5,
                                                    // obscureText: obscureText ?? false,
                                                    decoration:
                                                    InputDecoration(
                                                      counterText: '',
                                                      contentPadding:
                                                      const EdgeInsets.all(10),
                                                      border: const OutlineInputBorder(),
                                                      hintText: 'Enter your Feedback'.tr,
                                                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.99),fontFamily: 'GilroyMedium'),
                                                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xff5e59ff)),
                                                          borderRadius: BorderRadius.all(Radius.circular(10))),
                                                      enabledBorder: const OutlineInputBorder(
                                                          borderSide: BorderSide(color: Color(0xffd3d6da)),
                                                          borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                            CommonButton(containcolore: const Color(0xff7D2AFF), txt1: 'Rating'.tr, context: context,onPressed1: () {
                                              if(reviwcontroller.text.isEmpty){
                                                Get.back();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: const Text('Plese Enter your Feedback'),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                );
                                              }else{
                                                Post_Revie_Api(userData["id"], widget.ticket_id);
                                                Get.back();
                                                homeController.setselectpage(0);
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                                              }
                                            }),
                                            const SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }));
                        }) : null,),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ) : const SizedBox(),
      backgroundColor: notifier.backgroundgray,
      appBar: AppBar(
        backgroundColor: notifier.appbarcolore,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text('Booking Details'.tr, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
         (widget.isDownload ||  data1?.tickethistory[0].cancleShow == 1) ? Padding(
            padding: const EdgeInsets.only(top: 13,bottom: 13,right: 10),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    isDismissible: false,
                    isScrollControlled: true,
                    backgroundColor: notifier.containercoloreproper,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: Get.height * 0.02),
                                    Container(
                                        height: 6,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(25))),
                                    SizedBox(height: Get.height * 0.02),
                                    Text("Select Reason".tr, style:  TextStyle(fontSize: 20, color: notifier.textColor),),
                                    SizedBox(height: Get.height * 0.02),
                                    Text("Please select the reason for cancellation:".tr, style:  TextStyle(fontSize: 16, color: notifier.textColor),),
                                    SizedBox(height: Get.height * 0.02),
                                    ListView.builder(
                                      itemCount: cancelList.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (ctx, i) {
                                        return RadioListTile(
                                          dense: true,
                                          value: i,
                                          fillColor:  WidgetStatePropertyAll(notifier.theamcolorelight),
                                          activeColor: notifier.theamcolorelight,
                                          tileColor: notifier.theamcolorelight,
                                          selected: true,
                                          groupValue: selectedRadioTile,
                                          title: Transform.translate(offset: const Offset(-10, 0),child: Text(cancelList[i]["title"], style:  TextStyle(fontSize: 16, color: notifier.textColor),)),
                                          onChanged: (val) {
                                            setState(() {});
                                            selectedRadioTile = val;
                                            rejectmsg = cancelList[i]["title"];
                                          },
                                        );
                                      },
                                    ),
                                    rejectmsg == "Others"
                                        ?
                                    SizedBox(
                                      height: 50,
                                      width: Get.width * 0.85,
                                      child: TextField(
                                        controller: note,
                                        style: TextStyle(color: notifier.textColor),
                                        decoration: InputDecoration(
                                            isDense: true,
                                            enabledBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.grey, width: 1),
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(color: Colors.grey, width: 1),
                                            ),
                                            hintText: 'Enter reason'.tr,
                                            hintStyle: TextStyle(
                                                fontFamily: 'Gilroy Medium',
                                                fontSize: Get.size.height / 55,
                                                color: Colors.grey)),
                                      ),
                                    )
                                        : const SizedBox(),
                                    SizedBox(height: Get.height * 0.02),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: Get.width * 0.35,
                                          height: Get.height * 0.05,
                                          child: ticketbutton(title: "Cancel".tr, bgColor: Colors.red.withOpacity(0.6), titleColor: Colors.white,
                                            ontap: () {
                                              Get.back();
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: Get.width * 0.35,
                                          height: Get.height * 0.05,
                                          child: ticketbutton(
                                            title: "Confirm".tr,
                                            bgColor: notifier.theamcolorelight,
                                            titleColor: Colors.white,
                                            ontap: () {
                                              // myBookingController.cancleOrder(
                                              //   orderId1: orderId,
                                              //   reason: rejectmsg == "Others".tr
                                              //       ? note.text
                                              //       : rejectmsg,
                                              // );
                                              // if(selectedRadioTile.isNull){
                                              //   Fluttertoast.showToast(msg: 'Select Reason',);
                                              // }else{
                                                Ticket_Cancel_Api(userData["id"], widget.ticket_id);
                                                Get.back();
                                                homeController.setselectpage(0);
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));

                                              // }


                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Get.height * 0.04),
                                  ],
                                ),
                              ),
                            );
                          });
                    });

              },
              child: Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  Center(child: Text('Cancel'.tr,style: const TextStyle(color: Colors.white,fontSize: 12),)),
              ),
            ),
          ) : const SizedBox(),

        ],
      ),
      body: file != null
          ? PDFView(filePath: file!.path)
          : isloading
              ?  Center(child: CircularProgressIndicator(color: notifier.theamcolorelight),)
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 0);
                          },
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: data1!.tickethistory.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: InkWell(
                                onTap: () {
                                },
                                child: Container(
                                  // height: 200,
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  margin: const EdgeInsets.only(bottom: 0),
                                  decoration: BoxDecoration(
                                    color: notifier.containercoloreproper,
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15),
                                          child: Row(
                                            children: [
                                              const Image(image: AssetImage('assets/Rectangle_2.png'), height: 40),
                                              const SizedBox(width: 15,),
                                              Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      color: const Color(0xff7D2AFF),
                                                      borderRadius: BorderRadius.circular(65),
                                                      image: DecorationImage(image: NetworkImage('${config().baseUrl}/${data1?.tickethistory[index].busImg}'), fit: BoxFit.fill))),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('${data1?.tickethistory[index].busName}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: notifier.textColor)),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      if (data1?.tickethistory[index].isAc == '1')
                                                        Text('AC Seater'.tr,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: notifier
                                                                    .textColor)),
                                                    ],
                                                  )
                                                  // const Text('Economy'),
                                                ],
                                              ),
                                              const Spacer(),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                '$searchbus${data1?.tickethistory[0].subtotal}',
                                                style:  TextStyle(
                                                    color: notifier.theamcolorelight,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 15,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15,right: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: SizedBox(
                                                  width: 100,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(data1!.tickethistory[index].boardingCity, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: notifier.textColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                                                      const SizedBox(height: 8,),
                                                      Text(convertTimeTo12HourFormat(data1!.tickethistory[index].busPicktime), style:  TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: notifier.theamcolorelight), maxLines: 1, overflow: TextOverflow.ellipsis),
                                                      const SizedBox(height: 8,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // const Spacer(),
                                              const SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                   Image(image: const AssetImage('assets/Auto Layout Horizontal.png'), height: 50, width: 120, color: notifier.theamcolorelight),
                                                  Text('${data1?.tickethistory[index].differencePickDrop}', style: TextStyle(fontSize: 12, color: notifier.textColor)),
                                                ],
                                              ),
                                              // const Spacer(),
                                              const SizedBox(width: 10,),
                                              Flexible(
                                                child: SizedBox(
                                                  width: 100,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text('${data1?.tickethistory[index].dropCity}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: notifier.textColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                                                      const SizedBox(height: 8,),
                                                      Text(convertTimeTo12HourFormat(data1!.tickethistory[index].busDroptime), style:  TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: notifier.theamcolorelight), maxLines: 1, overflow: TextOverflow.ellipsis),
                                                      const SizedBox(height: 8,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                      const SizedBox(height: 10,),
                      Container(
                        // height: 120,
                        width: MediaQuery.of(context).size.width,
                        color: notifier.containercoloreproper,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: SizedBox(
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              data1!.tickethistory[0]
                                                  .subPickPlace,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: notifier.textColor)),
                                          Text(
                                              data1!.tickethistory[0]
                                                  .boardingCity,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: notifier.textColor)),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          SizedBox(
                                            height: 15,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            // color: Colors.black,
                                            child: ListView.separated(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                      onTap: () {
                                                        _makingPhoneCall(
                                                            numbers[index]);
                                                      },
                                                      child: Text(
                                                          numbers[index],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style:  TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: notifier.theamcolorelight)));
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return  Text(
                                                    "-",
                                                    style: TextStyle(
                                                        color: notifier.theamcolorelight),
                                                  );
                                                },
                                                itemCount: numbers.length),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                              convertTimeTo12HourFormat(data1!
                                                  .tickethistory[0]
                                                  .busPicktime),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: notifier.textColor)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
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
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: SizedBox(
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              data1!.tickethistory[0]
                                                  .subDropPlace,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: notifier.textColor)),
                                          Text(data1!.tickethistory[0].dropCity,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: notifier.textColor)),
                                          const SizedBox(
                                            height: 13,
                                          ),
                                          Text(
                                              convertTimeTo12HourFormat(data1!
                                                  .tickethistory[0]
                                                  .subDropTime),
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
                        // height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: notifier.containercoloreproper,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Image(
                                      image:
                                          AssetImage('assets/Rectangle_2.png'),
                                      height: 40),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'Bus Details'.tr,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: notifier.textColor),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('Booking Date'.tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                        const Spacer(),
                                        Text(
                                            '${data1?.tickethistory[0].bookDate.toString().split(' ').first}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text('Payment Method'.tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                        const Spacer(),
                                        Text(
                                            '${data1?.tickethistory[0].pMethodName}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text('Transaction Id'.tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                        const Spacer(),
                                        Text(
                                            '${data1?.tickethistory[0].transactionId}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text('Ticket Id'.tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                        const Spacer(),
                                        Text(
                                            '${data1?.tickethistory[0].ticketId}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                      ],
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
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: notifier.containercoloreproper,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Image(
                                      image:
                                          AssetImage('assets/Rectangle_2.png'),
                                      height: 40),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'Passenger(S)'.tr,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: notifier.textColor),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Table(
                                        // border: TableBorder.all(),
                                        columnWidths: const <int,
                                            TableColumnWidth>{
                                          0: FixedColumnWidth(250),
                                          1: FixedColumnWidth(40),
                                          2: FixedColumnWidth(40),
                                          3: FixedColumnWidth(40),
                                        },
                                        children: <TableRow>[
                                          TableRow(
                                            children: <Widget>[
                                              Text('Name'.tr,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                      color: notifier.textColor)),
                                              Center(
                                                  child: Text('Age'.tr,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color: notifier
                                                              .textColor))),
                                              Center(
                                                  child: Text('Seat'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: notifier.textColor))),
                                            ],
                                          ),
                                          for (int a = 0; a < data1!.tickethistory[0].orderProductData.length; a++)
                                            TableRow(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 15),
                                                  child: Text(
                                                      '${data1?.tickethistory[0].orderProductData[a].name} (${data1?.tickethistory[0].orderProductData[a].gender})',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color: notifier
                                                              .textColor)),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 15),
                                                  child: Center(
                                                      child: Text(
                                                          '${data1?.tickethistory[0].orderProductData[a].age}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 12,
                                                              color: notifier
                                                                  .textColor))),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 15),
                                                  child: Center(
                                                      child: Text(
                                                          '${data1?.tickethistory[0].orderProductData[a].seatNo}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 12,
                                                              color: notifier
                                                                  .textColor))),
                                                ),
                                              ],
                                            ),
                                        ],
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
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        // height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: notifier.containercoloreproper,
                          // borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Image(
                                      image:
                                          AssetImage('assets/Rectangle_2.png'),
                                      height: 40),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'Contact Details'.tr,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: notifier.textColor),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('Full Name'.tr,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                        const Spacer(),
                                        Text(
                                            '${data1?.tickethistory[0].contactName}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text('Email'.tr,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                        const Spacer(),
                                        Text(
                                            '${data1?.tickethistory[0].contactEmail}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text('Phone Number'.tr,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                        const Spacer(),
                                        Text(
                                            '${data1?.tickethistory[0].contactMobile}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                      ],
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
                      ),
                      const SizedBox(height: 10,),
                      data1!.tickethistory[0].driverName.isEmpty && data1!.tickethistory[0].driverMobile.isEmpty && data1!.tickethistory[0].busNo.isEmpty ? const SizedBox() : Container(
                              // height: 200,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: notifier.containercoloreproper,
                                // borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Image(
                                            image: AssetImage(
                                                'assets/Rectangle_2.png'),
                                            height: 40),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          'Driver Details',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: notifier.textColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Driver Name',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          notifier.textColor)),
                                              const Spacer(),
                                              Text(
                                                  '${data1?.tickethistory[0].driverName}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color:
                                                          notifier.textColor)),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Text('Driver Number',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          notifier.textColor)),
                                              const Spacer(),
                                              Text(
                                                  '${data1?.tickethistory[0].driverMobile}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color:
                                                          notifier.textColor)),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Text('Bus Number',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          notifier.textColor)),
                                              const Spacer(),
                                              Text(
                                                  '${data1?.tickethistory[0].busNo}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color:
                                                          notifier.textColor)),
                                            ],
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
                            ),
                      data1!.tickethistory[0].driverName.isEmpty && data1!.tickethistory[0].driverMobile.isEmpty && data1!.tickethistory[0].busNo.isEmpty ? const SizedBox() : const SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: notifier.containercoloreproper,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Image(
                                      image:
                                          AssetImage('assets/Rectangle_2.png'),
                                      height: 40),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text('Price Details'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: notifier.textColor)),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text('Price'.tr,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                        const Spacer(),
                                        Text(
                                          '$searchbus ${data1?.tickethistory[0].subtotal}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: notifier.textColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //         'Tax(${data1?.tickethistory[0].taxAmt}%)', style: TextStyle(fontSize: 12, color: notifier.textColor)),
                                    //     const Spacer(),
                                    //     Text('$searchbus ${totalPayment?.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: notifier.textColor),
                                    //     ),
                                    //   ],
                                    // ),
                                    Row(
                                      children: [
                                        Text(
                                            'Tax(${data1?.tickethistory[0].tax}%)', style: TextStyle(fontSize: 12, color: notifier.textColor)),
                                        const Spacer(),
                                        Text('$searchbus ${data1?.tickethistory[0].taxAmt}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: notifier.textColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text('Discount'.tr,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                        const Spacer(),
                                        Text(
                                          '$searchbus ${data1?.tickethistory[0].couAmt}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text('Wallet'.tr,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                        const Spacer(),
                                        Text(
                                          '$searchbus ${data1?.tickethistory[0].wallAmt}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Divider(
                                        color: Colors.grey.withOpacity(0.4)),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Text('Total Price'.tr,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: notifier.textColor)),
                                        const Spacer(),
                                        Text(
                                          '$searchbus ${data1?.tickethistory[0].total} ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: notifier.textColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      widget.isDownload?  Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            // color: notifier.containercoloreproper,
                            color: const Color(0xff7D2AFF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child:  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text('The driver`s mobile number, name, and bus number will be presented one hour prior to your scheduled bus departure time.',style: TextStyle(color: notifier.textColor),maxLines: 3,)
                              ],
                            ),
                          ),
                        ),
                      ) : const SizedBox(),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
    );
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();

    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');

    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    return result['filepath'];
  }

  Future _capturePng() async {
    try {
      await [Permission.storage].request();
      print('inside');
      RenderRepaintBoundary boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      //create file
      final String dir = (await getApplicationDocumentsDirectory()).path;
      imagePath = '$dir/file_name${DateTime.now()}.png';
      capturedFile = File(imagePath);
      await capturedFile.writeAsBytes(pngBytes);
      print(capturedFile!.path);
      final result = await ImageGallerySaver.saveImage(pngBytes!,
          quality: 60, name: "file_name${DateTime.now()}");
      print(result);
      print('png done');
      // showToastMessage("Image saved in gallery");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image saved in gallery'.tr),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

}


ticketbutton(
    {Function()? ontap,
      String? title,
      Color? bgColor,
      titleColor,
      Gradient? gradient1}) {
  return InkWell(
    onTap: ontap,
    child: Container(
      height: Get.height * 0.04,
      width: Get.width * 0.40,
      decoration: BoxDecoration(
        color: bgColor,
        gradient: gradient1,
        borderRadius: (BorderRadius.circular(10)),
      ),
      child: Center(
        child: Text(title!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: titleColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                fontFamily: 'Gilroy Medium')),
      ),
    ),
  );
}
