// ignore_for_file: camel_case_types, file_names, avoid_print, depend_on_referenced_packages, prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zigzag/All_Screen/bottom_navigation_bar_screen.dart';
import 'package:zigzag/Common_Code/homecontroller.dart';
import 'package:zigzag/Sub_Screen/page_list_description_screen.dart';

import '../API_MODEL/page_list_api_model.dart';
import '../Common_Code/common_button.dart';
import '../Sub_Screen/faq_scrren.dart';
import '../Sub_Screen/refer_and_earn_screen.dart';
import '../common_code/language_controller.dart';
import '../config/config.dart';
import 'package:http/http.dart' as http;

import '../config/light_and_dark.dart';
import 'login_screen.dart';


class MyAccount_Screen extends StatefulWidget {
  const MyAccount_Screen({super.key});

  @override
  State<MyAccount_Screen> createState() => _MyAccount_ScreenState();
}

class _MyAccount_ScreenState extends State<MyAccount_Screen> {

  List text21 = [
    'Personal info'.tr,
    'My Ticket'.tr,
    'My Wallet'.tr,
    'Refer and earn'.tr,
    'Language'.tr,
    'Faq'.tr,
    'Dark Mode'.tr,
  ];

  List image = [
    'assets/b1.png',
    'assets/b2.png',
    'assets/b3.png',
    'assets/b4.png',
    'assets/b5.png',
    'assets/b6.png',
    'assets/b7.png',
  ];

