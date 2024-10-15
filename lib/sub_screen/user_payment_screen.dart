// ignore_for_file: camel_case_types, file_names, non_constant_identifier_names, avoid_print, depend_on_referenced_packages, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:cinetpay/cinetpay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API_MODEL/book_ticket_api.dart';
import '../API_MODEL/couponlist_api_model.dart';
import '../API_MODEL/payment_getway_api_model.dart';
import '../API_MODEL/referdata_api_model.dart';
import 'package:http/http.dart' as http;

import '../All_Screen/bottom_navigation_bar_screen.dart';
import '../Common_Code/homecontroller.dart';
import '../Payment_Getway/flutterwave.dart';
import '../Payment_Getway/inputformater.dart';
import '../Payment_Getway/paymentcard.dart';
import '../Payment_Getway/paypal.dart';
import '../Payment_Getway/paytm.dart';
import '../Payment_Getway/razorpay.dart';
import '../Payment_Getway/senangpay.dart';
import '../Payment_Getway/stripeweb.dart';
import '../config/config.dart';
import '../config/light_and_dark.dart';
import '../payment_getway/cinetpay.dart';
import 'search_bus_screen.dart';

class Payment_Screen extends StatefulWidget {
  final String busTitle;
  final String busImg;
  final String ticketPrice;
  final String boardingCity;
  final String dropCity;
  final String busPicktime;
  final String busDroptime;
  final String mobileController;
  final String FullnameController;
  final String EmailController;
  final String uid;
  final List DataStore;
  final String selectIndex;
  final String selectIndex1;
  final List selectset;
  final List selectset1;
  final num bottom;
  final String wallet;
  final List ma_fe;
  final List data;
  final List data1;
  final String busAc;
  final String isSleeper;
  final String totlSeat;
  final String differencePickDrop;
  final String currency;
  final String bus_id;
  final String pick_id;
  final String dropId;
  final String trip_date;
  final List listDynamic;
  final List listDynamicage;
  final List siteNumber;
  final List manadf;
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



  const Payment_Screen({super.key, required this.busTitle, required this.busImg, required this.ticketPrice, required this.boardingCity, required this.dropCity, required this.busPicktime, required this.busDroptime, required this.mobileController, required this.FullnameController, required this.EmailController, required this.uid, required this.DataStore, required this.selectIndex, required this.selectIndex1, required this.selectset, required this.selectset1, required this.bottom, required this.wallet, required this.ma_fe, required this.data, required this.data1, required this.busAc, required this.isSleeper, required this.totlSeat, required this.differencePickDrop, required this.currency, required this.bus_id, required this.pick_id, required this.dropId, required this.trip_date, required this.listDynamic, required this.listDynamicage, required this.siteNumber, required this.manadf, required this.boarding_id, required this.drop_id, required this.Difference_pick_drop, required this.pickTime, required this.pick_place, required this.pick_address, required this.pick_mobile, required this.dropTime, required this.drop_place, required this.drop_address, required this.pick_time, required this.drop_time, required this.pickMobile, required this.agentCommission, required this.com_per, required this.is_verify});

  @override
  State<Payment_Screen> createState() => _Payment_ScreenState();
}

class _Payment_ScreenState extends State<Payment_Screen> {


  bool isloading = true;

  Referdata? data;

// Referdata Api Calling

  Future Referdata_Api(String uid) async {

    Map body = {
      'uid' : uid,
    };

    print("+++ $body");

    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/referdata.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){
        setState(() {
          data = referdataFromJson(response.body);
        });

      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }


   List siteNumber = [];
   double  totalAmount = 0.0;
   double totallist  = 0.0;
   double finaltotal = 0.0;
   double totalamount2 = 0.0;
   double walet  = 0.0;
   bool light = false;
   int  coupon = 0;

   var result;


  @override
  void initState() {
    super.initState();
    getlocledata();
    fun12();
    walletMain = double.parse(widget.wallet);

    Referdata_Api(widget.uid).then((value) {

      setState(() {
        siteNumber = widget.selectset + widget.selectset1;
        totallist = (widget.bottom * int.parse(taxamount) / 100);

        totalPayment = widget.bottom + (widget.bottom * int.parse(taxamount) / 100);
        totalAmount = (totallist + widget.bottom);
        totalamount2 = totalAmount;
      });
    });
    CouponList_Api(widget.uid);
    Payment_Getway();

  razorPayClass.initiateRazorPay(handlePaymentSuccess: handlePaymentSuccess, handlePaymentError: handlePaymentError, handleExternalWallet: handleExternalWallet);

    setState(() {
      siteNumber = widget.selectset + widget.selectset1;
    });

  }

  @override
  void dispose() {
    razorPayClass.desposRazorPay();
    widget.DataStore.clear();
    super.dispose();
  }

  Couponlist? data1;
  TicketBookApi? ticket;

// CouponList Api Calling

  Future CouponList_Api(String uid) async {

    Map body = {
      'uid' : uid,
    };

    print("+++ $body");
    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/u_couponlist.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){

        setState(() {
          data1 = couponlistFromJson(response.body);
          isloading = false;
          print("////////////////////////1254638455///////////////////////////////////////////  ${widget.busPicktime}");
        });

      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }

  late PaymentGetway from12;

//Get Api Calling  Payment Getway List Api


