// ignore_for_file: unnecessary_import, depend_on_referenced_packages, camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API_MODEL/payment_getway_api_model.dart';
import '../API_MODEL/wallet_report_api_model.dart';
import '../API_MODEL/wallet_update_api_model.dart';
import '../Common_Code/common_button.dart';
import 'package:http/http.dart' as http;

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

class Top_up extends StatefulWidget {
  final String wallet;
  final String searchbus;

  const Top_up({super.key, required this.wallet, required this.searchbus});

  @override
  State<Top_up> createState() => _Top_upState();
}

class _Top_upState extends State<Top_up> {


  WalletReport? data;
  var daat;


  // Wallet_Report Api

  Future Walletreport(String uid) async {

    Map body = {
      'uid' : uid,
    };

    print("+++ $body");

    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/wallet_report.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){
        setState(() {
          data = walletReportFromJson(response.body);
          isloading = false;
          print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${data!.wallet}');
          // isloading = false;
        });
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }








  TextEditingController walletController = TextEditingController();


  var userData;
  var searchbus;


  getlocledata() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      userData  = jsonDecode(_prefs.getString("loginData")!);
      isloading = false;
      // searchbus = jsonDecode(_prefs.getString('bussearch')!);
      print('+-+-+-+-+-+-+-+-+-+-hhhhhhhhhh+-+-+-+-+-+-+-+-+-+-+-+-+${userData["name"]}');
      // print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${searchbus["bussearch"]}');
    });
  }

  @override
  void initState() {
    setState(() {
      isloading = false;
    });
    Payment_Getway();
    getlocledata();
    walletController.text  = "100".tr;


    razorPayClass.initiateRazorPay(handlePaymentSuccess: handlePaymentSuccess, handlePaymentError: handlePaymentError, handleExternalWallet: handleExternalWallet);
    super.initState();
  }


  @override
  void dispose() {
    razorPayClass.desposRazorPay();
    super.dispose();
  }

  // Razorpay Code

  // Razorpay? _razorpay;
  RazorPayClass  razorPayClass = RazorPayClass();

  void handlePaymentSuccess(PaymentSuccessResponse response){
    WalletUpdateApi(userData['id']);

    Fluttertoast.showToast(msg: 'SUCCESS PAYMENT : ${response.paymentId}',timeInSecForIosWeb: 4);
  }
  void handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(msg: 'ERROR HERE: ${response.code} - ${response.message}',timeInSecForIosWeb: 4);
  }
  void handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(msg: 'EXTERNAL_WALLET IS: ${response.walletName}',timeInSecForIosWeb: 4);
  }

  bool isloading = true;


  //Get Api Calling  Payment Getway List Api

  late PaymentGetway from12;


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
  int payment = 0;
  String selectedOption = '';
  String selectBoring = "";



  // Wallet_Update_Api

  WalletUpdate? wupdate;

  Future WalletUpdateApi(String uid) async {

    Map body = {
      'uid' : uid,
      'wallet' : walletController.text,
    };

    print("+++ $body");
    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/wallet_up.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){

        setState(() {
          wupdate = walletUpdateFromJson(response.body);
          // Get.close(2);
          Walletreport(uid);
        });

        showModalBottomSheet(
          isDismissible: false,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
          ),
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 330,
              decoration:  BoxDecoration(
                  color: notifier.backgroundgray,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  const CircleAvatar(radius: 35,backgroundColor: Color(0xff7D2AFF),child: Center(child: Icon(Icons.check,color: Colors.white,)),),
                  const SizedBox(height: 20,),
                  Text('Top up ${widget.searchbus}${walletController.text}.00',style:  TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: notifier.textColor),),
                  const SizedBox(height: 5,),
                  Text('Successfuly'.tr,style:  TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: notifier.textColor),),
                  const SizedBox(height: 28,),
                  Text('${widget.searchbus}${walletController.text} has been added to your wallet',style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.grey),),
                  const SizedBox(height: 28,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: const ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(0, 50)),backgroundColor: WidgetStatePropertyAll(Colors.white),side: WidgetStatePropertyAll(BorderSide(color: Colors.black)),shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))))),
                            onPressed: () {
                              Get.close(0);
                              Get.back(result: "12456789");
                            },
                            child:  Text('Done For Now'.tr,style:  const TextStyle(color: Colors.black)),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: ElevatedButton(
                            style: const ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(0, 50)),backgroundColor: WidgetStatePropertyAll(Colors.black),side: WidgetStatePropertyAll(BorderSide(color: Colors.black)),shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))))),
                            onPressed: () {
                              Get.close(0);
                              Get.back(result: "12456789");
                            },
                            child:  Text('Another Top Up'.tr,style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }



  ColorNotifier notifier = ColorNotifier();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.backgroundgray,
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
          child: CommonButton(containcolore: notifier.theamcolorelight,txt2: 'Continue'.tr,context: context,onPressed1: () {



            showModalBottomSheet(
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
                          backgroundColor: Colors.transparent,
                          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                          floatingActionButton:  Padding(
                            padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                            child: Container(
                                height: 42,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: notifier.theamcolorelight,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ElevatedButton(
                                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(notifier.theamcolorelight),shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))),
                                  onPressed:  () {

                                    if(payment == 0){
                                      razorPayClass.openCheckout(key: from12.paymentdata[0].attributes, amount: '${double.parse(walletController.text)}', number: '${userData['mobile']}', name: '${userData['email']}');
                                      Get.back();
                                    }
                                    if(payment == 1){
                                      List ids = from12.paymentdata[1].attributes.toString().split(",");
                                      print('++++++++++ids:------$ids');
                                      paypalPayment(
                                        context: context,
                                        function: (e){
                                          WalletUpdateApi(userData['id']);
                                        },
                                        amt: walletController.text,
                                        clientId: ids[0],
                                        secretKey: ids[1],
                                      );
                                    }
                                    if(payment == 2){
                                      Get.back();
                                      stripePayment();
                                    }
                                    if(payment == 3){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Not Valid'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                      );
                                      // Fluttertoast.showToast(msg: 'Not Valid'.tr,timeInSecForIosWeb: 4);
                                    }
                                    if(payment == 4){
                                      Get.to(() => Flutterwave(
                                          totalAmount: walletController.text,
                                          email: userData['email']
                                      ))!
                                          .then((otid) {
                                        if (otid != null) {
                                          WalletUpdateApi(userData['id']);
                                          Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                        } else {
                                          Get.back();
                                        }
                                      });
                                    }
                                    if(payment == 5){
                                      Get.to(() => PayTmPayment(
                                          totalAmount: walletController.text,
                                          uid: userData['id']
                                      ))!
                                          .then((otid) {
                                        if (otid != null) {
                                          WalletUpdateApi(userData['id']);
                                          Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                        } else {
                                          Get.back();
                                        }
                                      });
                                    }
                                    if(payment == 6){
                                      Get.to(SenangPay(
                                          email: userData['email'],
                                          totalAmount: walletController.text,
                                          name: userData['name'],
                                          phon: userData['mobile']))!
                                          .then((otid) {
                                        if (otid != null) {
                                          WalletUpdateApi(userData['id']);
                                        } else {
                                          Get.back();
                                        }
                                      });
                                    }
                                    if(payment == 7 || payment == 8){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Not Valid'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                      );
                                    }
                                    else{}

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
                          body:  Container(
                            height: 450,
                            decoration:  BoxDecoration(
                                color: notifier.containercoloreproper,
                                // color: Colors.red,
                                // border: Border.all(color: Colors.white),
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[

                                  const SizedBox(height: 10,),
                                  Text('Payment Getway Method'.tr,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: notifier.textColor)),
                                  const SizedBox(height: 10,),
                                  Expanded(
                                    child: ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(width:0,);
                                        },
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: from12.paymentdata.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                payment = index;
                                              });
                                            },
                                            child: Container(
                                              height: 90,
                                              margin: const EdgeInsets.only(left: 10,right: 10,top: 6,bottom: 6),
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                // color: Colors.yellowAccent,
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


          }),
        ),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xff2C2C2C),
        elevation: 0,
        title:  Padding(
          padding: const EdgeInsets.only(left: 10),
          child:  Text('Top Up'.tr,style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
        ),
      ),
      body:  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: isloading ?  Center(child: CircularProgressIndicator(color: notifier.theamcolorelight),) :  Column(
           crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10,),
            Stack(
              children: [
                const Image(image: AssetImage('assets/Visa_card.png')),
                Padding(
                  padding: const EdgeInsets.only(top: 40,left: 30,right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 65,),
                      Text('Your balance'.tr,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                      const SizedBox(height: 30,),
                      Row(
                        children: [
                          Text('${widget.searchbus} ${widget.wallet}',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(top: 0,right: 20),
                            child: Container(
                              height: 35,
                              width: 90,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                              ),
                              child:  Row(
                                children: [
                                  const Spacer(),
                                  const Image(image: AssetImage('assets/Top_up.png'),height: 15,width: 15,),
                                  const SizedBox(width: 5,),
                                  Text('Top up'.tr,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Center(child: Text('Top up Amount'.tr,style:  TextStyle(fontSize: 18,color: notifier.textColor,fontWeight: FontWeight.bold),)),
            const SizedBox(height: 20,),





            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: walletController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                style:  TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: notifier.textColor,
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  prefixIcon: SizedBox(
                    height: 20,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Image.asset(
                        'assets/a1.png',
                        width: 20,
                        color: notifier.textColor,
                      ),
                    ),
                  ),
                  // hintText: "100".tr,
                  hintStyle:  TextStyle(
                    color: notifier.textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        walletController.text  = "100".tr;
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Text(
                          "100".tr,
                          style:  TextStyle(
                            color:  notifier.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        walletController.text  =  "300".tr;
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Text(
                          "300".tr,
                          style:  TextStyle(
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        walletController.text  = "500".tr;
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Text(
                          "500".tr,
                          style:  TextStyle(
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        walletController.text  = "1000".tr;
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Text(
                          "1000".tr,
                          style:  TextStyle(
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        walletController.text  =  "1100".tr;
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Text(
                          "1100".tr,
                          style:  TextStyle(
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        walletController.text  = "1300".tr;
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Text(
                          "1300".tr,
                          style:  TextStyle(
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        walletController.text  = "1500".tr;
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Text(
                          "1500".tr,
                          style:  TextStyle(
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        walletController.text  =  "1700".tr;
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Text(
                          "1700".tr,
                          style:  TextStyle(
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        walletController.text  = "2000".tr;
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Text(
                          "2000".tr,
                          style:  TextStyle(
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }



  // Strip code

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
                                              FilteringTextInputFormatter.digitsOnly,
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
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
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
                                            "Pay ${widget.searchbus}${walletController.text}",
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
            AutovalidateMode.always; // Start validating on every change.
      });

      Fluttertoast.showToast(msg: "Please fix the errors in red before submitting.".tr,timeInSecForIosWeb: 4);
    } else {
      var username = userData["name"] ?? "";

      var email = userData["email"] ?? "";
      _paymentCard.name = username;
      _paymentCard.email = email;
      _paymentCard.amount = walletController.text;
      form.save();

      Get.to(() => StripePaymentWeb(paymentCard: _paymentCard))!.then((otid) {
        Get.back();
        if (otid != null) {
          WalletUpdateApi(userData['id']);
        }
      });
      Fluttertoast.showToast(msg: "Payment card is valid".tr,timeInSecForIosWeb: 4);
    }
  }
}
