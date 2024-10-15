// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:flutter/material.dart';
//
// chargeCard(int amount, String email) async {
//   Get.back();
//   print(amount.toString());
//   print(email.toString());
//   var charge = Charge()
//     ..amount = amount * 100
//     ..reference = _getReference()
//     ..putCustomField(
//       'custom_id',
//       '846gey6w',
//     ) //to pass extra parameters to be retrieved on the response from Paystack
//     ..email = email;
//
//   CheckoutResponse response = await plugin.checkout(
//     context,
//     method: CheckoutMethod.card,
//     charge: charge,
//   );
//   if (response.status == true) {
//     // buyOrderInStore(response.reference);
//   } else {
//     // showToastMessage('Payment Failed!!!'.tr);
//     Fluttertoast.showToast(msg: 'Payment Failed!!!',timeInSecForIosWeb: 4);
//   }
// }
