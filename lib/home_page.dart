import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_comm/gesture_detection.dart';
//import 'package:easy_comm/speech_to_gesture.dart';
import 'package:easy_comm/tutorial.dart';
import 'package:flutter/material.dart';

import 'character_recognition.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _tabItems = [
    Tutorial(),
    CharacterRecognition(),
    GestureDetection(),
    //SpeechToGesture()
  ];
  int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabItems[_activePage],
      //backgroundColor: Color(0xff004AAD),
      bottomNavigationBar: CurvedNavigationBar(
        index: _activePage,
        height: 70.0,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Color(0xff004AAD),
        color: Color(0xff004AAD),
        items: <Widget>[
          Image.asset(
            "images/tutorial.png",
            height: 40,
            width: 40,
          ),
          Image.asset(
            "images/pen.png",
            height: 40,
            width: 40,
          ),
          Image.asset(
            "images/gesture.png",
            height: 50,
            width: 50,
          ),
          // Image.asset(
          //   "images/speech.png",
          //   height: 30,
          //   width: 30,
          // ),
        ],
        animationDuration: Duration(milliseconds: 200),
        onTap: (index) {
          //Handle button tap
          setState(() {
            _activePage = index;
          });
        },
      ),
    );
  }
}