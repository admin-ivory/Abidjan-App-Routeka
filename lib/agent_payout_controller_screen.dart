// ignore_for_file: avoid_print, unused_local_variable


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayOutController extends GetxController implements GetxService {
  bool isLoading = false;

  TextEditingController amount = TextEditingController();
  TextEditingController upi = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController accountHolderName = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  TextEditingController emailId = TextEditingController();

  // PayOutController() {
  //   getPayOutList();
  // }

  // getPayOutList() async {
  //   try {
  //     Map map = {
  //       "owner_id": getData.read("UserLogin")["id"],
  //     };
  //     Uri uri = Uri.parse(Config.path + Config.payOutList);
  //     var response = await http.post(
  //       uri,
  //       body: jsonEncode(map),
  //     );
  //     if (response.statusCode == 200) {
  //       var result = jsonDecode(response.body);
  //       payoutInfo = PayoutInfo.fromJson(result);
  //     }
  //     isLoading = true;
  //     update();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  emptyDetails() {
    amount.text = "";
    accountNumber.text = "";
    bankName.text = "";
    accountHolderName.text = "";
    ifscCode.text = "";
    upi.text = "";
    emailId.text = "";
    update();
  }

  // requestWithdraweApi({String? rType}) async {
  //   try {
  //     Map map = {
  //       "owner_id": getData.read("UserLogin")["id"],
  //       "amt": amount.text,
  //       "r_type": rType,
  //       "acc_number": accountNumber.text,
  //       "bank_name": bankName.text,
  //       "acc_name": accountHolderName.text,
  //       "ifsc_code": ifscCode.text,
  //       "upi_id": upi.text,
  //       "paypal_id": emailId.text,
  //     };
  //     print(map.toString());
  //     Uri uri = Uri.parse(Config.path + Config.requestWithdraw);
  //     var response = await http.post(
  //       uri,
  //       body: jsonEncode(map),
  //     );
  //     if (response.statusCode == 200) {
  //       var result = jsonDecode(response.body);
  //       print(result.toString());
  //       if (result["Result"] == "true") {
  //         emptyDetails();
  //         getPayOutList();
  //         Get.back();
  //         showToastMessage(result["ResponseMsg"]);
  //       } else {
  //         showToastMessage(result["ResponseMsg"]);
  //       }
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
