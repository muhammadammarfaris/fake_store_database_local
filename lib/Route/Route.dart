import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fakestore_api_database/View/CartPageView.dart';
import 'package:fakestore_api_database/View/HomePageView.dart'; // asumsikan ada HomePageView

class AppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My App',
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => HomePageView(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/cart',
          page: () => CartPageView(),
          transition: Transition.rightToLeft,
        ),
      ],
      theme: ThemeData(
      ),
    );
  }
}
