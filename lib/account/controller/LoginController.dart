import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearwatch/account/api/LoginApi.dart';
import 'package:wearwatch/home/view/MainView.dart';

class LoginController extends GetxController {
  TextEditingController _codeController = TextEditingController();

  void login(BuildContext context) async {
    //todo _codeController.text 로 변경
    var response = await OldLoginApi().loginOld(_codeController.text);
    if (response) {
      Get.offAll(() => MainView());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('로그인 실패'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: '확인',
          onPressed: () {},
        ),
      ));
    }
  }

  Future<bool> checkAutoLogin() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? code = await prefs.getString("login-code");
    if(code != null){
      bool response = await OldLoginApi().loginOld(code);
      Get.offAll(() => MainView());
    }
    return true;
  }

  TextEditingController get codeController => _codeController;
}
