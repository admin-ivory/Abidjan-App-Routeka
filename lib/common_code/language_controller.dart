// ignore_for_file: camel_case_types

import 'package:get/get.dart';

class language1 extends GetxController  implements GetxService{

  fun({required Function demo}){
    demo();
    update();
  }

}