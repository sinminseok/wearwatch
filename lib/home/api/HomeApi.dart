import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Path.dart';
import '../model/HealthInformationRequest.dart';


class HomeApi with ChangeNotifier {

  Future<bool> sendHeartBit(double heartBit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var session = await prefs.getString("session");
    
    var response = await http.post(
      Uri.parse(ROOT_API + "health/append/heart-bit"),
      headers: {
        'Cookie': 'JSESSIONID=$session', // 세션을 쿠키로 전달
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'heartBit': heartBit}), // Serialize the heartBit into JSON
    );

    //todo 세션 저장
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendLocation(double lat, double lng) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var session = await prefs.getString("session");

    var response = await http.post(
      Uri.parse(ROOT_API + "health/append/location"),
      headers: {
        'Cookie': 'JSESSIONID=$session', // 세션을 쿠키로 전달
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'latitude': lat, 'longitude': lng}), // Serialize the lat and lng into JSON
    );

    //todo 세션 저장
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

}