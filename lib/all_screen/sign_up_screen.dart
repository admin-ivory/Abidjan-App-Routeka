// ignore_for_file: camel_case_types, file_names, avoid_print, empty_catches

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';
import '../Common_Code/common_button.dart';
import 'login_screen.dart';

class Sign_up extends StatefulWidget {
  const Sign_up({super.key});

  @override
  State<Sign_up> createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {

  @override
  void dispose() {
    super.dispose();
    isloding = false;
  }

  bool isloding = false;

  bool referralcode = false;
  String ccode ="";



  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rcodeController = TextEditingController();

  // otp code

  String phonenumber = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future _signInWithMobileNumber() async {
    try{
      await _auth.verifyPhoneNumber(
        phoneNumber: ccode + mobileController.text.trim(),
        verificationCompleted: (PhoneAuthCredential authcredential) async {
          await _auth.signInWithCredential(authcredential).then((value) {
          });
        },verificationFailed: ((error){
        print(error);
      }),codeSent: (String verificationId, [int? forceResendingToken]){
       // Navigator.push(context, MaterialPageRoute(builder: (context) => Otp_Screen(agettype: ,verificationId: verificationId,ccode: ccode,email: emailController.text,name: nameController.text,mobile: mobileController.text,password: passwordController.text,rcode: rcodeController.text,),))  ;

       setState(() {
         isloding = false;
       });

       },codeAutoRetrievalTimeout: (String verificationId){
        verificationId = verificationId;
      },
        timeout: const Duration(
          seconds: 45,
        ),
      );
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        setState(() {
          referralcode = false;
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Padding(
          padding:  const EdgeInsets.all(15),
          child: InkWell(
            onTap: () {
              setState(() {
                referralcode =true;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(color: Colors.grey,),
                Text("HAVE A REFERRAL CODE?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.indigoAccent[700])),
              ],
            ),
          ),
        ),

        body: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Stack(
                    children : [
                      Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.red,
                      child: const Image(image: AssetImage('assets/generic_banner_Ind.png')),
                    ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,top: 30),
                        child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(Icons.arrow_back,color: Colors.black)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        const Text('Create Account or Sign in',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 20,),
                        CommonTextfiled2(txt: 'Enter Your Name',controller: nameController,context: context),
                        const SizedBox(height: 20,),
                        CommonTextfiled2(txt: 'Enter Your Email Id',controller: emailController,context: context),
                        const SizedBox(height: 20,),
                        InternationalPhoneNumberInput(
                          betweenPadding: 5,
                          controller: mobileController,
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
                            ),
                          ),
                          phoneConfig: PhoneConfig(
                            focusedColor: Colors.black,
                            enabledColor: Colors.black,
                            borderWidth: 0,
                          ),
                        ),
                        const SizedBox(height: 20,),
                        CommonTextfiled2(txt: 'Enter Your Password',controller: passwordController,context: context),
                        const SizedBox(height: 20,),
                        referralcode? referralcontain(): const SizedBox(),

                        CommonButton(txt1: 'GENERATE OTP', txt2: '(ONE TIME PASSWORD)',containcolore: const Color(0xff7D2AFF),context: context,onPressed1: () async {

                          mobileCheck(mobileController.text, ccode).then((value) {

                            if(mobileController.text.isNotEmpty){

                              if(value["Result"] == "true"){

                                if(nameController.text.isNotEmpty && emailController.text.isNotEmpty && mobileController.text.isNotEmpty && passwordController.text.isNotEmpty){

                                  _signInWithMobileNumber();
                                  setState(() {
                                    isloding = true;
                                  });

                                }

                                //false
                              }else{

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(value["ResponseMsg"]),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                );

                                //true
                              }
                            }
                            else{

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(value["ResponseMsg"]),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                              );

                            }
                          });

                          // Navigator.push(context, MaterialPageRoute(builder: (context) => const Otp_Screen(),));

                        }),

                        const SizedBox(height: 20,),

                        referralcode?  const SizedBox():Column(
                          children: [
                            const Text('OR',style: TextStyle(fontSize: 18,color: Colors.black),),
                            const SizedBox(height: 20,),
                            RichText(text: TextSpan(
                              children: [
                                const TextSpan(text: 'By logging in,you agree to our ',style: TextStyle(color: Colors.black,fontSize: 12,)),
                                TextSpan(text: 'Terms and Conditions',style: TextStyle(color: Colors.indigoAccent[700],fontSize: 12,decoration: TextDecoration.underline,)),
                              ],
                            )),
                            RichText(text: TextSpan(
                              children: [
                                const TextSpan(text: 'and ',style: TextStyle(color: Colors.black,fontSize: 12,)),
                                TextSpan(text: 'Privacy Policy',style: TextStyle(color: Colors.indigoAccent[700],fontSize: 12,decoration: TextDecoration.underline,)),
                              ],
                            )),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            isloding ?  const Center(child: CircularProgressIndicator(backgroundColor: Colors.red,color: Colors.white,)) : const SizedBox(),
          ],
        ),
      ),
    );
  }



  Widget referralcontain(){
    return  Column(
      children: [
        CommonTextfiled2(txt: 'Enter referral code (optional)',controller: rcodeController,context: context),
        const SizedBox(height: 20,),
      ],
    );
  }



}
