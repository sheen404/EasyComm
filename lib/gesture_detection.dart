import 'package:flutter/material.dart';

class GestureDetection extends StatefulWidget {
  //const GestureDetection({Key key}) : super(key: key);

  @override
  _GestureDetectionState createState() => _GestureDetectionState();
}

class _GestureDetectionState extends State<GestureDetection> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(child: Text("This is Gesture Detection Page")));
  }
}