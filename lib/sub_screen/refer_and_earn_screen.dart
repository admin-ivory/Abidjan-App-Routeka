// import 'package:flutter/material.dart';
//
// class Refer_And_Earn extends StatefulWidget {
//   const Refer_And_Earn({super.key});
//
//   @override
//   State<Refer_And_Earn> createState() => _Refer_And_EarnState();
// }
//
// class _Refer_And_EarnState extends State<Refer_And_Earn> {
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xff2C2C2C),
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: Center(child: Text('My Tickets',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold))),
//       ),
//     );
//   }
// }




// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_interpolation_to_compose_strings, avoid_print, unnecessary_new, file_names, depend_on_referenced_packages, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../API_MODEL/refer_and_earn_api_model.dart';
import '../config/config.dart';
import '../config/light_and_dark.dart';

class ReferFriendScreen extends StatefulWidget {
  const ReferFriendScreen({super.key});

  @override
  State<ReferFriendScreen> createState() => _ReferFriendScreenState();
}

class _ReferFriendScreenState extends State<ReferFriendScreen> {
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;

  @override
  void initState() {
    super.initState();
    getPackage();
    getlocledata();
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }


  var userData;
  var searchbus;
  getlocledata() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      userData  = jsonDecode(_prefs.getString("loginData")!);
      searchbus = jsonDecode(_prefs.getString('currency')!);

      ReferandEarn(userData["id"]);
      print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${userData["mobile"]}');
    });
  }





  late Referearn data;
  bool isloading = true;


  //Refer and earn api


  Future ReferandEarn(String uid) async {

    Map body = {
      'uid' : uid,
    };

    print("+++--++123456789+++--++ $body");

    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/referdata.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){
        setState(() {
          data = referearnFromJson(response.body);
        });
        setState(() {
          isloading = false;
        });
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
      appBar: AppBar(
        backgroundColor: notifier.appbarcolore,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('Refer a Friend'.tr,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
      ),
      body: isloading ?  Center(child: CircularProgressIndicator(color: notifier.theamcolorelight)) : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Lottie.asset('assets/lottie/8048968.json',height: 270,width: 270),
            SizedBox(height: 20,),
            SizedBox(
              height: 50,
              width: 190,
              child: RichText(text: TextSpan(
                  children: [
                    TextSpan(text: 'Earn'.tr,style: TextStyle(fontSize: 20, color: notifier.textColor,fontWeight: FontWeight.w500,)),
                    TextSpan(text: ' $searchbus${data.signupcredit} ', style: TextStyle(fontSize: 20, color: notifier.textColor,fontWeight: FontWeight.w500)),
                    TextSpan(text: 'for Each'.tr, style: TextStyle(fontSize: 20, color: notifier.textColor,fontWeight: FontWeight.w500)),
                    TextSpan(text: ' '),
                    TextSpan(text: 'Friend you refer'.tr, style: TextStyle(fontSize: 20, color: notifier.textColor,fontWeight: FontWeight.w500)),
                  ]
              ),textAlign: TextAlign.center),
            ),
            SizedBox(height: 30),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset("assets/referbus.png", height: 20, width: 20,),
                      SizedBox(width: 15,),
                      Text("Share the referral link with your friends".tr, textAlign: TextAlign.start, style: TextStyle(fontSize: 16, color: notifier.textColor, fontWeight: FontWeight.bold,),),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset("assets/referbus.png", height: 20, width: 20,),
                      SizedBox(width: 15,),
                      RichText(text: TextSpan(
                          children: [
                            TextSpan(text: 'Friend get'.tr,style: TextStyle(fontSize: 16, color: notifier.textColor,fontWeight: FontWeight.w500)),
                            TextSpan(text: ' $searchbus${data.signupcredit} ', style: TextStyle(fontSize: 16, color: notifier.textColor,fontWeight: FontWeight.w500)),
                            TextSpan(text: 'on their first complete transaction'.tr, style: TextStyle(fontSize: 16, color: notifier.textColor,fontWeight: FontWeight.w500)),
                          ]
                      )),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset("assets/referbus.png", height: 20, width: 20,),
                      SizedBox(width: 15,),
                      // Text("${"You get".tr} ${currency + walletController.signupcredit} ${"on your wallet".tr}", textAlign: TextAlign.start, style: TextStyle(fontSize: 16, color: Colors.black,),
                      RichText(text: TextSpan(
                        children: [
                          TextSpan(text: 'You get'.tr,style: TextStyle(fontSize: 16, color: notifier.textColor,fontWeight: FontWeight.w500)),
                          TextSpan(text: ' $searchbus${data.refercredit} ',style: TextStyle(fontSize: 16, color: notifier.textColor,fontWeight: FontWeight.w500)),
                          TextSpan(text: 'on your wallet'.tr,style: TextStyle(fontSize: 16, color: notifier.textColor,fontWeight: FontWeight.w500)),
                        ]
                      )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            SizedBox(height: 50,),
            Container(
              height: 50,
              width: Get.size.width,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 15, left: 35, right: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(data.code, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(
                        new ClipboardData(text: data.code),
                      );
                    },
                    child: Image(image: AssetImage('assets/copyicon.png'),height: 25,width: 25,)),
                  SizedBox(width: 10,),
                  SizedBox(width: 20,),
                ],
              ),
              decoration: BoxDecoration(
                color: Color(0xFFe1e9f5),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 35,right: 35),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    await FlutterShare.share(
                        title: '$appName',
                        text: 'Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful transaction. Enter my referral code $searchbus${data.signupcredit}  & Enjoy your shopping !!!'.tr,
                        linkUrl: Platform.isAndroid
                            ? 'https://play.google.com/store/apps/details?id=$packageName'
                            : Platform.isIOS
                            ? 'https://play.google.com/store/apps/details?id=$packageName'
                            : "",
                        chooserTitle: '$appName');
                  },
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(notifier.theamcolorelight),shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
                  child:  Text('Refer a Friend'.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> share() async {
    print("!!!!!!!!!!" + appName.toString());
    print("!!!!!!!!!!" + packageName.toString());
    await FlutterShare.share(
        title: '$appName',
        text:
        'Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful transaction. Enter my referral code $searchbus${data.signupcredit} & Enjoy your shopping !!!',
        linkUrl: 'https://play.google.com/store/apps/details?id=$packageName',
        chooserTitle: '$appName');
  }
}
