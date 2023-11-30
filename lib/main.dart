

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wearwatch/view/HomeView.dart';
import 'package:wear/wear.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
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
                FirebaseFirestore _firestore = FirebaseFirestore.instance;
                await _firestore.collection("heart").doc("zmWPiQle7k5duY0NHNSW").set(
                  {
                    "brand": "Genesis",
                    "name": "G70",
                    "price": 5000,
                  },);
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