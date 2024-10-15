// ignore_for_file: avoid_print, depend_on_referenced_packages, camel_case_types, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API_MODEL/faq_list_api_model.dart';
import '../config/config.dart';
import '../config/light_and_dark.dart';

class Faq_Screeen extends StatefulWidget {
  const Faq_Screeen({super.key});

  @override
  State<Faq_Screeen> createState() => _Faq_ScreeenState();
}

class _Faq_ScreeenState extends State<Faq_Screeen> {

  Faqlist? data1;
  bool isloading = true;

  @override
  void initState() {
    getlocledata();
    super.initState();
  }


  var userData;
  var searchbus;
  getlocledata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData  = jsonDecode(prefs.getString("loginData")!);
      searchbus = jsonDecode(prefs.getString('currency')!);
      FaqList(userData["id"],);

      print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${userData["mobile"]}');
    });
  }


  Future FaqList(String uid) async {

    Map body = {
      'uid' : uid,
    };

    print("+++--++ $body");

    try{
      var response = await http.post(Uri.parse('${config().baseUrl}/api/faq.php'), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      print(response.body);

      if(response.statusCode == 200){
        setState(() {
          data1 = faqlistFromJson(response.body);
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
    return  Scaffold(
      // backgroundColor: const Color(0xffF5F5F5),
      backgroundColor: notifier.backgroundgray,
      appBar: AppBar(
        backgroundColor: notifier.appbarcolore,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title:  Text('Faq List'.tr,style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
      ),
      body: isloading ?  Center(child: CircularProgressIndicator(color: notifier.theamcolorelight),) : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 5,);
                },
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: data1!.faqData.length,
                itemBuilder: (BuildContext context, int index) {
                  return  Container(
                     // color: const Color(0xffEEEEEE),
                     color: notifier.fagcontainer,
                    margin: const EdgeInsets.all(10),
                    child: ExpansionTile(
                      collapsedIconColor: notifier.textColor,
                      iconColor: notifier.textColor,
                      textColor: const Color(0xff7D2AFF),
                      // collapsedTextColor: Color(0xff7D2AFF),
                      // backgroundColor: Color(0xff7D2AFF),
                      title: Text('${data1?.faqData[index].question}',style:  TextStyle(fontWeight: FontWeight.bold,color: notifier.textColor)),
                      children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 17,),
                          Expanded(child: Text('${data1?.faqData[index].answer}',style: TextStyle(color: notifier.textColor),)),
                          const SizedBox(width: 17,),
                        ],
                      ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 50,),

          ],
        ),
      ),
    );
  }
}