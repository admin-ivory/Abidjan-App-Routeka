// ignore_for_file: camel_case_types, file_names, avoid_print, depend_on_referenced_packages, empty_catches, unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common_Code/common_button.dart';
import '../api_model/agent_signup_api_model.dart';
import '../config/config.dart';
import '../config/light_and_dark.dart';
import '../config/push_notification_function.dart';
import 'bottom_navigation_bar_screen.dart';
import 'otp_verfication_forgot_screen.dart';
import 'otp_verfication_screen.dart';

// MOBILCHECK API

Future mobileCheck(String mobile, ccode) async {

  Map body = {
    'mobile' : mobile,
    'ccode' : ccode,
  };

  print(body);

  try{
    var response = await http.post(Uri.parse('${config().baseUrl}/api/mobile_check.php'), body: jsonEncode(body), headers: {
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


class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {

  bool referralcode = false;
  String ccode = "" ;
  String ccode1 = "" ;


  TextEditingController mobileController = TextEditingController();
  TextEditingController mobileController1 = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();

  List lottie12 = [
    "assets/lottie/slider1.json",
    "assets/lottie/slider2.json",
    "assets/lottie/slider3.json",
    "assets/lottie/slider4.json",
  ];

  List title = [
    "Your Journey, Your Way",
    "Seamless Travel Simplified",
    "Book, Ride, Enjoy",
    "Explore, One Bus at a Time"
  ];

  List description = [
    'Customize your travel effortlessly.',
    'Easy booking and boarding for a stress-free journey.',
    'Swift booking and delightful bus rides.',
    'Discover new places, one bus ride after another.',
  ];

  // LOGIN API

  Future login(String mobile,ccode,password) async {
    Map body = {
      'mobile' : mobile,
      'ccode' : ccode,
      'password' : password
    };
    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/user_login.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);
      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        print("++++++++++++-+++++++++++++-+++++++++${data}");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        initPlatformState();

        prefs.setString("loginData", jsonEncode(data["UserLogin"]));
        prefs.setString("currency", jsonEncode(data["currency"]));

        return data;
      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    isloding = false;
  }

  bool isloding = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController rcodeController = TextEditingController();

  String phonenumber = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future _signInWithMobileNumber(String usertype) async {
    setState(() {
      isloding = true;
    });
    try{
      await _auth.verifyPhoneNumber(
        phoneNumber: ccode1 + mobileController1.text.trim(),
        verificationCompleted: (PhoneAuthCredential authcredential) async {
          await _auth.signInWithCredential(authcredential).then((value) {
          });
        },verificationFailed: ((error){
        print(error);
      }),codeSent: (String verificationId, [int? forceResendingToken]){
        setState(() {
          isloding = false;
        });
        Get.bottomSheet(Otp_Screen(verificationId: verificationId,ccode: ccode1,email: emailController.text,name: nameController.text,mobile: mobileController1.text,password: passwordController1.text,rcode: rcodeController.text, agettype: usertype,)).then((value) {
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

  bool isPassword = false;

  //Forgot screen code


  String ccodeforgot ="";
  String phonenumberforgot = '';
  TextEditingController mobileControllerforgot = TextEditingController();

  final FirebaseAuth _auth1 = FirebaseAuth.instance;

  _signInWithMobileNumber1() async {
    setState(() {
      isloding = true;
    });
    try{
      await _auth1.verifyPhoneNumber(
        phoneNumber: ccode + mobileController.text.trim(),
        verificationCompleted: (PhoneAuthCredential authcredential) async {
          await _auth1.signInWithCredential(authcredential).then((value) {
          });
        }, verificationFailed: ((error){
        print(error);
      }),
        codeSent: (String verificationId, [int? forceResendingToken]){
          setState(() {
            isloding = false;
          });
          Get.bottomSheet(
              Otp_Verfication_Forgot(verificationId: verificationId,ccode: ccode,mobileNumber: mobileController.text)).then((value) {
          });
        },
        codeAutoRetrievalTimeout: (String verificationId){
          verificationId = verificationId;
        },
        timeout: const Duration(
            seconds: 45
        ),
      );
    }catch(e){}
  }



// 1 time Login and remove code

  resetNew() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
  }

  bool passwordvalidate = false;
  bool? isLogin;

  @override
  void initState() {
    SearchGet();
    super.initState();
  }

  ColorNotifier notifier = ColorNotifier();

  int langth = 10;






  //  GET API CALLING
  Agentsignup? from12;

  Future SearchGet() async {
    var response1 = await http.get(Uri.parse('${config().baseUrl}/api/agent_status.php'),);
    if (response1.statusCode == 200) {
      var jsonData = json.decode(response1.body);
      print(jsonData["citylist"]);
      setState(() {
        from12 = agentsignupFromJson(response1.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async{
        setState(() {
          referralcode = false;
        });
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.4)),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20,),
                      Text('Bienvenue chez Routeka',style:  TextStyle(fontFamily: 'SofiaProBold',fontSize: 16,color: notifier.textColor)),
                      const SizedBox(height: 6,),
                      Text('We Will send OTP on this mobile number.'.tr,style:  TextStyle(fontWeight: FontWeight.bold,color: notifier.textColor)),
                      const SizedBox(height: 20,),



                      IntlPhoneField(
                        controller: mobileController,
                        style: TextStyle(color: notifier.textColor),
                        decoration:  InputDecoration(
                          counterText: "",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: const EdgeInsets.only(top: 8),
                          hintText: 'Phone Number'.tr,
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,fontWeight: FontWeight.bold
                          ),
                          border:  OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey,),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color: notifier.theamcolorelight),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        flagsButtonPadding: EdgeInsets.zero,
                        showCountryFlag: false,
                        showDropdownIcon: false,
                        initialCountryCode: 'FR',
                        dropdownTextStyle:  TextStyle(color: notifier.textColor,fontSize: 15),
                        onChanged: (number) {
                          setState(() {
                            ccode  =  number.countryCode;

                            passwordController.text.isEmpty ? passwordvalidate = true : false;
                          });
                        },
                      ),



                      const SizedBox(height: 10,),
                      isPassword ? Column(
                        children: [
                          CommonTextfiled10(controller: passwordController,txt: 'Enter Your Password'.tr,context: context),
                          const SizedBox(height: 10,)
                        ],
                      ): const SizedBox(),
                      const SizedBox(height: 0,),

                      CommonButton(txt1: 'PROCEED'.tr,containcolore: notifier.theamcolorelight,context: context,onPressed1: () {

                        mobileCheck(mobileController.text, ccode).then((value) {

                          if(mobileController.text.isNotEmpty){

                            if(value["Result"] == "true"){
                              setState(() {
                                isPassword = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Number is not register'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                              );
                              //false
                            }else{

                              setState(() {
                                isPassword = true;
                              });

                              // LOGIN API CALLING CODE -

                              if(mobileController.text.isNotEmpty && passwordController.text.isNotEmpty){
                                login(mobileController.text,ccode, passwordController.text,).then((value) {
                                  print("++++++$value");
                                  if(value["ResponseCode"] == "200"){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(value["ResponseMsg"]),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                    );
                                    OneSignal.shared.sendTag("user_id", value["UserLogin"]["id"]);
                                    resetNew();
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Bottom_Navigation(),), (route) => false);
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(value["ResponseMsg"]),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                    );
                                  }
                                });
                              }

                              // true

                            }
                          }
                          else{

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(value["ResponseMsg"]),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                            );

                          }
                        });

                        FocusManager.instance.primaryFocus?.unfocus();



                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const Otp_Screen(),));
                      }),
                      const SizedBox(height: 10,),



                      Center(child: InkWell(
                          onTap: () {

                            mobileCheck(mobileController.text, ccode).then((value) {

                              if(mobileController.text.isNotEmpty){

                                if(value["Result"] == "true"){
                                  // setState(() {
                                  //   isPassword = false;
                                  // });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Number is not register'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                  );
                                  //false
                                }else{

                                  // setState(() {
                                  //   isPassword = true;

                                  // });

                                  // ForGot API CALLING CODE -

                                  _signInWithMobileNumber1();

                                  // true

                                }
                              }
                              else{

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(value["ResponseMsg"]),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                );

                              }
                            });





                            // if(mobileController.text.isEmpty){
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(content: const Text('Please Enter The Number'),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                            //   );
                            // }else{
                            //   _signInWithMobileNumber1();
                            // }





                          },
                          child:  Text('Forgot Password ?'.tr,style: TextStyle(fontSize: 16,fontFamily: 'SofiaProBold',color: notifier.textColor)))),



                      const SizedBox(height: 10,),


                    ],
                  ),
                ),
                const Divider(color: Colors.grey,),



                InkWell(
                    onTap: () {
                      bottomSheet("USER",'Create Account Or Sign in');
                    },
                    child: Text("Don’t Have an account yet? Sign Up".tr,style: TextStyle(fontFamily: 'SofiaProBold',fontSize: 15,color: Colors.indigoAccent[700]))
                ),

                const SizedBox(height: 10,),

                from12?.agentStatus == "1" ? InkWell(
                    onTap: () {
                      bottomSheet("AGENT",'Enlist as a Routeka Partner now!');
                    },
                    child: Text("Join us as a Routeka Partner today!".tr,style: const TextStyle(fontFamily: 'SofiaProBold',fontSize: 13,color: Colors.green))
                ) : const SizedBox(),



                from12?.agentStatus == "1" ? const SizedBox(height: 10,) : SizedBox(),
              ],
            ),
          ),
        ),
        backgroundColor: notifier.background,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          child: Stack(
            children: [
              SizedBox(
                height: Get.height,
                child: Column(
                  children: <Widget>[

                    // const SizedBox(height: 30,),
                    const Spacer(flex: 1),
                    Column(
                      children: [
                        const Image(image: AssetImage('assets/logo.png'),height: 70,width: 70),
                        Text('Routeka'.tr,style: TextStyle(color: notifier.theamcolorelight,fontSize: 20,fontFamily: 'SofiaProBold'),),
                      ],
                    ),

                    // const SizedBox(height: 50,),
                    const Spacer(flex: 1),
                    CarouselSlider(
                        items: [
                          for(int a =0; a< lottie12.length;a++) Column(
                            children: [
                              Lottie.asset(lottie12[a],height: 200),
                              const SizedBox(height: 30,),

                              Text(title[a].toString().tr,style:  TextStyle(color: notifier.textColor,fontFamily: 'SofiaProBold',fontSize: 18),),
                              const SizedBox(height: 5,),
                              Container(
                                height : 2,
                                width: 70,
                                color: notifier.theamcolorelight,
                              ),
                              const SizedBox(height: 15,),
                              Expanded(
                                child: SizedBox(
                                  // height: 50,
                                  width: 200,
                                  child: Text('${description[a]}',style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 13),textAlign: TextAlign.center),
                                ),
                              ),
                            ],
                          ),
                        ],
                        options: CarouselOptions(
                          height: 345,
                          // aspectRatio: 16/9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 2),
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          scrollDirection: Axis.horizontal,
                        )
                    ),
                    const Spacer(flex: 10),
                  ],
                ),
              ),
              isloding?  Center(child: Padding(padding: const EdgeInsets.only(top: 400), child: CircularProgressIndicator(color: notifier.theamcolorelight),)):const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }



  Widget referralcontain(){
    return  Column(
      children: [
        CommonTextfiled2(txt: 'Enter referral code (optional)'.tr,context: context),
        const SizedBox(height: 20,),
      ],
    );
  }



  Future getDataFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogin = prefs.getBool("isLogin".tr) ?? true;
    });
    print(isLogin);
  }

  Future bottomSheet(String userType,String toptext){
    return  Get.bottomSheet(isScrollControlled: true,StatefulBuilder(
        builder: (context, setState)  {
          return Container(
            decoration:  BoxDecoration(
              color: notifier.containercoloreproper,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
            ),
            child:  Padding(
              padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 10,),
                  Text(toptext.tr,style:  TextStyle(color: notifier.textColor,fontSize: 20,fontFamily: 'SofiaProBold'),),
                  const SizedBox(height: 10,),
                  CommonTextfiled2(txt: 'Enter Your Name'.tr,controller: nameController,context: context),
                  const SizedBox(height: 10,),
                  CommonTextfiled2(txt: 'Enter Your Email Id'.tr,controller: emailController,context: context),
                  const SizedBox(height: 10,),


                  IntlPhoneField(
                    controller: mobileController1,
                    decoration:  InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: const EdgeInsets.only(top: 8),
                      hintText: 'Phone Number'.tr,
                      hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,fontWeight: FontWeight.bold
                      ),
                      border:  OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey,),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:  BorderSide(color: notifier.theamcolorelight),
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    style: TextStyle(color: notifier.textColor),
                    flagsButtonPadding: EdgeInsets.zero,
                    showCountryFlag: false,
                    showDropdownIcon: false,
                    initialCountryCode: 'IN',
                    dropdownTextStyle:  TextStyle(color: notifier.textColor,fontSize: 15),
                    // style: const TextStyle(color: Colors.black,fontSize: 16),
                    onCountryChanged: (value) {
                      setState(() {
                        langth = value.maxLength;
                        mobileController1.clear();
                      });
                    },
                    onChanged: (number) {
                      setState(() {
                        ccode1 = number.countryCode;
                      });
                    },
                  ),


                  const SizedBox(height: 10,),
                  CommonTextfiled10(txt: 'Enter Your Password'.tr,controller: passwordController1,context: context),
                  const SizedBox(height: 10,),
                  referralcode? referralcontain(): const SizedBox(),

                  CommonButton(txt1: 'GENERATE OTP'.tr, txt2: '(ONE TIME PASSWORD)'.tr,containcolore: notifier.theamcolorelight,context: context,onPressed1: () async {

                    if(mobileController1.text.length == langth){
                      mobileCheck(mobileController1.text, ccode1).then((value) {

                        if(mobileController1.text.isNotEmpty){

                          if(value["Result"] == "true"){


                            if(nameController.text.isNotEmpty && emailController.text.isNotEmpty && mobileController1.text.isNotEmpty && passwordController1.text.isNotEmpty){
                              print("ssssss");
                              Get.back();
                              _signInWithMobileNumber(userType);
                              setState(() {
                                isloding = true;
                              });

                            }
                            // false
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
                      Get.back();
                    }else{
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text('hello'),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                      // );
                    }


                  }),
                  const SizedBox(height: 10,),
                  Padding(
                    padding:  const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          referralcode =! referralcode;
                          print('${referralcode}');
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(color: Colors.grey,),
                          Text("HAVE A REFERRAL CODE?".tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.indigoAccent[700])),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    ));
  }

}





// SizedBox(
// height: Get.height,
// child: Stack(
// alignment: Alignment.center,
// children: [
// Column(
// children: <Widget>[
//
// const SizedBox(height: 30,),
//
// Column(
// children: [
// const Image(image: AssetImage('assets/logo.png'),height: 70,width: 70),
// Text('zigzag'.tr,style: TextStyle(color: notifier.theamcolorelight,fontSize: 20,fontFamily: 'SofiaProBold'),),
// ],
// ),
//
// // const SizedBox(height: 50,),
// const Spacer(flex: 1),
// CarouselSlider(
// items: [
// for(int a =0; a< lottie12.length;a++) Column(
// children: [
// Lottie.asset(lottie12[a],height: 200),
// const SizedBox(height: 30,),
//
// Text(title[a].toString().tr,style:  TextStyle(color: notifier.textColor,fontFamily: 'SofiaProBold',fontSize: 18),),
// const SizedBox(height: 5,),
// Container(
// height : 2,
// width: 70,
// color: notifier.theamcolorelight,
// ),
// const SizedBox(height: 15,),
// Expanded(
// child: SizedBox(
// // height: 50,
// width: 200,
// child: Text('${description[a]}',style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 13),textAlign: TextAlign.center),
// ),
// ),
// ],
// ),
// ],
// options: CarouselOptions(
// height: 345,
// // aspectRatio: 16/9,
// viewportFraction: 0.8,
// initialPage: 0,
// enableInfiniteScroll: true,
// reverse: false,
// autoPlay: true,
// autoPlayInterval: const Duration(seconds: 2),
// autoPlayAnimationDuration: const Duration(milliseconds: 800),
// autoPlayCurve: Curves.fastOutSlowIn,
// enlargeCenterPage: true,
// enlargeFactor: 0.3,
// scrollDirection: Axis.horizontal,
// )
// ),
// const Spacer(flex: 4),
// ],
// ),
// isloding?  Center(child: Padding(padding: const EdgeInsets.only(top: 400), child: CircularProgressIndicator(color: notifier.theamcolorelight),)):const SizedBox(),
// ],
// ),
// )



//USER
// {"UserLogin":{"id":"18","name":"om","mobile":"9999999999","password":"123","rdate":"2023-12-11 15:18:03","status":"1","ccode":"+91","code":"478060","refercode":null,"wallet":"0","email":"om1@gmail.com","user_type":"USER","is_verify":"1"},"currency":"$","ResponseCode":"200","Result":"true","ResponseMsg":"Sign Up Done Successfully!"}

//AGENT
//{id: 19, name: om2, mobile: 6666666666, password: 123, rdate: 2023-12-11 15:19:07, status: 1, ccode: +91, code: 798429, refercode: null, wallet: 0, email: om2@gmail.com, user_type: AGENT, is_verify: 0}, currency: $, ResponseCode: 200, Result: true, ResponseMsg: Sign Up Done Successfully!}



// IS VERFY 1 TO : TICKET BOOK ONLY AGENT
// IS BLOCKD TO NO : SEARCH AND NO OTHER FUNCTIONALTI USE
// IS VERFY 0 TO : TICKET NO BOOK ONLY AGENT


