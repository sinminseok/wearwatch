

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wearwatch/utils/Colors.dart';
import 'package:wearwatch/utils/CustomText.dart';

import '../controller/LoginController.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginController _controller = LoginController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _controller.checkAutoLogin(), // 비동기 작업을 위한 Future
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터 로드 중일 때 로딩 인디케이터 표시
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 에러가 발생한 경우
            return Center(child: Text('인터넷 연결을 확인하세요.', style: TextStyle(color: kTextBlackColor),));
          }

          // 데이터 로드가 완료된 후 UI 구성
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 70.h, left: 0.w),
                    child: Body2Text("시니어 코드 로그인", kTextBlackColor),
                  ),
                ),
                Center(
                  child: Container(
                    width: 235.w,
                    height: 26.h,
                    margin: EdgeInsets.only(top: 10.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: wBorderGrey300Color, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 14.w, top: 2.h),
                      // 힌트 텍스트와 입력란 간의 간격 조정
                      child: TextFormField(
                        controller: _controller.codeController,
                        style: TextStyle(color: Colors.black),
                        // 텍스트 색상을 검정색으로 설정
                        textAlign: TextAlign.left,
                        // 텍스트를 왼쪽으로 정렬
                        cursorColor: kTextBlackColor,
                        decoration: InputDecoration(
                          hintText: "아이디",
                          hintStyle: TextStyle(
                              color: wGrey300Color,
                              fontSize: 14.sp,
                              fontFamily: "hint"),
                          border: InputBorder.none,
                          isDense: true, // 덴스한 디자인을 사용하여 높이를 줄임
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    //Get.to(() => LocationWidget());
                    _controller.login(context);
                  },
                  child: Center(
                    child: Container(
                      width: 235.w,
                      height: 20.h,
                      margin: EdgeInsets.only(top: 7.h),
                      decoration: BoxDecoration(color: wOrangeColor),
                      child: Center(
                        child: Body2Text("로그인", wWhiteBackGroundColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}