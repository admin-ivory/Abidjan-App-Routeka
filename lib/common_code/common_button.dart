// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/light_and_dark.dart';


Widget CommonButton({String? txt1,String? txt2,required Color containcolore,context,required void Function() onPressed1}){
  return  Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: containcolore,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(containcolore),shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))),
        onPressed: onPressed1,
        child: Center(
          child: RichText(text: TextSpan(
              children: [
                TextSpan(text: txt1,style: const TextStyle(fontSize: 15,)),
                TextSpan(text: txt2,style: const TextStyle(fontSize: 15)),
              ]
          )),
        ),
      )
  );
}





Widget CommonButtonwallete({required String img,String? txt1,String? txt2,required Color containcolore,context,required void Function() onPressed1}){
  return  Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: containcolore,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(containcolore),shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))))),
        onPressed: onPressed1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(img),color: Colors.white,height: 20,width: 20,),
            const SizedBox(width: 8,),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text('$txt1',style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
            ),

          ],
        ),
      )
  );
}


Widget CommonButtonWithBorder({String? txt1,String? txt2, Color? containcolore,context}){
  return  Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: containcolore,
      ),
      child: Center(
        child: RichText(text: TextSpan(
            children: [
              TextSpan(text: txt1,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
              TextSpan(text: txt2,style: const TextStyle(fontSize: 15,color: Colors.black)),
            ]
        )),
      )
  );
}



Widget CommonTextfiled({ TextEditingController? controller}){
  return  TextField(
    controller: controller,
    decoration:  const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 10,),
            Text('+91',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
            Image(image: AssetImage('assets/caret-down.png'),color: Colors.black,),
            SizedBox(width: 10,),
          ],
        ),

        hintText: 'Enter your mobile number',hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
    ),
  );
}

Widget CommonTextfiled10({ TextEditingController? controller,  String? txt,required BuildContext context}){
  notifier = Provider.of<ColorNotifier>(context, listen: false);
  return  TextField(
    controller: controller,
    obscureText: true,
    style: TextStyle(color: notifier.textColor),
    decoration:  InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
      focusedBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)),borderSide: BorderSide(color: notifier.theamcolorelight)),
      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)),),
      enabledBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)),borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
      hintText: txt,hintStyle: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 14),
    ),
  );
}

Widget CommonTextfiled2({required String txt,TextEditingController? controller,required BuildContext context}){
  notifier = Provider.of<ColorNotifier>(context, listen: false);
  return TextField(
    controller: controller,
    // obscureText: true,
    style: TextStyle(color: notifier.textColor),
    decoration: InputDecoration(

        contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)),borderSide: BorderSide(color: Colors.red)),
        enabledBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)),borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
        hintText: txt,hintStyle:  const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 14),
      focusedBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)),borderSide: BorderSide(color: notifier.theamcolorelight)),
    ),
  );
}

Widget CommonTextfiled1({required String text}){
  return  TextField(
    decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: const OutlineInputBorder(),
        prefixIcon: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 10,),
            Text('+91',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
            Image(image: AssetImage('assets/caret-down.png'),color: Colors.black,),
            SizedBox(width: 10,),
          ],
        ),
        hintText: text,hintStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
    ),
  );
}


ColorNotifier notifier = ColorNotifier();


Widget CommonTextfiled200({required String txt,TextEditingController? controller,required BuildContext context}){
  notifier = Provider.of<ColorNotifier>(context, listen: false);
  return TextField(
    controller: controller,
    style: TextStyle(color: notifier.textColor),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)),borderSide: BorderSide(color: Colors.red)),
      enabledBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)),borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
      hintText: txt,hintStyle:  const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 14),
      focusedBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)),borderSide: BorderSide(color: notifier.theamcolorelight)),
    ),
  );
}