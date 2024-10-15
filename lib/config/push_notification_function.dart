// ignore_for_file: avoid_print

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zigzag/config/config.dart';

Future<void> initPlatformState() async {
  OneSignal.shared.setAppId(config().oneSignel);
  OneSignal.shared
      .promptUserForPushNotificationPermission()
      .then((accepted) {});
  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    print("Accepted OSPermissionStateChanges : $changes");
  });
  // print("--------------__uID : ${getData.read("UserLogin")["id"]}");
}