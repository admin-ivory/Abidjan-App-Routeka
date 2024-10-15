// ignore_for_file: depend_on_referenced_packages, camel_case_types, file_names, avoid_print

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:otp_text_field/style.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common_Code/common_button.dart';
import '../config/config.dart';
import '../config/light_and_dark.dart';
import '../config/push_notification_function.dart';
import 'bottom_navigation_bar_screen.dart';

class Otp_Screen extends StatefulWidget {

  const Otp_Screen({super.key, required this.verificationId, required this.name, required this.email, required this.mobile, required this.password, required this.ccode, required this.rcode, required this.agettype});
  final String verificationId;
  final String name;
  final String email;
  final String mobile;
  final String password;
  final String ccode;
  final String rcode;
  final String agettype;

  @override
  State<Otp_Screen> createState() => _Otp_ScreenState();
}

class _Otp_ScreenState extends State<Otp_Screen> {
  String smscode = '';
  OtpFieldController otpController = OtpFieldController();

  Future signupapi({required String name, required String email, required String mobile, required String password, required String ccode,required String rcode,required String agettype}) async {

    Map body = {
      'name' : name,
      'email' : email,
      'mobile' : mobile,
      'password' : password,
      'ccode' : ccode,
      'rcode' : rcode,
      'user_type' : agettype,
    };

    print('+++++++++++++++++++++++++++$body');

    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/reg_user.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print('+++++++++++++++++++++++responsebody${response.body}');

      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("loginData", jsonEncode(data["UserLogin"]));
        prefs.setString("currency", jsonEncode(data["currency"]));
        initPlatformState();
        print('++++++++++++++++++++++++++dataaa+$data');

        return data;
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
    return Container(
      decoration:  BoxDecoration(
        color: notifier.containercoloreproper,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 15,right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                Text('Awesome',style: TextStyle(color: notifier.textColor,fontFamily: 'SofiaProBold',fontSize: 20),),
                const SizedBox(height: 5,),
                Text('We have sent the OTP to ${widget.mobile}',style:  TextStyle(color: notifier.textColor,fontWeight: FontWeight.bold),),
                const SizedBox(height: 20,),
                Center(
                  child: OTPTextField(
                    otpFieldStyle: OtpFieldStyle(
                      enabledBorderColor: Colors.grey.withOpacity(0.4),
                    ),
                    controller: otpController,
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 45,
                    fieldStyle: FieldStyle.box,
                    outlineBorderRadius: 5,
                    contentPadding: const EdgeInsets.all(15),
                    style:  TextStyle(fontSize: 17,color: notifier.textColor,fontWeight: FontWeight.bold),
                    onChanged: (pin) {
                    },
                    onCompleted: (pin) {
                      setState(() {
                        smscode = pin;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20,),
                CommonButton(txt1: 'VERIFY OTP',containcolore: notifier.theamcolorelight,context: context,onPressed1: () {

                  FirebaseAuth auth = FirebaseAuth.instance;
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: smscode);
                  auth.signInWithCredential(credential).then((result) {
                    signupapi(name: widget.name, email: widget.email,mobile: widget.mobile,password:widget.password,ccode: widget.ccode,rcode: widget.rcode,agettype:widget.agettype).then((value) {
                      print("+++++++++++++++$value");
                      if(value["ResponseCode"] == "200"){
                        Fluttertoast.showToast(
                          msg: value["ResponseMsg"],
                        );
                        OneSignal.shared.sendTag("user_id", value["UserLogin"]["id"]);

                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Bottom_Navigation(),), (route) => false);
                      }else{
                        Fluttertoast.showToast(msg: value["ResponseMsg"],);
                      }
                    });
                  }).catchError((e){
                    print(e);
                  });

                }),
                    const SizedBox(height: 20,),

              ],
            ),
          )
        ],
      ),
    );
  }
}
