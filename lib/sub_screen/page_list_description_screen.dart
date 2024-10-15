// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../Common_Code/common_button.dart';
import '../config/light_and_dark.dart';

class Page_List_description extends StatefulWidget {
  final String title;
  final String description;


  const Page_List_description({super.key, required this.title, required this.description});

  @override
  State<Page_List_description> createState() => _Page_List_descriptionState();
}

class _Page_List_descriptionState extends State<Page_List_description> {


  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isloading = false;
    });
    super.initState();
  }

  bool isloading = true;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2C2C2C),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(widget.title,style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
      ),
      body:  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HtmlWidget(
              onLoadingBuilder: (context, element, loadingProgress) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child:  Center(child: CircularProgressIndicator(color: notifier.theamcolorelight)));
              },
              widget.description,
              textStyle: const TextStyle(color: Colors.black, fontSize: 17,),
            ),
          ],
          ),
        ),
      ),
    );
  }
}
