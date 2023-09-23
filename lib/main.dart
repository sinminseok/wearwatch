
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wearwatch/view/HomeView.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double heartRate = 0.0;

  @override
  void initState() {
    super.initState();

  }
  //
  Future<void> getHeartRate() async {
    const platform = MethodChannel('com.example.heart_rate_sensor');
    try {
      var result = await platform.invokeMethod('getHeartRate');
      if (result != null) {
        // 데이터가 null이 아닌 경우에만 처리
        setState(() {
          heartRate = result;
        });
      } else {
        // 데이터가 null인 경우에 대한 처리
        setState(() {
          heartRate = 0.0; // 또는 다른 기본값 설정
        });
      }
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: InkWell(
            onTap: ()async{
              await getHeartRate();

            },
            child: Text(
              "heartRaddte = $heartRate"
            ),
          ),
        )
      ),
    );
  }
}