  var userData;
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    getlocledata();
    pagelistapi();

  }

  getlocledata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData  = jsonDecode(prefs.getString("loginData")!);

      fun();
      print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+bhjgbkjsnlskn-+-+${userData["id"]}');
    });
  }

  bool light = true;


  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();



  Future Prifile_edite_Api({required String uid}) async {

    Map body = {
      'uid' : uid,
      'name': namecontroller.text,
      'email': emailcontroller.text,
      'password':passwordcontroller.text,
    };

    print("+++ $body");
    try{
      var response2 = await http.post(Uri.parse('${config().baseUrl}/api/profile_edit.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response2.body);
      if(response2.statusCode == 200){
       return jsonDecode(response2.body);
      }else{
        print('failed');
      }

    }catch(e){
      print(e.toString());
    }
  }


  Future Delete_Api_Class({required String uid}) async {

    Map body = {
      'uid' : uid,
    };

    print("+++ $body");
    try{
      var response2 = await http.post(Uri.parse('${config().baseUrl}/api/acc_delete.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response2.body);
      if(response2.statusCode == 200){
        return jsonDecode(response2.body);
      }else {
        print('failed');
      }

    }catch(e){
      print(e.toString());
    }
  }

  HomeController homeController = Get.put(HomeController());
  language1 language11 = Get.put(language1());




  //  GET API CALLING
   PageList? from12;

  Future pagelistapi() async {
    var response1 = await http.get(Uri.parse('${config().baseUrl}/api/pagelist.php'),);
    if (response1.statusCode == 200) {
      var jsonData = json.decode(response1.body);
      print(jsonData["pagelist"]);
      setState(() {
        from12 = pageListFromJson(response1.body);
        isloading = false;
      });
    }
  }


  int value = 0;
  bool isChecked = false;


  List languageimage = [
    'assets/L-English.png',
    'assets/L-Spanish.png',
    'assets/L-Arabic.png',
    'assets/L-French.png',
    'assets/L-Hindi-Gujarati.png',
    'assets/L-Afrikaans.png',
    'assets/L-Bengali.png',
    'assets/L-Indonesion.png',
  ];

  List languagetext = [
    'English',
    'Spanish',
    'Arabic',
    'French',
    'Gujarati',
    'Afrikaans',
    'Bengali',
    'Indonesian',
  ];

  ColorNotifier notifier = ColorNotifier();

  List languagetext1 = [
    'en_English',
    'en_spanse',
    'ur_arabic',
    'fr_french',
    'en_Gujarati',
    'en_African',
    'en_Bangali',
    'en_Indonesiya',
  ];


  fun(){

    for(int a= 0 ;a<languagetext1.length;a++){
      print(languagetext1[a]);
      print(Get.locale);
      if(languagetext1[a].toString().compareTo(Get.locale.toString()) == 0){
        setState(() {
          value = a;
        });

      }else{

      }
    }

  }

  bool rtl = false;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return GetBuilder<HomeController>(
      builder: (homeController) {
        return Scaffold(
          // backgroundColor: const Color(0xffF5F5F5),
          backgroundColor:  notifier.background,
          appBar: AppBar(
            backgroundColor:notifier.appbarcolore,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Center(child: Text('My Account'.tr,style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold))),
          ),
          body: isloading ? Center(child: CircularProgressIndicator(color: notifier.theamcolorelight),) : SingleChildScrollView(
           scrollDirection: Axis.vertical,
           child: Padding(
             padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 InkWell(
                   onTap: () {
                     namecontroller.text = userData["name"];
                     emailcontroller.text = userData["email"];
                     passwordcontroller.text = userData["password"];
                     Get.bottomSheet(isScrollControlled: true,
                         Container(
                           // height: 420,
                           decoration:  BoxDecoration(
                             color: notifier.backgroundgray,
                             borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                           ),
                           child:  Padding(
                             padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               mainAxisSize: MainAxisSize.min,
                               children: <Widget>[
                                 const SizedBox(height: 10,),
                                  Text('Profile Edit'.tr,style: TextStyle(color: notifier.textColor,fontSize: 20,fontFamily: 'SofiaProBold'),),
                                 const SizedBox(height: 10,),
                                 CommonTextfiled200(txt: '${userData["name"]}',controller: namecontroller,context: context),
                                 const SizedBox(height: 10,),
                                 CommonTextfiled200(txt: '${userData["email"]}',controller: emailcontroller,context: context),
                                 const SizedBox(height: 10,),
                                 CommonTextfiled10(txt: '${userData["password"]}',controller: passwordcontroller,context: context),
                                 const SizedBox(height: 10,),


                                 IntlPhoneField(
                                   readOnly: true,
                                   decoration:  InputDecoration(
                                     counterText: "",
                                     enabledBorder: OutlineInputBorder(
                                         borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
                                         borderRadius: BorderRadius.circular(10)
                                     ),
                                     contentPadding: const EdgeInsets.only(top: 8),
                                     hintText: '${userData["mobile"]}',
                                     hintStyle: const TextStyle(
                                         color: Colors.grey,
                                         fontSize: 14,fontWeight: FontWeight.bold
                                     ),
                                     border:  OutlineInputBorder(
                                         borderSide: const BorderSide(color: Colors.grey,),
                                         borderRadius: BorderRadius.circular(10)
                                     ),
                                     focusedBorder: OutlineInputBorder(
                                         borderSide: const BorderSide(color: Color(0xff7D2AFF)),
                                         borderRadius: BorderRadius.circular(10)
                                     ),
                                   ),
                                   flagsButtonPadding: EdgeInsets.zero,
                                   showCountryFlag: false,
                                   showDropdownIcon: false,
                                   initialCountryCode: 'IN',
                                   dropdownTextStyle:  TextStyle(color: notifier.textColor,fontSize: 15),
                                   // style: const TextStyle(color: Colors.black,fontSize: 16),
                                   onChanged: (number) {
                                     setState(() {
                                     });
                                   },
                                 ),
                                 const SizedBox(height: 10,),
                                 CommonButton(txt1: 'Confirm'.tr,containcolore: notifier.theamcolorelight,context: context,onPressed1: () {
                                   Get.back();
                                   if(namecontroller.text.isNotEmpty && emailcontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty){
                                     Prifile_edite_Api(uid: userData["id"]).then((value) async {

                                       SharedPreferences pre = await SharedPreferences.getInstance();
                                       pre.setString("loginData", jsonEncode(value["UserLogin"]));
                                       getlocledata();

                                       ScaffoldMessenger.of(context).showSnackBar(
                                         SnackBar(content: Text(value["ResponseMsg"]),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                       );
                                     });
                                   }else {
                                     ScaffoldMessenger.of(context).showSnackBar(
                                       SnackBar(content: Text('Enter Input'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                     );
                                   }
                                 }),
                                 const SizedBox(height: 20,),
                               ],
                             ),
                           ),
                         ));
                   },
                   child: ListTile(
                     leading: Transform.translate(offset: const Offset(-25, 0),child: CircleAvatar(backgroundColor: Colors.grey.withOpacity(0.2),radius: 35,child: Text(userData['name'][0],style:  TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: notifier.theamcolorelight)),)),
                     title: Transform.translate(offset: const Offset(-35, 0),child: Text(userData['name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: notifier.textColor))),
                     subtitle: Transform.translate(offset: const Offset(-35, 0),child: Text('${userData['ccode']} ${userData['mobile']}',style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 15))),
                     trailing:  Image(image: const AssetImage('assets/pen-line.png'),height: 25,width: 25,color: notifier.theamcolorelight),
                   ),
                 ),
                 const SizedBox(height: 10,),
                 Text('General'.tr,style: TextStyle(color: notifier.textColor)),
                 ListView.separated(
                   physics: const NeverScrollableScrollPhysics(),
                   separatorBuilder: (context, index) {
                      return const SizedBox(width: 5,);
                   },
                     shrinkWrap: true,
                     scrollDirection: Axis.vertical,
                     itemCount: text21.length,
                     itemBuilder: (BuildContext context, int index) {
                       return InkWell(
                         onTap: () {
                           switch(index){
                             case  0:
                               namecontroller.text = userData["name"];
                               emailcontroller.text = userData["email"];
                               passwordcontroller.text = userData["password"];
                             Get.bottomSheet(
                                 isScrollControlled: true,
                                 Container(
                               decoration:  BoxDecoration(
                                 color: notifier.backgroundgray,
                                 borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                               ),
                               child:  Padding(
                                 padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   mainAxisSize: MainAxisSize.min,
                                   children: <Widget>[
                                     const SizedBox(height: 10,),
                                      Text('Profile Edit'.tr,style: TextStyle(color: notifier.textColor,fontSize: 20,fontFamily: 'SofiaProBold'),),
                                     const SizedBox(height: 10,),
                                     CommonTextfiled200(txt: '${userData["name"]}',controller: namecontroller,context: context),
                                     const SizedBox(height: 10,),
                                     CommonTextfiled200(txt: '${userData["email"]}',controller: emailcontroller,context: context),
                                     const SizedBox(height: 10,),
                                     CommonTextfiled10(txt: '${userData["password"]}',controller: passwordcontroller,context: context),
                                     const SizedBox(height: 10,),


                                     IntlPhoneField(
                                       readOnly: true,
                                       decoration:  InputDecoration(
                                         counterText: "",
                                         enabledBorder: OutlineInputBorder(
                                             borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
                                             borderRadius: BorderRadius.circular(10)
                                         ),
                                         contentPadding: const EdgeInsets.only(top: 8),
                                         hintText: '${userData["mobile"]}',
                                         hintStyle: const TextStyle(
                                             color: Colors.grey,
                                             fontSize: 14,fontWeight: FontWeight.bold
                                         ),
                                         border:  OutlineInputBorder(
                                             borderSide: const BorderSide(color: Colors.grey,),
                                             borderRadius: BorderRadius.circular(10)
                                         ),
                                         focusedBorder: OutlineInputBorder(
                                             borderSide: const BorderSide(color: Color(0xff7D2AFF)),
                                             borderRadius: BorderRadius.circular(10)
                                         ),
                                       ),
                                       flagsButtonPadding: EdgeInsets.zero,
                                       showCountryFlag: false,
                                       showDropdownIcon: false,
                                       initialCountryCode: 'IN',
                                       dropdownTextStyle:  TextStyle(color: notifier.textColor,fontSize: 15),
                                       // style: const TextStyle(color: Colors.black,fontSize: 16),
                                       onChanged: (number) {
                                         setState(() {

                                         });
                                       },
                                     ),
                                     const SizedBox(height: 10,),
                                     CommonButton(txt1: 'Confirm'.tr,containcolore:  notifier.theamcolorelight,context: context,onPressed1:  () {
                                       Get.back();
                                       if(namecontroller.text.isNotEmpty && emailcontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty){
                                         Prifile_edite_Api(uid: userData["id"]).then((value) async {

                                           SharedPreferences pre = await SharedPreferences.getInstance();
                                           pre.setString("loginData", jsonEncode(value["UserLogin"]));
                                           getlocledata();

                                           ScaffoldMessenger.of(context).showSnackBar(
                                             SnackBar(content: Text(value["ResponseMsg"]),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                           );
                                         });
                                       }else {
                                         ScaffoldMessenger.of(context).showSnackBar(
                                           SnackBar(content: Text('Enter Input'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                         );
                                       }
                                     }),
                                     const SizedBox(height: 20,),
                                   ],
                                 ),
                               ),
                             ));
                             case  1:
                                homeController.setselectpage(1);
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                             case 2:
                               homeController.setselectpage(2);
                               Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                             case 3:
                               Navigator.of(context).push(MaterialPageRoute(builder: (context) =>   const ReferFriendScreen(),));
                             case 4:
                               Get.bottomSheet(
                                   isScrollControlled: true,
                                   Container(
                                     height: 610,
                                     decoration:  BoxDecoration(
                                       color: notifier.backgroundgray,
                                       borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                                     ),
                                     child:  Padding(
                                       padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
                                       child: SingleChildScrollView(
                                         scrollDirection: Axis.vertical,
                                         child: Column(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           mainAxisSize: MainAxisSize.min,
                                           children: <Widget>[
                                             ListView.builder(
                                               shrinkWrap: true,
                                               scrollDirection: Axis.vertical,
                                               physics: const NeverScrollableScrollPhysics(),
                                               itemCount: 8,
                                               itemBuilder: (context, index) {
                                                 return GestureDetector(
                                                   onTap: () {
                                                     setState(() {
                                                       value = index;
                                                     });



                                                       switch (index) {
                                                         case 0:
                                                           // print(index);
                                                           Get.updateLocale(const Locale('en', 'English'));
                                                           Get.back();
                                                           homeController.setselectpage(0);
                                                           Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                                                           break;
                                                         case 1:
                                                           Get.updateLocale(const Locale('en', 'spanse'));
                                                           Get.back();
                                                           homeController.setselectpage(0);
                                                           Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                                                           break;
                                                         case 2:
                                                           Get.updateLocale(const Locale('ur', 'arabic'));
                                                           Get.back();
                                                           homeController.setselectpage(0);
                                                           Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));

                                                           break;
                                                         case 3:
                                                           Get.updateLocale(const Locale('fr', 'French'));
                                                           Get.back();
                                                           homeController.setselectpage(0);
                                                           Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                                                           break;
                                                         case 4:
                                                           Get.updateLocale(const Locale('en', 'Gujarati'));
                                                           Get.back();
                                                           homeController.setselectpage(0);
                                                           Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                                                           break;
                                                         case 5:
                                                           Get.updateLocale(const Locale('en', 'African'));
                                                           Get.back();
                                                           homeController.setselectpage(0);
                                                           Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                                                           break;
                                                         case 6:
                                                           language11.fun(demo: () {
                                                             Get.updateLocale(const Locale('en', 'Bangali'));
                                                             Get.back();
                                                             homeController.setselectpage(0);
                                                             Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                                                           });
                                                           break;
                                                         case 7:
                                                           language11.fun(demo: (){
                                                             Get.updateLocale(const Locale('en', 'Indonesiya'));
                                                             Get.back();
                                                             homeController.setselectpage(0);
                                                             Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),));
                                                           });
                                                           break;
                                                       }
                                                   },
                                                   child: Container(
                                                     height: 60,
                                                     width: Get.width,
                                                     margin: const EdgeInsets.symmetric(vertical: 7),
                                                     decoration: BoxDecoration(
                                                         border: Border.all(color: value == index ? notifier.theamcolorelight : Colors.transparent,),
                                                         // color:  Color(0xffEEEEEE),
                                                         // color:  Color(0xffF5F5F5),
                                                         color:  notifier.languagecontainercolore,
                                                         borderRadius: BorderRadius.circular(10)),
                                                     child: Column(
                                                         mainAxisAlignment: MainAxisAlignment.center,
                                                         children: [
                                                           Row(
                                                             children: [
                                                               Container(
                                                                 height: 45,
                                                                 width: 60,
                                                                 margin: const EdgeInsets.symmetric(
                                                                     horizontal: 10),
                                                                 decoration: BoxDecoration(
                                                                   color: Colors.transparent,
                                                                   borderRadius: BorderRadius.circular(100),
                                                                 ),
                                                                 child: Center(
                                                                   child: Container(
                                                                     height: 32,
                                                                     width: 32,
                                                                     decoration: BoxDecoration(image: DecorationImage(image: AssetImage(languageimage[index]),)),
                                                                   ),
                                                                 ),
                                                               ),
                                                               const SizedBox(height: 10),
                                                               Column(
                                                                 crossAxisAlignment:
                                                                 CrossAxisAlignment.start,
                                                                 children: [
                                                                   Text(languagetext[index],
                                                                       style: TextStyle(
                                                                           fontWeight: FontWeight.w600,
                                                                           fontSize: 14,
                                                                           fontFamily: 'UrbanistRegular',
                                                                           color: notifier.textColor)),
                                                                 ],
                                                               ),
                                                               const Spacer(),
                                                               CheckboxListTile(index),
                                                               const SizedBox(width: 15,),
                                                             ],
                                                           ),
                                                         ]),
                                                   ),
                                                 );
                                               },
                                             )
                                           ],
                                         ),
                                       ),
                                     ),
                                   ));
                             case 5:
                               Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const Faq_Screeen(),));
                             case 6:
                               return;
                           }
                         },
                         child: ListTile(
                           dense: true,
                           visualDensity: VisualDensity.comfortable,
                           leading: Transform.translate(offset:  const Offset(-15, 0),child: Image(image: AssetImage(image[index]),height: 25,width: 25,color: notifier.textColor,)),
                           title: Transform.translate(offset:  const Offset(-20, 0),child: Text(text21[index].toString().tr,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: notifier.textColor))),
                           trailing: index == 6 ?  SizedBox(
                             height: 20,
                             width: 30,
                             child: Transform.scale(
                               scale: 0.7,
                               child: CupertinoSwitch(
                                 // This bool value toggles the switch.
                                 value: notifier.isDark,
                                 activeColor: notifier.theamcolorelight,
                                 onChanged: (bool value) {
                                   notifier.isAvailable(value);
                                 },
                               ),
                             ),
                           ) :  Icon(Icons.chevron_right,color: notifier.textColor),
                         ),
                       );
                     }),
                 const SizedBox(height: 20,),
                 Text('About'.tr,style: TextStyle(color: notifier.textColor)),
                 const SizedBox(height: 20,),
                 ListView.separated(
                     physics: const NeverScrollableScrollPhysics(),
                     separatorBuilder: (context, index) {
                        return const SizedBox(width: 5);
                     },
                     shrinkWrap: true,
                     scrollDirection: Axis.vertical,
                     itemCount: from12!.pagelist.length,
                     itemBuilder: (BuildContext context, int index) {
                       return InkWell(
                         onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => Page_List_description(title: from12!.pagelist[index].title,description: from12!.pagelist[index].description),));
                         },
                         child: ListTile(
                           dense: true,
                           visualDensity: VisualDensity.comfortable,
                           leading: Transform.translate(offset: const Offset(-15, 0),child:  Image(image: const AssetImage('assets/a3.png'),height: 25,width: 25,color: notifier.textColor,)),
                           title: Transform.translate(offset: const Offset(-20, 0),child: Text('${from12?.pagelist[index].title}',style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: notifier.textColor))),
                           trailing: Icon(Icons.chevron_right,color: notifier.textColor),
                         ),
                       );
                     }),
                 InkWell(
                   onTap: () {
                     showModalBottomSheet<void>(
                       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))),
                       context: context,
                       builder: (BuildContext context) {
                         return Container(
                           height: 200,
                           decoration:  BoxDecoration(
                               color: notifier.containercoloreproper,
                               borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))
                           ),
                           child: Padding(
                             padding: const EdgeInsets.only(left: 15, right: 15),
                             child: Column(
                               mainAxisSize: MainAxisSize.min,
                               children: <Widget>[
                                 const SizedBox(height: 25,),
                                 Text('Delete Account'.tr,style:  TextStyle(color:notifier.theamcolorelight,fontWeight: FontWeight.bold,fontSize: 20)),
                                 const SizedBox(height: 12.5),
                                 const Divider(color: Colors.grey,),
                                 const SizedBox(height: 12.5,),
                                 Text('Are you sure you want to delete account?'.tr,style: TextStyle(color: notifier.textColor,fontSize: 16,fontWeight: FontWeight.bold)),
                                 const SizedBox(height: 25,),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     ElevatedButton(
                                       style: ButtonStyle(fixedSize: const WidgetStatePropertyAll(Size(130, 40)),elevation: const WidgetStatePropertyAll(0),shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),backgroundColor: const WidgetStatePropertyAll(Colors.white)),
                                       onPressed: () => Navigator.pop(context),
                                       child:  Text('Cancel'.tr,style: const TextStyle(color: Colors.black)),
                                     ),
                                     const SizedBox(width: 10,),
                                     ElevatedButton(
                                       style: ButtonStyle(fixedSize: const WidgetStatePropertyAll(Size(130, 40)),elevation: const WidgetStatePropertyAll(0),shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),backgroundColor:  WidgetStatePropertyAll(notifier.theamcolorelight)),
                                       onPressed: () => {
                                         // resetNew(),
                                         Delete_Api_Class(uid: userData["id"]).then((value) {
                                           ScaffoldMessenger.of(context).showSnackBar(
                                             SnackBar(content: Text(value["ResponseMsg"]),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                           );
                                         }),
                                         Navigator.push(context, MaterialPageRoute(builder: (context) => const Login_Screen(),))
                                       },
                                       child:  Text('Yes,Remove'.tr,style: const TextStyle(color: Colors.white)),
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                           ),
                         );
                       },
                     );
                   },
                   child: ListTile(
                     dense: true,
                     visualDensity: VisualDensity.comfortable,
                     leading: Transform.translate(offset: const Offset(-15, 0),child: Image(image: const AssetImage('assets/a6.png'),height: 25,width: 25,color: notifier.textColor,)),
                     title: Transform.translate(offset: const Offset(-20, 0),child: Text('Delete Account'.tr,style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: notifier.textColor))),
                     trailing: Icon(Icons.chevron_right,color: notifier.textColor),
                   ),
                 ),
                 InkWell(
                   onTap: () {
                     showModalBottomSheet<void>(
                       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))),
                       context: context,
                       builder: (BuildContext context) {
                         return Container(
                           height: 200,
                           decoration:  BoxDecoration(
                               color: notifier.containercoloreproper,
                               borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))
                           ),
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             children: <Widget>[
                               const SizedBox(height: 25,),
                               Text('Logout'.tr,style:  TextStyle(color: notifier.theamcolorelight,fontWeight: FontWeight.bold,fontSize: 20)),
                               const SizedBox(height: 25,),
                               Text('Are you sure you want to log out?'.tr,style: TextStyle(color: notifier.textColor,fontSize: 16,fontWeight: FontWeight.bold)),
                               const SizedBox(height: 25,),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   ElevatedButton(
                                     style: ButtonStyle(fixedSize: const WidgetStatePropertyAll(Size(120, 40)),elevation: const WidgetStatePropertyAll(0),shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),backgroundColor: const WidgetStatePropertyAll(Colors.white)),
                                     onPressed: () => Navigator.pop(context),
                                     child: Text('Cancel'.tr,style: const TextStyle(color: Colors.black)),
                                   ),
                                   const SizedBox(width: 10,),
                                   ElevatedButton(
                                     style: ButtonStyle(fixedSize: const WidgetStatePropertyAll(Size(120, 40)),elevation: const WidgetStatePropertyAll(0),shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),backgroundColor:  WidgetStatePropertyAll(notifier.theamcolorelight)),
                                     onPressed: () => {
                                       resetNew(),
                                       // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login_Screen(),)),
                                       homeController.setselectpage(0),
                                       Get.offAll(const Login_Screen())
                                     },
                                     child: Text('Yes,Logout'.tr,style: const TextStyle(color: Colors.white)),
                                   ),
                                 ],
                               ),
                             ],
                           ),
                         );
                       },
                     );
                   },
                   child: ListTile(
                     dense: true,
                     visualDensity: VisualDensity.comfortable,
                     leading: Transform.translate(offset: const Offset(-12, 0),child: const Image(image: AssetImage('assets/Logout.png'),height: 25,width: 25,)),
                     title: Transform.translate(offset: const Offset(-20, 0),child: Text('Logout'.tr,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.red))),
                   ),
                 ),
                 const SizedBox(height: 20,),
               ],
             ),
           ),
         ),
        );
      }
    );
  }

  Widget CheckboxListTile(int index) {
    return SizedBox(
      height: 24,
      width: 24,
      child: ElevatedButton(
        onPressed: () {
          value = index;
          setState(() {
          value = index;

            switch (index) {
              case 0:
                Get.updateLocale(
                    const Locale('en', 'English'));

                Get.back();
                break;
              case 1:
                Get.updateLocale(
                    const Locale('en', 'spanse'));

                Get.back();
                break;
              case 2:
                Get.updateLocale(
                    const Locale('en', 'arabic'));

                Get.back();
                break;
              case 3:
                Get.updateLocale(
                    const Locale('fr', 'French'));

                Get.back();
                break;
              case 4:
                Get.updateLocale(
                    const Locale('en', 'Gujarati'));

                Get.back();
                break;
              case 5:
                Get.updateLocale(
                    const Locale('en', 'African'));

                Get.back();
                break;
              case 6:
                Get.updateLocale(
                    const Locale('en', 'Bangali'));

                Get.back();
                break;
              case 7:
                Get.updateLocale(
                    const Locale('en', 'Indonesiya'));

                Get.back();

            }

          });
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xffEEEEEE),
          side: BorderSide(
            color: (value == index)
                ? Colors.transparent
                : Colors.transparent,
            width: (value == index) ? 2 : 2,
          ),
          padding: const EdgeInsets.all(0),
        ),
        child: Center(
            child: Icon(
              Icons.check,
              color: value == index ? Colors.black : Colors.transparent,
              size: 18,
            )),
      ),
    );
  }

}

resetNew() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLogin', true);
}

