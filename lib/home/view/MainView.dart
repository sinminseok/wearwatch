import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wearwatch/utils/Colors.dart';
import 'package:wearwatch/utils/CustomText.dart';
import 'package:background_fetch/background_fetch.dart';
import '../controller/MainController.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {

  MainController _controller = MainController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 50.0, end: 100.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // 1분 주기로 포그라운드 작업 실행
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      _controller.getSensorData();
    });

    // 1분 주기로 백그라운드 작업 예약
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
      _controller.getSensorData();
      BackgroundFetch.finish(taskId);
    }
    ).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });

    _controller.getSensorData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel(); // 타이머 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () async {
          _controller.getSensorData();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Center(
              child: Body2Text("생체 데이터를 수집 중입니다.", kTextBlackColor),
            ),
            SizedBox(height: 20),
            Container(
              height: 150.h,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: _animation.value,
                    height: _animation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: wOrangeColor,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
