// ignore_for_file: avoid_print, depend_on_referenced_packages, camel_case_types, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, sort_child_properties_last, unnecessary_const, use_build_context_synchronously, unnecessary_import

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
import '../API_MODEL/payment_getway_api_model.dart';
import '../API_MODEL/wallet_report_api_model.dart';
import '../API_MODEL/wallet_update_api_model.dart';
import '../Payment_Getway/flutterwave.dart';
import '../Payment_Getway/inputformater.dart';
import '../Payment_Getway/paymentcard.dart';
import '../Payment_Getway/paypal.dart';
import '../Payment_Getway/paytm.dart';
import '../Payment_Getway/razorpay.dart';
import '../Payment_Getway/senangpay.dart';
import '../Payment_Getway/stripeweb.dart';
import '../Sub_Screen/faq_scrren.dart';
import '../common_code/common_button.dart';
import '../config/config.dart';
import 'package:http/http.dart' as http;
import '../config/light_and_dark.dart';
import '../payment_getway/cinetpay.dart';
import 'my_wallete_withdaw_screen.dart';
import 'package:zigzag/agent_payout_controller_screen.dart';
List<String> payType = ["UPI", "BANK Transfer", "Paypal"];
class My_Wallet extends StatefulWidget {

  const My_Wallet({super.key});

  @override
  State<My_Wallet> createState() => _My_WalletState();
}

class _My_WalletState extends State<My_Wallet> {
  String referenceId = "";
  WalletReport? data;
  var daat;
  bool isloading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectType;

