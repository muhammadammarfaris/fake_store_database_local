import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fakestore_api_database/View/HomePageView.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My App',
      home: HomePageView(),
    );
  }
}
