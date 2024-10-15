import 'package:get/get.dart';

class HomeController extends  GetxController implements GetxService{


  int selectpage = 0;
  int selectpage1 = 0;

  setselectpage(int value){
    selectpage = value;
    update();
  }
}