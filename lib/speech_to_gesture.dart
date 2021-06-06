import 'package:flutter/material.dart';

class SpeechToGesture extends StatefulWidget {
  //const SpeechToGesture({Key key}) : super(key: key);

  @override
  _SpeechToGestureState createState() => _SpeechToGestureState();
}

class _SpeechToGestureState extends State<SpeechToGesture> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(child: Text("This is Speech to Gesture Page")));
  }
}