  Future Payment_Getway() async {
    var response1 = await http.get(Uri.parse('${config().baseUrl}/api/paymentgateway.php'),);
    if (response1.statusCode == 200) {
      var jsonData = json.decode(response1.body);
      print(jsonData["paymentdata"]);
      setState(() {
        from12 = paymentGetwayFromJson(response1.body);
      });
    }
  }



  // Book Ticket Calling
  String paymentmethodId = '5';

  HomeController homeController = Get.put(HomeController());
  Future Book_Ticket({required String uid, required String bus_id, required String pick_id, required String dropId, required String trip_date, required String ticketPrice, required String paymentId,required String boardingCity,required String dropCity,required String busPicktime ,required String busDroptime,required String Difference_pick_drop}) async {

    Map body = {
      'uid' : uid,
      'name' : widget.FullnameController,
      'bus_id' : bus_id,
      'email' : widget.EmailController,
      'ccode' : userData['ccode'],
      'mobile' : widget.mobileController,
      'pickup_id' : pick_id,
      'drop_id' : dropId,
      'total' : totalPayment.toStringAsFixed(2),
      'cou_amt' : coupon,
      'wall_amt' : walletValue.toStringAsFixed(2),
      'book_date' : trip_date.toString().split(" ").first,
      'total_seat' : PessengerData.length,
      'seat_list' : widget.siteNumber.join(','),
      'payment_method_id' : paymentmethodId,
      'ticket_price' : ticketPrice,
      'transaction_id' : paymentId,
      'boarding_city': boardingCity,
      'drop_city': dropCity,
      'bus_picktime': busPicktime,
      'bus_droptime': busDroptime,
      'Difference_pick_drop': Difference_pick_drop,
      'tax_amt' : totallist.toStringAsFixed(2),
      'sub_pick_time':widget.pick_time,
      'sub_pick_place':widget.pick_place,
      'sub_pick_address':widget.pick_address,
      'sub_pick_mobile':widget.pick_mobile,
      'sub_drop_time':widget.drop_time,
      'sub_drop_place':widget.drop_place,
      'sub_drop_address':widget.drop_address,
      'subtotal' : widget.bottom,
      'user_type': userData["user_type"],
      'commission':  userData['user_type']=='AGENT' ? widget.agentCommission : "0",
      "comm_per": widget.com_per,
      'PessengerData' : PessengerData
    };

    print("+++ $body");
    try{
      var response2 = await http.post(Uri.parse('${config().baseUrl}/api/ticket_book.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response2.body);
      // print("//////////////////////////////////////////////////////////////////////////////////////  ${widget.siteNumber.join(',')}");
      print("///////////////////////////////////1254638455////////////////////////////////  ${widget.busPicktime}");
      if(response2.statusCode == 200){

        setState(() {
          var ticket = ticketBookApiFromJson(response2.body);
          Get.back();
          if(ticket.result == "true"){
            showDialog<String>(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => PopScope(
                // onWillPop: () {
                //   homeController.setselectpage(0);
                //   // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                //   Get.offAll(const Bottom_Navigation());
                //   return Future(() => false);
                // },
                canPop: false,
                onPopInvoked: (didPop) async{
                  homeController.setselectpage(0);
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                  Get.offAll(const Bottom_Navigation());
                  return Future(() => false);
                },
                child: AlertDialog(
                  backgroundColor: notifier.containercoloreproper,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  title: Column(
                    children: [
                     SizedBox(
                       height: 150,
                       width: 150,
                       child: Lottie.asset('assets/lottie/ticket-confirm.json',fit: BoxFit.cover)),
                       Text('Booking Confirmed!'.tr,style: const TextStyle(fontWeight: FontWeight.bold,color: Color(0xff7D2AFF)),),
                       const SizedBox(height: 12,),
                       Text('Congratulation! your bus ticket is confirmed. For more details check the My Booking tab.'.tr,style: TextStyle(color: notifier.textColor,fontSize: 15,),textAlign: TextAlign.center,),
                       const SizedBox(height: 50,),
                       ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Bottom_Navigation(),));
                          homeController.setselectpage(1);
                          },
                        style: ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),backgroundColor: const WidgetStatePropertyAll(Color(0xff7D2AFF))),
                        child:  Text('View Transaction'.tr,style: const TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Bottom_Navigation(),));
                        },
                        style: ButtonStyle(elevation: const WidgetStatePropertyAll(0),shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),backgroundColor: const WidgetStatePropertyAll(Colors.white)),
                        child:  Text('Back to Home'.tr,style: const TextStyle(color: Color(0xff7D2AFF))),
                      ),
                    ],
                  ),
                ),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(ticket.responseMsg),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(ticket.responseMsg),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
            );
          }
        });

      }else {
        print('failed');
      }

    }catch(e){
      print(e.toString());
    }
  }

  List PessengerData = [];

  fun12(){
   setState(() {
     for(int a=0; a<widget.listDynamic.length; a++){
       PessengerData.add({
         "name"    : "${widget.data[a]}",
         "age"     : "${widget.data1[a]}",
         "seat_no" : "${widget.siteNumber[a]}",
         "gender"  : widget.manadf[a].toString().split("-").first
       });
     }

   });

  print(PessengerData);
}



  String selectedOption = '';
  String selectBoring = "";
  var userData;
  var searchbus1;
  var taxamount;

  // Razorpay Code
  RazorPayClass  razorPayClass = RazorPayClass();


  // Razorpay? _razorpay;

  void handlePaymentSuccess(PaymentSuccessResponse response){
    Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "${response.paymentId}",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
    // Fluttertoast.showToast(msg: 'SUCCESS PAYMENT : ${response.paymentId}',timeInSecForIosWeb: 4);
  }
  void handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(msg: 'ERROR HERE: ${response.code} - ${response.message}',timeInSecForIosWeb: 4);
  }
  void handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(msg: 'EXTERNAL_WALLET IS: ${response.walletName}',timeInSecForIosWeb: 4);
  }


  getlocledata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userData  = jsonDecode(prefs.getString("loginData")!);
        searchbus1  = jsonDecode(prefs.getString("bussearch")!);
        taxamount  = jsonDecode(prefs.getString("tax")!);
        // Book_Ticket(widget.uid, widget.bus_id, widget.pick_id, widget.dropId, widget.trip_date,"${response.paymentId}");
        print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${userData["name"]}');
        print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+$searchbus1');
      });
  }


  bool off = false;
  List  isReademore = [];



  double walletMain = 0;
  double totalPayment = 0;
  double walletValue = 0;
  int payment = 0;



  ColorNotifier notifier = ColorNotifier();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: notifier.containercoloreproper,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                // border: Border.all(color: Colors.grey.withOpacity(0.4)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [



                  Row(
                    children: [
                      Text('Total Pay'.tr,style:  TextStyle(color: notifier.textColor,fontSize: 18)),
                      Text(':-'.tr,style:  TextStyle(color: notifier.textColor,fontSize: 18)),
                      const SizedBox(width: 5,),
                      Text('${widget.currency} ${totalPayment.toStringAsFixed(2)}',style:  TextStyle(color: notifier.textColor,fontWeight: FontWeight.bold,fontSize: 18)),
                      const Expanded(child: SizedBox(width: 5,)),
                   Container(
                        height: 35,
                        width: 90,
                        decoration: BoxDecoration(
                            color: notifier.theamcolorelight,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child:  ElevatedButton(
                            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(notifier.theamcolorelight),shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))),
                            onPressed: () {

                              widget.is_verify == "0" ?  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content:  Text( widget.is_verify == "2" ?  "Your profile has been declined, resulting in the loss of regular user access to our application" : 'Once your profile is verified, you will be able to book bus tickets and earn commissions.'),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                              ):    totalPayment == 0 ? Book_Ticket(uid:  widget.uid,bus_id:  widget.bus_id ,pick_id:  widget.pick_id, dropId:  widget.dropId, ticketPrice:  widget.ticketPrice, trip_date: widget.trip_date, paymentId:  '0',boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop) :
                              showModalBottomSheet(
                                isDismissible: false,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState)  {
                                        return ClipRRect(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                                          child: Scaffold(
                                            // backgroundColor: notifier.containercoloreproper,
                                            // backgroundColor: Colors.white,
                                            backgroundColor: Colors.transparent,
                                            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                                            floatingActionButton: Padding(
                                              padding:const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                                              child: Container(
                                                  height: 42,
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                    color: notifier.theamcolorelight,
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(notifier.theamcolorelight),shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))),
                                                    onPressed: () {

                                                      if(from12.paymentdata[payment].title == "Razorpay"){
                                                        razorPayClass.openCheckout(key: from12.paymentdata[0].attributes, amount: '$totalPayment', number: '${userData['mobile']}', name: '${userData['email']}');
                                                      }
                                                      else if(from12.paymentdata[payment].title == "Paypal"){
                                                        List ids = from12.paymentdata[1].attributes.toString().split(",");
                                                        print('++++++++++ids:------$ids');
                                                        paypalPayment(
                                                          context: context,
                                                          function: (e){
                                                            Book_Ticket(uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$e",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                                                          },
                                                          amt: totalPayment.toStringAsFixed(2),
                                                          clientId: ids[0],
                                                          secretKey: ids[1],
                                                        );
                                                      }
                                                      else if(from12.paymentdata[payment].title == "Stripe"){
                                                        Get.back();
                                                        stripePayment();
                                                      }
                                                      else if(from12.paymentdata[payment].title == "FlutterWave"){
                                                        Get.to(() => Flutterwave(
                                                            totalAmount: totalPayment.toStringAsFixed(2),
                                                            email: userData['email']
                                                        ))!
                                                            .then((otid) {
                                                          if (otid != null) {
                                                            Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                                                            Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                                          } else {
                                                            Get.back();
                                                          }
                                                        });
                                                      }
                                                      else if(from12.paymentdata[payment].title == "Paytm"){
                                                        Get.to(() => PayTmPayment(
                                                            totalAmount: totalPayment.toStringAsFixed(2),
                                                            uid: userData['id']
                                                        ))!
                                                            .then((otid) {
                                                          if (otid != null) {
                                                            Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                                                            Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                                          } else {
                                                            Get.back();
                                                          }
                                                        });
                                                      }
                                                      else if(from12.paymentdata[payment].title == "SenangPay"){
                                                        Get.to(SenangPay(
                                                            email: userData['email'],
                                                            totalAmount: totalPayment.toStringAsFixed(2),
                                                            name: userData['name'],
                                                            phon: userData['mobile']))!
                                                            .then((otid) {
                                                          if (otid != null) {
                                                            Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                                                          } else {
                                                            Get.back();
                                                          }
                                                        });
                                                      }
                                                      else if (from12.paymentdata[payment].title == 'Cinetpay'){
                                                        Get.to(CinetPayCheckout(
                                                            title: 'Guichet de transaction Routeka',
                                                            configData: <String, dynamic> {
                                                              'apikey': '63166275965f879eebbcf60.62241459',
                                                              'site_id':'5878408',
                                                              'notify_url': 'https://kpanel.routeka.com/cinetpay/Notify_url.php'
                                                            },
                                                            paymentData: <String, dynamic>{
                                                              'transaction_id': genererNumeroID(),
                                                              'amount': totalPayment.toStringAsFixed(2),
                                                              'currency': 'XOF',
                                                              'channels': 'ALL',
                                                              'description': 'Payment Routeka',
                                                              'customer_country':'CI'

                                                            },
                                                            waitResponse: (response) {
                                                              print(response);
                                                            },
                                                            onError: (error) {
                                                              print(error);
                                                            }))!.then((otid) {
                                                          Get.back();
                                                          if (otid != null) {
                                                            Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
                                                          } else {
                                                            Get.back();
                                                          }
                                                        });
                                                      }

                                                      else{
                                                        Get.back();
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text('Not Valid'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                        );
                                                      }

                                                    },
                                                    child: Center(
                                                      child: RichText(text:  TextSpan(
                                                          children: [
                                                            TextSpan(text: 'CONTINUE'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                                          ]
                                                      )),
                                                    ),
                                                  )
                                              ),
                                            ),
                                            body: Container(
                                              height: 450,
                                              decoration:  BoxDecoration(
                                                  color: notifier.containercoloreproper,
                                                  // color: Colors.yellowAccent,

                                                  // border: Border.all(color: notifier.textColor),
                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                                              ),
                                              child:  Padding(
                                                padding: const EdgeInsets.only(left: 10,right: 10,bottom: 50),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget> [

                                                    const SizedBox(height: 13,),
                                                    Text('Payment Getway Method'.tr,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: notifier.textColor)),
                                                    const SizedBox(height: 4,),
                                                    Expanded(
                                                      child: ListView.separated(
                                                          separatorBuilder: (context, index) {
                                                            return const SizedBox(width: 0,);
                                                          },
                                                          shrinkWrap: true,
                                                          scrollDirection: Axis.vertical,
                                                          physics: const BouncingScrollPhysics(),
                                                          itemCount: from12.paymentdata.length,
                                                          itemBuilder: (BuildContext context, int index) {
                                                            return InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  payment = index;
                                                                  paymentmethodId = from12.paymentdata[index].id;
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 90,
                                                                margin: const EdgeInsets.only(left: 10,right: 10,top: 6,bottom: 6),
                                                                padding: const EdgeInsets.all(5),
                                                                decoration: BoxDecoration(
                                                                  // color: Colors.red,
                                                                  border: Border.all(color: payment == index ? notifier.theamcolorelight : Colors.grey.withOpacity(0.4)),
                                                                  borderRadius: BorderRadius.circular(15),
                                                                ),
                                                                child: Center(
                                                                  child: ListTile(
                                                                    leading: Transform.translate(offset: const Offset(-5, 0),child: Container(
                                                                      height: 100,
                                                                      width: 60,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(15),
                                                                          border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                                          image: DecorationImage(image: NetworkImage('${config().baseUrl}/${from12.paymentdata[index].img}'))
                                                                      ),
                                                                    ),),
                                                                    title: Padding(
                                                                      padding: const EdgeInsets.only(bottom: 4),
                                                                      child: Text(from12.paymentdata[index].title,style:  TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: notifier.textColor),maxLines: 2,),
                                                                    ),
                                                                    subtitle: Padding(
                                                                      padding: const EdgeInsets.only(bottom: 4),
                                                                      child: Text(from12.paymentdata[index].subtitle,style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.textColor),maxLines: 2,),
                                                                    ),
                                                                    trailing: Radio(
                                                                      value: payment == index ? true : false,
                                                                      fillColor:  WidgetStatePropertyAll(notifier.theamcolorelight),
                                                                      groupValue: true,
                                                                      onChanged: (value) {
                                                                        print(value);
                                                                        setState(() {
                                                                          selectedOption = value.toString();
                                                                          selectBoring = from12.paymentdata[index].img;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                              );





                            },
                            child: Center(child: Text('PROCEED'.tr,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),))),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
          // Text("$bottom",style: TextStyle(color: Colors.red)),
        ],
      ),
      backgroundColor: notifier.backgroundgray,
      resizeToAvoidBottomInset: false,
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
      body: isloading ?  Center(child: CircularProgressIndicator(color: notifier.theamcolorelight),) :  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 10),
          child: Column(
            children: [





              const SizedBox(height: 5),


              Container(
                // height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: notifier.containercoloreproper,
                  borderRadius: BorderRadius.circular(0),
                ),
                child:  Padding(
                  padding: const EdgeInsets.only(left: 0,right: 0),
                  child: Column(
                    children: [
                      const SizedBox(height: 15,),
                      Row(
                        children: [
                          const Image(image: AssetImage('assets/Rectangle_2.png'),height: 40),
                          const SizedBox(width: 15,),
                          Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: notifier.theamcolorelight,
                                  borderRadius: BorderRadius.circular(65),
                                  image: DecorationImage(image: NetworkImage('${config().baseUrl}/${widget.busImg}'),fit: BoxFit.fill))
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.busTitle,style:  TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notifier.textColor)),
                              const SizedBox(height: 5,),
                              Row(
                                children: [
                                  if(widget.busAc == '1')  Text('AC Seater'.tr,style: TextStyle(fontSize: 12,color: notifier.textColor)),
                                  if(widget.isSleeper == '1')  Text('/ Sleeper'.tr,style: TextStyle(fontSize: 12,color: notifier.textColor)),
                                  const SizedBox(width: 5,),
                                  Container(
                                      height: 22,
                                      width: 65,
                                      decoration: BoxDecoration(
                                        // color: const Color(0xffD6C1F9).withOpacity(0.3),
                                          color: notifier.seatcontainere,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Center(child: Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Text('${widget.totlSeat} Seats',style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.seattextcolore),),
                                      ))),
                                ],
                              )
                            ],
                          ),
                          const Spacer(),
                          const SizedBox(width: 4,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: Text('${widget.currency} ${widget.ticketPrice}',style:  TextStyle(color: notifier.theamcolorelight,fontSize: 15,fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: SizedBox(
                                width: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(widget.boardingCity,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor),maxLines: 1,overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 8,),
                                    Text(convertTimeTo12HourFormat(widget.busPicktime),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.theamcolorelight),maxLines: 1,overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 8,),
                                    const SizedBox(height: 8,),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Image(image: const AssetImage('assets/Auto Layout Horizontal.png'),height: 50,width: 120,color: notifier.theamcolorelight),
                                Text(widget.differencePickDrop,style: TextStyle(fontSize: 12,color: notifier.textColor)),
                              ],
                            ),
                            Flexible(
                              child: SizedBox(
                                width: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(widget.dropCity,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor),maxLines: 1,overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 8,),
                                    Text(convertTimeTo12HourFormat(widget.busDroptime),style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.theamcolorelight),maxLines: 1,overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 8,),
                                    // Text('${_selectedDate.toString().split(" ").first}',style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                    const SizedBox(height: 8,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15,),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration:  BoxDecoration(
                  color: notifier.containercoloreproper,
                ),
                child:   Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                       Row(
                        children: [
                          const Image(image: AssetImage('assets/Rectangle_2.png'),height: 40),
                          const SizedBox(width: 15,),
                          Text('Contact Details'.tr,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: notifier.textColor),),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                 Text('Full Name'.tr,style: TextStyle(fontSize: 12,color: notifier.textColor)),
                                const Spacer(),
                                Text(widget.FullnameController,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor)),
                              ],
                            ),
                            const SizedBox(height: 15,),
                            Row(
                              children: [
                                 Text('Email'.tr,style: TextStyle(fontSize: 12,color: notifier.textColor)),
                                const Spacer(),
                                Text(widget.EmailController,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor)),
                              ],
                            ),
                            const SizedBox(height: 15,),
                            Row(
                              children: [
                                 Text('Phone Number'.tr,style: TextStyle(fontSize: 12,color: notifier.textColor)),
                                const Spacer(),
                                Text(widget.mobileController,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              Container(
                // height: 200,
                width: MediaQuery.of(context).size.width,
                decoration:  BoxDecoration(
                  color: notifier.containercoloreproper,
                ),
                child:   Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                       Row(
                        children: [
                          const Image(image: AssetImage('assets/Rectangle_2.png'),height: 40),
                          const SizedBox(width: 15,),
                          Text('Passenger(S)'.tr,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: notifier.textColor),),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Table(
                                // border: TableBorder.all(color: Colors.white),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FixedColumnWidth(250),
                                  1: FixedColumnWidth(40),
                                  2: FixedColumnWidth(40),
                                  3: FixedColumnWidth(40),
                                },
                                children: <TableRow>[
                                   TableRow(
                                    children: <Widget>[
                                      Text('Name'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor)),
                                      Center(child: Text('Age'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor))),
                                      Center(child: Text('Seat'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor))),
                                    ],
                                  ),
                                  for(int a = 0; a<widget.data.length; a++)  TableRow(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Text('${widget.data[a]} (${widget.ma_fe[a].toString().split("-").first})',style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Center(child: Text('${widget.data1[a]}',style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Center(child: Text('${siteNumber[a]}',style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor))),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              Container(
                // height: 200,
                width: MediaQuery.of(context).size.width,
                decoration:  BoxDecoration(
                  color: notifier.containercoloreproper,
                ),
                child:  Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      InkWell(
                        onTap: () {
                          setState(() {
                            light = false;
                            walletValue = 0;
                            walletMain = double.parse(widget.wallet);
                            totalPayment = widget.bottom + (widget.bottom * int.parse(taxamount) / 100);
                            coupon = 0;
                          });
                          if(coupon == 0){



                            showModalBottomSheet<void>(
                              elevation: 0,
                              // backgroundColor: Colors.transparent,
                              // barrierColor: Colors.transparent,
                              // shape: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  // height: 150,
                                  decoration: BoxDecoration(
                                    color: notifier.containercoloreproper,
                                    // color: Colors.yellowAccent,
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[

                                        ListView.separated(
                                            separatorBuilder: (context, index) {
                                              return const SizedBox(width: 0,height: 15,);
                                            },
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: data1!.couponlist.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(left: 10,right: 10),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Image(image: NetworkImage('${config().baseUrl}/${data1!.couponlist[index].couponImg}'),height: 60,width: 60,),
                                                    Flexible(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 5,right: 5),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text('${data1?.couponlist[index].couponTitle}',style:  TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: notifier.textColor)),
                                                            const SizedBox(height: 2,),
                                                            Text('${data1?.couponlist[index].couponSubtitle}',style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: notifier.textColor),maxLines: 1,),
                                                            StatefulBuilder(
                                                                builder: (context, setState) {
                                                                  return Row(
                                                                    children: [
                                                                      Expanded(child: buildText(index)),
                                                                      InkWell(
                                                                          onTap: () {
                                                                            setState(() {
                                                                              if(isReademore.contains(index) == true){
                                                                                isReademore.remove(index);
                                                                              }else{
                                                                                isReademore.add(index);
                                                                              }
                                                                            });
                                                                          },
                                                                          child: Icon(Icons.more_horiz,size: 20,color: notifier.textColor))
                                                                    ],
                                                                  );
                                                                }
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                const SizedBox(width: 10,),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Image(image: const AssetImage('assets/clock.png'),height: 15,width: 15,color: notifier.textColor),
                                                                        const SizedBox(width: 5,),
                                                                        Text('Valid untill'.tr,style: TextStyle(fontSize: 10,color: notifier.textColor)),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 19),
                                                                      child: Text('${(data1?.couponlist[index].expireDate.toString().split(" ").first)}',style:  TextStyle(fontSize: 10,color: notifier.textColor)),
                                                                    ),

                                                                  ],
                                                                ),
                                                                const SizedBox(width: 10,),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Image(image: const AssetImage('assets/credit-card.png'),height: 15,width: 15,color: notifier.textColor),
                                                                        const SizedBox(width: 5,),
                                                                        Text('Min Amount'.tr,style: TextStyle(fontSize: 10,color: notifier.textColor)),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 19),
                                                                      child: Text('${widget.currency} ${data1?.couponlist[index].minAmt}',style:  TextStyle(fontSize: 10,color: notifier.textColor)),
                                                                    ),


                                                                  ],
                                                                ),

                                                                const Spacer(),
                                                                widget.bottom < int.parse(data1!.couponlist[index].minAmt) ?  InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(context);
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      SnackBar(content:  Text('Not Apply'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    height : 30,
                                                                    width : 70,
                                                                    decoration: BoxDecoration(
                                                                      color: const Color(0xffD6C1F9),
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    child:  Center(child: Text('Apply'.tr,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                                                                  ),
                                                                ): InkWell(
                                                                  onTap: () {

                                                                    setState(() {
                                                                      coupon = int.parse(data1!.couponlist[index].couponVal);
                                                                      totalPayment -= coupon;
                                                                      print(totalPayment);
                                                                      print(int.parse(data1!.couponlist[index].couponVal));
                                                                    });
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Container(
                                                                    height : 30,
                                                                    width : 70,
                                                                    decoration: BoxDecoration(
                                                                      color: notifier.theamcolorelight,
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    child:  Center(child: Text('Apply'.tr,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                                                  ),
                                                                ) ,
                                                                const SizedBox(width: 10,)
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              );
                                            }),
                                        const SizedBox(height: 20,),
                                      ],
                                    ),
                                  ),
                                );

                                },
                            );




                            
                          }else{
                            setState(() {
                              coupon = 0;
                              totalPayment =  widget.bottom + (widget.bottom * int.parse(taxamount) / 100);
                              print(totalPayment);
                            });
                          }
                        },
                        child: Row(
                          children: [
                            const Image(image: AssetImage('assets/Rectangle_2.png'),height: 40),
                            Expanded(
                              child: ListTile(
                                leading: const Image(image: AssetImage('assets/Group10101.png'),height: 25,width: 25),
                                title: Transform.translate(offset: const Offset(-10, 0),child:  Text('Apply Coupon'.tr,style: TextStyle(fontSize: 15,color: notifier.textColor,fontWeight: FontWeight.bold))),
                                trailing:  Icon(Icons.keyboard_arrow_right,color: notifier.theamcolorelight),
                              ),
                            ),
                          ],
                        ),
                      ),
                      coupon == 0 ? const SizedBox() : Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 15,),
                                Text('Coupon Applied !'.tr,style: TextStyle(color: notifier.textColor,fontWeight: FontWeight.bold,fontSize: 17)),
                                const Spacer(),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        coupon = 0 ;
                                        totalPayment = widget.bottom + (widget.bottom * int.parse(taxamount) / 100);
                                        print(totalPayment);
                                      });
                                    },
                                    child:  Text('Remove'.tr,style: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),)),
                                // SizedBox(width: 15,),
                              ],
                            ),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),







              const SizedBox(height: 15,),
              if(widget.wallet == '0')
                const SizedBox()
              else
                Container(
                // height: 200,
                width: MediaQuery.of(context).size.width,
                decoration:  BoxDecoration(
                  color: notifier.containercoloreproper,
                  // borderRadius: BorderRadius.circular(20),
                ),
                child:  Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Image(image: AssetImage('assets/Rectangle_2.png'),height: 40),
                          Expanded(
                            child: ListTile(
                              leading:  Image(image: const AssetImage('assets/credit-card.png'),height: 25,width: 25,color: notifier.textColor),
                              title: Transform.translate(offset: const Offset(-15, 0),child:  Text('Pay from Wallet'.tr,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notifier.textColor))),
                              trailing: Transform.scale(
                                scale: 0.6,
                                child: CupertinoSwitch(
                                  value: light,
                                  activeColor: notifier.theamcolorelight,
                                  onChanged: (bool value) {
                                    setState(() {
                                      light = value;
                                    });

                                      print("wallet main : $walletMain");
                                      print("totalPayment : $totalPayment");
                                      print("walletValue : $walletValue");
                                      print("totalAmount : $totalAmount");


                                    if(value) {
                                      if (totalPayment > walletMain) {
                                        print("1");
                                        walletValue = walletMain;
                                        totalPayment -= walletValue;
                                        walletMain = 0 ;
                                      }else {
                                        print("2");
                                        walletValue = totalPayment;
                                        totalPayment -= totalPayment;

                                        double good = double.parse(widget.wallet);
                                        print(walletValue);
                                        print(double.parse(widget.wallet));
                                         walletMain = (good - walletValue);
                                      }
                                    }else{
                                      print("3");
                                      // isOnlyWallet = false;
                                      walletValue = 0;
                                      walletMain = double.parse(widget.wallet);
                                      totalPayment = widget.bottom + (widget.bottom * int.parse(taxamount) / 100);
                                      coupon = 0;
                                    }


                                    print("-------------------------------------------------");
                                    print("wallet main : $walletMain");
                                    print("totalPayment : $totalPayment");
                                    print("walletValue : $walletValue");
                                    print("totalAmount : $totalAmount");

                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),


                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            leading: const Image(image: AssetImage('assets/Group (1).png'),color: Color(0xff235DFF),height: 20,width: 20),
                            title: Transform.translate(offset: const Offset(-15, 0),child:  Text('My Wallet'.tr,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: notifier.textColor))),
                            trailing: light?  Text('${widget.currency} ${walletMain.toStringAsFixed(2)}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Color(0xff235DFF))) : Text('${widget.currency} ${widget.wallet}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Color(0xff235DFF))),
                          ),
                        ),


                    ],
                  ),
                ),
              ),


              const SizedBox(height: 15,),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration:  BoxDecoration(
                  color: notifier.containercoloreproper,
                ),
                child:  Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                       Row(
                        children: [
                          const Image(image: AssetImage('assets/Rectangle_2.png'),height: 40),
                          const SizedBox(width: 15,),
                          Text('Price Details'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: notifier.textColor)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        child: Column(
                          children: [
                            const SizedBox(height: 15,),
                            Row(
                              children: [
                                Text('Price'.tr,style: TextStyle(fontSize: 12,color: notifier.textColor)),
                                const Spacer(),
                                Text('${widget.currency} ${widget.bottom.toStringAsFixed(2)}',style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor),),
                              ],
                            ),
                            light ? const SizedBox(height: 15,) : const SizedBox(height: 0,),
                            light ? switchcommoncode(): const SizedBox(),
                            const SizedBox(height: 15,),
                            Row(
                              children: [
                                Text('Tax($taxamount%)',style: TextStyle(fontSize: 12,color: notifier.textColor)),
                                const Spacer(),
                                Text('${widget.currency} ${totallist.toStringAsFixed(2)}',style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor),),
                              ],
                            ),
                            const SizedBox(height: 15,),
                             Row(
                              children: [
                                 Text('Discount'.tr,style: TextStyle(fontSize: 12,color: notifier.textColor)),
                                const Spacer(),
                                // Text('% ${coupon .toString()}',style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.green),),
                                Text('${widget.currency} ${coupon.toStringAsFixed(2)}',style:  const TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontSize: 12),),
                              ],
                            ),
                            const SizedBox(height: 8,),
                             Divider(color: Colors.grey.withOpacity(0.4)),
                            const SizedBox(height: 8,),
                            Row(
                              children: [
                                 Text('Total Price'.tr,style: TextStyle(fontSize: 12,color: notifier.textColor)),
                                const Spacer(),
                                // Text('${widget.currency} ${(totalAmount - coupon ) - walet} ',style: const TextStyle(fontWeight: FontWeight.bold),),
                                Text('${widget.currency} ${totalPayment.toStringAsFixed(2)} ',style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: notifier.textColor),),
                              ],
                            ),
                            const SizedBox(height: 15,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }



  Widget switchcommoncode(){
    return  Row(
      children: [
        Text('Wallet'.tr,style: TextStyle(color: notifier.textColor,fontSize: 12)),
        const Spacer(),
        Text('${widget.currency} ${walletValue.toStringAsFixed(2)}',style:  TextStyle(fontWeight: FontWeight.bold,color: notifier.textColor,fontSize: 12),),
      ],
    );
  }


  Widget buildText (index){

    final maxLines = isReademore.contains(index) ? null : 1;


    return Text('${data1?.couponlist[index].cDesc}',style:  TextStyle(fontSize: 10,color: notifier.textColor),maxLines: maxLines,);

  }





  //Strip code


  final _formKey = GlobalKey<FormState>();
  var numberController = TextEditingController();
  final _paymentCard = PaymentCardCreated();
  var _autoValidateMode = AutovalidateMode.disabled;

  final _card = PaymentCardCreated();


  stripePayment() {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: notifier.background,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Ink(
                    child: Column(
                      children: [
                        SizedBox(height: Get.height / 45),
                        Center(
                          child: Container(
                            height: Get.height / 85,
                            width: Get.width / 5,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.4),
                                borderRadius: const BorderRadius.all(Radius.circular(20))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: Get.height * 0.03),
                              Text("Add Your payment information".tr,
                                  style:  TextStyle(
                                      color: notifier.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 0.5)),
                              SizedBox(height: Get.height * 0.02),
                              Form(
                                key: _formKey,
                                autovalidateMode: _autoValidateMode,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      style:  TextStyle(color: notifier.textColor),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(19),
                                        CardNumberInputFormatter()
                                      ],
                                      controller: numberController,
                                      onSaved: (String? value) {
                                        _paymentCard.number =
                                            CardUtils.getCleanedNumber(value!);

                                        CardTypee cardType =
                                        CardUtils.getCardTypeFrmNumber(
                                            _paymentCard.number.toString());
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      onChanged: (val) {
                                        CardTypee cardType =
                                        CardUtils.getCardTypeFrmNumber(val);
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      validator: CardUtils.validateCardNum,
                                      decoration: InputDecoration(
                                        prefixIcon: SizedBox(
                                          height: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                              horizontal: 6,
                                            ),
                                            child: CardUtils.getCardIcon(_paymentCard.type,),
                                          ),
                                        ),
                                        focusedErrorBorder:  OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4),
                                          ),
                                        ),
                                        errorBorder:  OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4),
                                          ),
                                        ),
                                        enabledBorder:  OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4),
                                          ),
                                        ),
                                        focusedBorder:  OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4),
                                          ),
                                        ),
                                        hintText:
                                        "What number is written on card?".tr,
                                        hintStyle: const TextStyle(color: Colors.grey),
                                        labelStyle: const TextStyle(color: Colors.grey),
                                        labelText: "Number".tr,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 4,
                                          child: TextFormField(
                                            style:  TextStyle(color: notifier.textColor),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(4),
                                            ],
                                            decoration: InputDecoration(
                                                prefixIcon: const SizedBox(
                                                  height: 10,
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 14),
                                                    child: Icon(Icons.credit_card,color: Color(0xff7D2AFF)),
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.withOpacity(0.4),
                                                  ),
                                                ),
                                                errorBorder:  OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.withOpacity(0.4),
                                                  ),
                                                ),
                                                enabledBorder:  OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.withOpacity(0.4),
                                                  ),
                                                ),
                                                focusedBorder:  OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                        Colors.grey.withOpacity(0.4))),
                                                hintText: "Number behind the card".tr,
                                                hintStyle:
                                                const TextStyle(color: Colors.grey),
                                                labelStyle:
                                                const TextStyle(color: Colors.grey),
                                                labelText: 'CVV'),
                                            validator: CardUtils.validateCVV,
                                            keyboardType: TextInputType.number,
                                            onSaved: (value) {
                                              _paymentCard.cvv = int.parse(value!);
                                            },
                                          ),
                                        ),
                                        SizedBox(width: Get.width * 0.03),
                                        Flexible(
                                          flex: 4,
                                          child: TextFormField(
                                            style:  TextStyle(color: notifier.textColor),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(4),
                                              CardMonthInputFormatter()
                                            ],
                                            decoration: InputDecoration(
                                              prefixIcon: const SizedBox(
                                                height: 10,
                                                child: Padding(
                                                  padding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 14),
                                                  child: Icon(Icons.calendar_month,color: Color(0xff7D2AFF)),
                                                ),
                                              ),
                                              errorBorder:  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey.withOpacity(0.4),
                                                ),
                                              ),
                                              focusedErrorBorder:
                                              OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey.withOpacity(0.4),
                                                ),
                                              ),
                                              enabledBorder:  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey.withOpacity(0.4),
                                                ),
                                              ),
                                              focusedBorder:  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey.withOpacity(0.4),
                                                ),
                                              ),
                                              hintText: 'MM/YY',
                                              hintStyle:  const TextStyle(color: Colors.grey),
                                              labelStyle: const TextStyle(color: Colors.grey),
                                              labelText: "Expiry Date".tr,
                                            ),
                                            validator: CardUtils.validateDate,
                                            keyboardType: TextInputType.number,
                                            onSaved: (value) {
                                              List<int> expiryDate =
                                              CardUtils.getExpiryDate(value!);
                                              _paymentCard.month = expiryDate[0];
                                              _paymentCard.year = expiryDate[1];
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: Get.height * 0.055),
                                    Container(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: Get.width,
                                        child: CupertinoButton(
                                          onPressed: () {
                                            _validateInputs();
                                          },
                                          color: const Color(0xff7D2AFF),
                                          child: Text(
                                            "Pay ${widget.currency}$totalPayment",
                                            style:  const TextStyle(fontSize: 17.0,color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Get.height * 0.065),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode =
            AutovalidateMode.always;
      });

      Fluttertoast.showToast(msg: "Please fix the errors in red before submitting.".tr,timeInSecForIosWeb: 4);
    } else {
      var username = userData["name"] ?? "";

      var email = userData["email"] ?? "";
      _paymentCard.name = username;
      _paymentCard.email = email;
      _paymentCard.amount = totalPayment.toString();
      form.save();

      Get.to(() => StripePaymentWeb(paymentCard: _paymentCard))!.then((otid) {
        Get.back();
        if (otid != null) {
          Book_Ticket( uid: widget.uid, bus_id: widget.bus_id,pick_id: widget.pick_id, dropId: widget.dropId, ticketPrice: widget.ticketPrice,trip_date: widget.trip_date,paymentId: "$otid",boardingCity: widget.boardingCity,dropCity: widget.dropCity,busPicktime: widget.busPicktime,busDroptime: widget.busDroptime,Difference_pick_drop: widget.differencePickDrop);
        }
      });
      Fluttertoast.showToast(msg: "Payment card is valid".tr,timeInSecForIosWeb: 4);
    }
  }
}