  PayOutController payOutController = Get.put(PayOutController());

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
        });
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }

  var userData;
  var searchbus;
  var agentwithdrawlimit;

  getlocledata() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      userData  = jsonDecode(_prefs.getString("loginData")!);
      searchbus = jsonDecode(_prefs.getString('currency') ?? '"USD"'); // Default to "USD"
      agentwithdrawlimit = jsonDecode(_prefs.getString('withdrawlimit') ?? "0");
      Walletreport(userData['id']);
      Payment_Getway();
      print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${userData["mobile"]}');
      print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+$searchbus');
    });
  }

  @override
  void initState() {


    getlocledata();
    // walletController.text  = "100".tr;


    razorPayClass.initiateRazorPay(handlePaymentSuccess: handlePaymentSuccess, handlePaymentError: handlePaymentError, handleExternalWallet: handleExternalWallet);
    super.initState();
  }

  TextEditingController walletController = TextEditingController();

  ColorNotifier notifier = ColorNotifier();

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
                  Text('Top up $searchbus${walletController.text}.00',style:  TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: notifier.textColor),),
                  const SizedBox(height: 5,),
                  Text('Successfuly'.tr,style:  TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: notifier.textColor),),
                  const SizedBox(height: 28,),
                  Text('$searchbus${walletController.text} has been added to your wallet',style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.grey),),
                  const SizedBox(height: 28,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: const ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(0, 50)),backgroundColor: MaterialStatePropertyAll(Colors.white),side: MaterialStatePropertyAll(BorderSide(color: Colors.black)),shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))))),
                            onPressed: () {
                              // Get.close(0);
                              Get.back();
                            },
                            child:  Text('Done For Now'.tr,style:  const TextStyle(color: Colors.black)),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: ElevatedButton(
                            style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(0, 50)),backgroundColor: MaterialStatePropertyAll(Colors.black),side: MaterialStatePropertyAll(BorderSide(color: Colors.black)),shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))))),
                            onPressed: () {
                              // Get.close(0);
                              Get.back();
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

  // Razorpay Code

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



  @override
  void dispose() {
    razorPayClass.desposRazorPay();
    super.dispose();
  }
  int payment = -1;
  String selectedOption = '';
  String selectBoring = "";



  //Get Api Calling  Payment Getway List Api

  late PaymentGetway from12;


  Future Payment_Getway() async {
    var response1 = await http.get(Uri.parse('${config().baseUrl}/api/paymentgateway.php'),);
    if (response1.statusCode == 200) {
      var jsonData = json.decode(response1.body);
      print(jsonData["paymentdata"]);
      setState(() {
        from12 = paymentGetwayFromJson(response1.body);
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.background,

      body: isloading ?  Center(child: CircularProgressIndicator(color: notifier.theamcolorelight),) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 190,
                color: notifier.theamcolorelight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 55),
                  child: Padding(
                    padding:  const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Wallet',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                        const Spacer(),
                        userData['user_type']=='AGENT' ?  InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>   const my_wallete_agent(),));
                          },
                          child:  const Row(
                            children: [
                              const Text('My earning',style: TextStyle(color: Colors.white,),),
                              SizedBox(width: 8,),
                              Icon( CupertinoIcons.question_circle)
                              // Image(image: AssetImage('assets/a1.png'),height: 20,width: 20,color: Colors.white),
                            ],
                          ),
                        ) : InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>   const Faq_Screeen(),));
                          },
                          child: const Row(
                            children: [
                              Text('FAQ',style: TextStyle(color: Colors.white,),),
                              SizedBox(width: 8,),
                              Icon( CupertinoIcons.question_circle)
                              //Image(image: AssetImage('assets/assets/a1.png'),height: 20,width: 20,color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100,left: 20,right: 20),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: notifier.containercoloreproper,
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading:  ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                              maxWidth: 60,
                              maxHeight: 60,
                            ),
                            child: Lottie.asset('assets/lottie/wallet.json')),
                        title: Transform.translate(offset: const Offset(-10, 0),child: Text('TOTAL WALLET BALANCE'.tr,style: TextStyle(color: Colors.grey,fontSize: 14))),
                        subtitle:  Transform.translate(
                          offset: const Offset(-10, 0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('$searchbus ${data?.wallet}',style:  TextStyle(color: notifier.textColor,fontWeight: FontWeight.bold,fontSize: 20),),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        child: CommonButtonwallete(containcolore: notifier.theamcolorelight,context: context, onPressed1: (){

                          Get.bottomSheet(
                              isScrollControlled: true,
                              Padding(
                                padding: const EdgeInsets.only(top: 150),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: notifier.backgroundgray,
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                                  ),
                                  child:  Padding(
                                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 6,right: 6),
                                          child: Text('Add Wallet Amount',style: TextStyle(color: notifier.theamcolorelight,fontSize: 15,fontWeight: FontWeight.bold)),
                                        ),
                                        const SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: SizedBox(
                                            height: 45,
                                            child: TextFormField(
                                              controller: walletController,
                                              cursorColor: Colors.black,
                                              keyboardType: TextInputType.number,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: notifier.textColor,
                                              ),
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.only(top: 15),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.withOpacity(0.4),
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.withOpacity(0.4),
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.withOpacity(0.4),
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
                                                hintText: "Enter Amount".tr,
                                                hintStyle:  const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        const Padding(
                                          padding: const EdgeInsets.only(left: 6,right: 6),
                                          child: Text('Select Payment Method',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),
                                        const SizedBox(height: 0,),
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
                                                    if(from12.paymentdata[payment].title == "Razorpay"){
                                                      razorPayClass.openCheckout(key: from12.paymentdata[0].attributes, amount: '${double.parse(walletController.text)}', number: '${userData['mobile']}', name: '${userData['email']}');
                                                      Get.back();
                                                    }
                                                    else if(from12.paymentdata[payment].title == "Paypal"){
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
                                                    else if(from12.paymentdata[payment].title == "Stripe"){
                                                      Get.back();
                                                      stripePayment();
                                                    }
                                                    else if(from12.paymentdata[payment].title == "FlutterWave"){
                                                      Get.to(() => Flutterwave(
                                                          totalAmount: walletController.text,
                                                          email: userData['email']
                                                      ))!
                                                          .then((otid) {
                                                        Get.back();
                                                        if (otid != null) {
                                                          WalletUpdateApi(userData['id']);
                                                          Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                                        } else {
                                                          Get.back();
                                                        }
                                                      });
                                                    }
                                                    else if(from12.paymentdata[payment].title == "Paytm"){
                                                      Get.to(() => PayTmPayment(
                                                          totalAmount: walletController.text,
                                                          uid: userData['id']
                                                      ))!
                                                          .then((otid) {
                                                        Get.back();
                                                        if (otid != null) {
                                                          WalletUpdateApi(userData['id']);
                                                          Fluttertoast.showToast(msg: 'Payment Successfully',timeInSecForIosWeb: 4);
                                                        } else{
                                                          Get.back();
                                                        }
                                                      });
                                                    }
                                                    else if(from12.paymentdata[payment].title == "SenangPay"){
                                                      Get.to(SenangPay(
                                                          email: userData['email'],
                                                          totalAmount: walletController.text,
                                                          name: userData['name'],
                                                          phon: userData['mobile']))!
                                                          .then((otid) {
                                                        Get.back();
                                                        if (otid != null) {
                                                          WalletUpdateApi(userData['id']);
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
                                                            'amount': walletController.text,
                                                            'currency': 'XOF',
                                                            'channels': 'ALL',
                                                            'description': 'Payment test',
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
                                                          WalletUpdateApi(userData['id']);
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
                                                          fillColor:  MaterialStatePropertyAll<Color?>(notifier.theamcolorelight),
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
                              ));


                        },img: 'assets/Top_up.png',txt1: 'Top Up'),
                      ),
                      const SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15,),

          Padding(
            padding: const EdgeInsets.only(left: 13,right: 13),
            child: Column(
              children: [
                data?.walletitem.isEmpty ?? true ? const SizedBox() : Row(
                  children: [
                    Text('Transaction History'.tr,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: notifier.textColor),),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          // const SizedBox(height: 10,),
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(width : 0,);
                },
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: data?.walletitem.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Transform.translate(
                    offset: const Offset(0, -25),
                    child: ListTile(
                      leading: data!.walletitem[index].status == 'Debit' ? const Image(image: AssetImage('assets/Debit.png'),height: 40):const Image(image: AssetImage('assets/Creadit.png'),height: 40),
                      title: Transform.translate(offset: const Offset(-6, 0),child: Text(data!.walletitem[index].message,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: notifier.textColor))),
                      subtitle: Transform.translate(offset: const Offset(-6, 0),child: Text(data!.walletitem[index].status,style: const TextStyle(fontSize: 14,color: Colors.grey))),
                      trailing: Text('${data!.walletitem[index].status == 'Debit' ? '-' : "+"} $searchbus${data!.walletitem[index].amt}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:  data!.walletitem[index].status == "Debit"  ? Colors.red : Colors.green)),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }



  Future<void> requestSheet() {
    return Get.bottomSheet(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Form(
          key: _formKey,
          child: Container(
            width: Get.size.width,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Payout Request".tr,
                    style: TextStyle(
                      color: notifier.textColor,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Minimum amount:".tr,
                    style: TextStyle(
                      color: notifier.textColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  textfield(
                    controller: payOutController.amount,
                    labelText: "Amount".tr,
                    textInputType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Amount'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Select Type".tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: notifier.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 50,
                    width: Get.size.width,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: DropdownButton(
                      dropdownColor: notifier.backgroundgray,
                      hint: Text(
                        "Select Type".tr,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      value: selectType,
                      icon: Image.asset(
                        'assets/inbox-upload.png',
                        height: 20,
                        width: 20,
                        color: notifier.textColor,
                      ),
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      items:
                      payType.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectType = value ?? "";
                        });
                      },
                    ),
                    decoration: BoxDecoration(
                      // color: notifier.textColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                  ),
                  selectType == "UPI"
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "UPI".tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      textfield(
                        controller: payOutController.upi,
                        labelText: "UPI".tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter UPI'.tr;
                          }
                          return null;
                        },
                      )
                    ],
                  )
                      : selectType == "BANK Transfer"
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Account Number".tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      textfield(
                        controller: payOutController.accountNumber,
                        labelText: "Account Number".tr,
                        textInputType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Account Number'.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Bank Name".tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      textfield(
                        controller: payOutController.bankName,
                        labelText: "Bank Name".tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Bank Name'.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Account Holder Name".tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      textfield(
                        controller:
                        payOutController.accountHolderName,
                        labelText: "Account Holder Name".tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Account Holder Name'
                                .tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "IFSC Code".tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      textfield(
                        controller: payOutController.ifscCode,
                        labelText: "IFSC Code".tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter IFSC Code'.tr;
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                      : selectType == "Paypal"
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Email ID".tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      textfield(
                        controller: payOutController.ifscCode,
                        labelText: "Email Id".tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Paypal id'.tr;
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                      : Container(),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(fixedSize: const MaterialStatePropertyAll(Size(120, 40)),elevation: const MaterialStatePropertyAll(0),shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),backgroundColor: const MaterialStatePropertyAll(Colors.white)),
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'.tr,style: const TextStyle(color: Colors.black)),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(fixedSize: const MaterialStatePropertyAll(Size(120, 40)),elevation: const MaterialStatePropertyAll(0),shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),backgroundColor:  MaterialStatePropertyAll<Color?>(notifier.theamcolorelight)),
                            onPressed: () => {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (selectType != null) {
                                } else {
                                }
                              }
                            },
                            child: Text('Proceed'.tr,style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: notifier.backgroundgray,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
          ),
        );
      }),
    );
  }


  textfield({String? type, labelText, prefixtext, suffix, Color? labelcolor, prefixcolor, floatingLabelColor, focusedBorderColor, TextDecoration? decoration, bool? readOnly, double? Width, int? max, TextEditingController? controller, TextInputType? textInputType, Function(String)? onChanged, String? Function(String?)? validator, Height}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: notifier.textColor,
        keyboardType: textInputType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLength: max,
        readOnly: readOnly ?? false,

        style: TextStyle(
            color: notifier.textColor,
            fontSize: 18),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
          hintText: labelText,
          hintStyle: const TextStyle(
              color: Colors.grey, fontFamily: "Gilroy Medium", fontSize: 16),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff7D2AFF)),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
  }


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
                                            "Pay $searchbus${walletController.text}",
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
  void onCancel() {
    debugPrint('Cancelled');
  }


}
