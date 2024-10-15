// ignore_for_file: camel_case_types, avoid_print, empty_catches

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';

import '../Common_Code/common_button.dart';
import 'otp_verfication_forgot_screen.dart';


class Forgot_With_Number extends StatefulWidget {
  const Forgot_With_Number({super.key});

  @override
  State<Forgot_With_Number> createState() => _Forgot_With_NumberState();
}

class _Forgot_With_NumberState extends State<Forgot_With_Number> {

  String ccode ="";
  String phonenumber = '';
  TextEditingController mobileController = TextEditingController();
  bool isloding = false;

  final FirebaseAuth _auth1 = FirebaseAuth.instance;

  _signInWithMobileNumber1() async {
    try{
      await _auth1.verifyPhoneNumber(
          phoneNumber: ccode + mobileController.text.trim(),
          verificationCompleted: (PhoneAuthCredential authcredential) async {
            await _auth1.signInWithCredential(authcredential).then((value) {

            });
          }, verificationFailed: ((error){
        print(error);
      }), codeSent: (String verificationId, [int? forceResendingToken]){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Otp_Verfication_Forgot(verificationId: verificationId,ccode: ccode,mobileNumber: mobileController.text),));
      }, codeAutoRetrievalTimeout: (String verificationId){
        verificationId = verificationId;
      },
          timeout: const Duration(
              seconds: 45
          )
      );
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children:[
          SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: Colors.red,
                child: const Image(image: AssetImage('assets/generic_banner_Ind.png')),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    const Text('Forgot Password',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 20,),
                    InternationalPhoneNumberInput(
                      controller: mobileController,
                      betweenPadding: 5,
                      onInputChanged: (number) {
                        setState(() {
                          ccode  =  number.dial_code;
                        });
                      },
                      countryConfig: CountryConfig(
                          flagSize: 24,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0,color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          )
                      ),
                      phoneConfig: PhoneConfig(
                        focusedColor: Colors.black,
                        enabledColor: Colors.black,
                        borderWidth: 0,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    CommonButton(txt1: 'GENERATE OTP', txt2: '(ONE TIME PASSWORD)',containcolore: Colors.red,context: context,onPressed1: () {
                      _signInWithMobileNumber1();
                      setState(() {
                        isloding = true;
                      });
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
          isloding ? const Center(child: CircularProgressIndicator(backgroundColor: Colors.red,color: Colors.white,)) :const SizedBox(),
      ]
      ),
    );
  }

}

