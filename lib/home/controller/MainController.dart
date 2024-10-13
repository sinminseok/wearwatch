import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearwatch/home/api/HomeApi.dart';
import '../../account/api/LoginApi.dart';
class MainController extends GetxController {
  final Logger logger = Logger();
  Rx<double> heartRate = 0.0.obs;

  Future<void> getSensorData() async {
    const platform = MethodChannel('com.example.heart_rate_sensor');
    try {
      var result = await platform.invokeMethod('getSensorData');
      if (result != null) {
        heartRate.value = result['heartRate'];
        var response = await HomeApi().sendHeartBit(heartRate.value);

        if (!response) {
          reLogin();
        }
      } else {
        heartRate.value = 0.0; // 기본값 설정
      }
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }






  void reLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString("login-code");

    bool response = await OldLoginApi().loginOld(code!);

    if (response) {
      configureBackgroundFetch();
    }
  }

  void configureBackgroundFetch() {
    BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 1,
          stopOnTerminate: false,
          enableHeadless: true,
          startOnBoot: true,
          requiredNetworkType: NetworkType.ANY,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
        ), (taskId) async {
      await getSensorData();
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });
  }
}
