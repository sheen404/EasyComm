import 'package:easy_comm/home_page.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Widget splash = SplashScreenView(
      backgroundColor: Colors.black,
      navigateRoute: HomePage(),
      imageSrc: "images/easycomm.png",
      imageSize: 700,
      duration: 5000,
      //text: "EasyCOMM",
      textStyle: TextStyle(fontSize: 40.0),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.black,
          backgroundColor: Colors.black,
          accentColor: Colors.black),
      home: splash,
    );
  }
}