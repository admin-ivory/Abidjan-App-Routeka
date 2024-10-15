// ignore_for_file: avoid_print, depend_on_referenced_packages, camel_case_types, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/style.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:provider/provider.dart';
import '../Common_Code/common_button.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../config/light_and_dark.dart';

class Otp_Verfication_Forgot extends StatefulWidget {
final String verificationId;
final String mobileNumber;
const Otp_Verfication_Forgot({super.key, required this.verificationId, required this.ccode, required this.mobileNumber});
final String ccode;

  @override
  State<Otp_Verfication_Forgot> createState() => _Otp_Verfication_ForgotState();
}

class _Otp_Verfication_ForgotState extends State<Otp_Verfication_Forgot> {

  OtpFieldController otpController = OtpFieldController();
  String smscode ="";
  bool isPassword = false;

  TextEditingController newpasswordController = TextEditingController();
  TextEditingController conformpasswordController = TextEditingController();

  // FORGOT API

  Future Forgot(String mobile,ccode,password) async {
    Map body = {
      'mobile' : mobile,
      'ccode' : ccode,
      'password' : password
    };
    print(body);
    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/forget_password.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        print(data);
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
      child: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Text('Awesome',style: TextStyle(color: notifier.textColor,fontFamily: 'SofiaProBold',fontSize: 20),),
            const SizedBox(height: 5,),
            Text('We have sent the OTP to ${widget.mobileNumber}',style:  TextStyle(color: notifier.textColor,fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            OTPTextField(
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
            const SizedBox(height: 20,),
            CommonButton(txt1: 'VERIFY OTP',containcolore: notifier.theamcolorelight,context: context,onPressed1: () {
              FirebaseAuth auth = FirebaseAuth.instance;
              PhoneAuthCredential _credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: smscode);
              auth.signInWithCredential(_credential).then((result) {
                Get.back();
                bootomshet();
              }).catchError((e){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: const Text('Incorrent Otp'),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                );
                print(e);
              });
            }),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  Future<void> bootomshet(){
    return   Get.bottomSheet(isScrollControlled: true,
        Container(
          height: 250,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 15,),
                const Text('Create A New Password',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black)),
                const SizedBox(height: 15,),
                CommonTextfiled2(txt: 'New Password',controller: newpasswordController,context: context),
                const SizedBox(height: 15,),
                CommonTextfiled2(txt: 'Confirm Password',controller: conformpasswordController,context: context),
                const SizedBox(height: 15,),
                CommonButton(containcolore: notifier.theamcolorelight,txt1: 'Confirm',context: context,onPressed1: () {

                  print("dsddds");
                  if(newpasswordController.text.compareTo(conformpasswordController.text) == 0){
                    Forgot(widget.mobileNumber,widget.ccode, conformpasswordController.text,).then((value) {
                      print("++++++${value}");
                      if(value["ResponseCode"] == "200"){
                        Get.back();
                        Fluttertoast.showToast(
                          msg: value["ResponseMsg"],
                        );
                      }else{

                        Fluttertoast.showToast(
                          msg: value["ResponseMsg"],
                        );

                      }
                    });
                  }else{

                    Fluttertoast.showToast(
                      msg: "Please enter current password",
                    );
                  }

                }),
              ],
            ),
          ),
        )
    );
  }

}