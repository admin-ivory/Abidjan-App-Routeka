// ignore_for_file: camel_case_types, depend_on_referenced_packages, file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'All_Screen/bottom_navigation_bar_screen.dart';
import 'All_Screen/login_screen.dart';



class Splase_Screen extends StatefulWidget {
  const Splase_Screen({super.key});

  @override
  State<Splase_Screen> createState() => _Splase_ScreenState();
}

class _Splase_ScreenState extends State<Splase_Screen> {

  bool? isLogin;
  @override
  void initState() {
    super.initState();
    getDataFromLocal().then((value) {
      if(isLogin!){
        Timer(const Duration(seconds: 3), () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>   const Login_Screen(),), (route) => false);
        });
      } else{
        Timer(const Duration(seconds: 3), () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  const Bottom_Navigation(),), (route) => false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return   const Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/SplaseScreenImage.png'),height: 150,width: 150),
            Text('Routeka',style: TextStyle(color: Color(0xff7D2AFF),fontSize: 25,fontFamily: 'SofiaProBold'),),
          ],
        ),
      ),
    );
  }


  Future getDataFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogin = prefs.getBool("isLogin") ?? true;
    });
  }

}