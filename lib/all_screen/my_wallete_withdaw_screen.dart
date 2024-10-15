// ignore_for_file: unused_import, unnecessary_import, depend_on_referenced_packages, camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print, sort_child_properties_last, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API_MODEL/wallet_report_api_model.dart';
import '../Common_Code/common_button.dart';
import '../Common_Code/homecontroller.dart';
import '../Sub_Screen/faq_scrren.dart';
import '../Sub_Screen/top_up_screen.dart';
import '../agent_payout_controller_screen.dart';
import '../api_model/payout_api_model.dart';
import '../api_model/request_withdraw_api_model.dart';
import '../config/config.dart';
import '../config/light_and_dark.dart';
import 'package:http/http.dart' as http;

import 'bottom_navigation_bar_screen.dart';
import 'my_wallet_screen.dart';
List<String> payType = ["UPI", "BANK Transfer", "Paypal"];

class my_wallete_agent extends StatefulWidget {
  const my_wallete_agent({super.key});

  @override
  State<my_wallete_agent> createState() => _my_wallete_agentState();
}

class _my_wallete_agentState extends State<my_wallete_agent> {

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
          // isloading = false;
        });
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }







  // Wallet_Report Api

  RequestWithdraw? data1;

  Future request_withdraw(String uid) async {

    Map body = {
      'agent_id' : uid,
      "amt": payOutController.amount.text,
      "r_type": selectType,
      "acc_number": payOutController.accountNumber.text,
      "bank_name": payOutController.bankName.text,
      "acc_name": payOutController.accountHolderName.text,
      "ifsc_code": payOutController.ifscCode.text,
      "upi_id": payOutController.upi.text,
      "paypal_id": payOutController.emailId.text,
    };

    print("+++ $body");

    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/request_withdraw.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){
        setState(() {
          data1 = requestWithdrawFromJson(response.body);
          isloading = false;
          print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${data!.wallet}');
          Walletreport(userData['id']);
          payout_api(userData['id']);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data1!.responseMsg),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
          );
          // isloading = false;
        });
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }




  // payout_list Api

  PayoutApi? data2;

  Future payout_api(String uid) async {

    Map body = {
      'agent_id' : uid,
    };

    print("+++ $body");

    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/payout_list.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){
        setState(() {
          data2 = payoutApiFromJson(response.body);
          isloading = false;
          print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${data!.wallet}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data1!.responseMsg),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
          );
          // isloading = false;
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
      searchbus = jsonDecode(_prefs.getString('currency')!);
      agentwithdrawlimit = jsonDecode(_prefs.getString('withdrawlimit')!);
      Walletreport(userData['id']);
      payout_api(userData['id']);
      print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${userData["mobile"]}');
      print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+$searchbus');
    });
  }

  HomeController homeController = Get.put(HomeController());
  @override
  void initState() {
    getlocledata();
    super.initState();
  }

  ColorNotifier notifier = ColorNotifier();

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
                child:  Padding(
                  padding: const EdgeInsets.only(top: 55),
                  child: Padding(
                    padding:  const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () {
                              homeController.setselectpage(2);
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                              Get.offAll(const Bottom_Navigation());
                            },
                            child: const Icon(Icons.arrow_back,color: Colors.white)),
                        const SizedBox(width: 10,),
                        const Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text('My earning',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            homeController.setselectpage(2);
                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>   const My_Wallet(),));
                            Get.offAll(const Bottom_Navigation());
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Text('My Wallet',style: TextStyle(color: Colors.white,),),
                                SizedBox(width: 8,),
                                Image(image: AssetImage('assets/question-circle.png'),height: 20,width: 20,color: Colors.white),
                              ],
                            ),
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
                        title: Transform.translate(offset: const Offset(-10, 0),child: const Text('TOTAL EARNING BALANCE',style: TextStyle(color: Colors.grey,fontSize: 14))),
                        subtitle: Transform.translate(
                          offset: const Offset(-10, 0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('$searchbus ${data!.agentEarning}',style:  TextStyle(color: notifier.textColor,fontWeight: FontWeight.bold,fontSize: 20),),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 20,right: 20),
                      //   child: Container(
                      //     height: 35,
                      //     width: Get.width,
                      //     decoration: BoxDecoration(
                      //       color: notifier.theamcolorelight,
                      //       borderRadius: BorderRadius.circular(20)
                      //     ),
                      //     child: const Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Image(image: AssetImage('assets/Upload.png'),color: Colors.white,height: 20,width: 20,),
                      //         SizedBox(width: 10,),
                      //         Text('Top Up',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        child: CommonButtonwallete(containcolore: notifier.theamcolorelight,context: context, onPressed1: (){
                          // Get.to(Top_up(wallet: data!.wallet,searchbus: searchbus))!.then((value) {
                          //   print("+1222222222222211111111111122224185410241514  $value");
                          //   Walletreport(userData['id']);
                          // });
                          data!.agentEarning == '0' ?   Fluttertoast.showToast(
                            msg: "No earnings, so you can't withdraw; limit is \$10.",
                          ) : requestSheet();
                        },img: 'assets/Upload.png',txt1: 'Withdraw'),
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
                data2?.payoutlist.isEmpty ?? true ? const SizedBox() : Row(
                  children: [
                    Text('Transaction History'.tr,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: notifier.textColor),),
                    const Spacer(),
                    // Text('View All',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color(0xff7D2AFF)),),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(width : 0,);
                },
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: data2?.payoutlist.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Get.bottomSheet(
                          isScrollControlled: true,
                          Padding(
                            padding: const EdgeInsets.only(top: 150),
                            child: Container(
                              decoration:  BoxDecoration(
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
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Text('Payout id',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        Text('${data2?.payoutlist[index].payoutId}',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Text('Amount',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        Text('$searchbus${data2?.payoutlist[index].amt}',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Text('Pay by',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        Text('${data2?.payoutlist[index].rType}',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                        data2?.payoutlist[index].rType == "BANK Transfer" ?const SizedBox():Text('(${data2?.payoutlist[index].rType == "UPI" ? data2?.payoutlist[index].upiId : data2?.payoutlist[index].paypalId})',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    data2?.payoutlist[index].rType == "BANK Transfer" ?   Column(
                                      children: [
                                        const SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Text('Account Number',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                            const Spacer(),
                                            Text('${data2?.payoutlist[index].accNumber}',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Text('Bank Name',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                            const Spacer(),
                                            Text('${data2?.payoutlist[index].bankName}',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Text('Account Name',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                            const Spacer(),
                                            Text('${data2?.payoutlist[index].accName}',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ): const SizedBox(),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Text('Request Date',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        Text('${data2?.payoutlist[index].rDate}',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    // const SizedBox(height: 10,),
                                    data2!.payoutlist[index].status == 'completed' ?  Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Text('Proof',style: TextStyle(color: notifier.textColor,fontSize: 15,fontWeight: FontWeight.bold)),
                                        ),
                                        const Spacer(),
                                        Image(image: NetworkImage('${config().baseUrl}/${data2?.payoutlist[index].proof}'),height: 80,width: 80,),
                                      ],
                                    ) : const SizedBox(),
                                    const SizedBox(height: 20,),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                    child: Transform.translate(
                      offset: const Offset(0, -25),
                      child: ListTile(
                        leading: data2!.payoutlist[index].status == 'completed' ? const Image(image: AssetImage('assets/walletecomplete.png'),height: 40):const Image(image: AssetImage('assets/walletpending.png'),height: 40),
                        title: Transform.translate(offset: const Offset(-6, 0),child: Text(capitalize(data2!.payoutlist[index].status),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: notifier.textColor))),
                        subtitle: Transform.translate(offset: const Offset(-6, 0),child: Text(data2!.payoutlist[index].rDate.toString().split(" ").first,style: const TextStyle(fontSize: 14,color: Colors.grey))),
                        trailing: Transform.translate(
                          offset: const Offset(15, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('$searchbus ${data2!.payoutlist[index].amt}',style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.green)),
                              Icon(Icons.keyboard_arrow_right,color: notifier.textColor),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Future<void> requestSheet() {
    return Get.bottomSheet(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Form(
          key: _formKey,
          child: Container(
            // height: Get.size.height * 0.6,
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
                    "Minimum amount: $searchbus$agentwithdrawlimit".tr,
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
                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
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
                        controller: payOutController.emailId,
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
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: InkWell(
                  //         onTap: () {
                  //           payOutController.emptyDetails();
                  //           Get.back();
                  //         },
                  //         child: Container(
                  //           height: 50,
                  //           margin: const EdgeInsets.all(15),
                  //           alignment: Alignment.center,
                  //           child: Text(
                  //             "Cancel".tr,
                  //             style: const TextStyle(
                  //               color: Colors.blue,
                  //               fontSize: 16,
                  //             ),
                  //           ),
                  //           decoration: BoxDecoration(
                  //             color: const Color(0xFFeef4ff),
                  //             borderRadius: BorderRadius.circular(45),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: InkWell(
                  //         onTap: () {
                  //           if (_formKey.currentState?.validate() ?? false) {
                  //             if (selectType != null) {
                  //               // payOutController.requestWithdraweApi(
                  //               //   rType: selectType,
                  //               // );
                  //             } else {
                  //               // showToastMessage("Please Select Type".tr);
                  //             }
                  //           }
                  //         },
                  //         child: Container(
                  //           height: 50,
                  //           margin: const EdgeInsets.all(15),
                  //           alignment: Alignment.center,
                  //           child: Text(
                  //             "Proceed".tr,
                  //             style: TextStyle(
                  //               color: notifier.textColor,
                  //               fontSize: 16,
                  //             ),
                  //           ),
                  //           decoration: BoxDecoration(
                  //             color: Colors.blue,
                  //             borderRadius: BorderRadius.circular(45),
                  //           ),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(fixedSize: const WidgetStatePropertyAll(Size(120, 40)),elevation: const WidgetStatePropertyAll(0),shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),backgroundColor: const WidgetStatePropertyAll(Colors.white)),
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'.tr,style: const TextStyle(color: Colors.black)),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(fixedSize: const WidgetStatePropertyAll(Size(120, 40)),elevation: const WidgetStatePropertyAll(0),shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),backgroundColor:  WidgetStatePropertyAll(notifier.theamcolorelight)),
                            onPressed: () => {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (selectType != null) {
                                  request_withdraw(userData['id']),
                                  Get.back(),
                                } else {
                                  // showToastMessage("Please Select Type".tr);
                                  Fluttertoast.showToast(msg: 'Please Select Type',timeInSecForIosWeb: 4),
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
              color: notifier.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
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
            borderSide:  BorderSide(color: Colors.grey.withOpacity(0.4)),
          ),
          border: OutlineInputBorder(
            borderSide:  BorderSide(color: Colors.grey.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
  }



}
