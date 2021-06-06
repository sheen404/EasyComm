import 'package:flutter/material.dart';

class CharacterRecognition extends StatefulWidget {
  //const CharacterRecognition({Key key}) : super(key: key);

  @override
  _CharacterRecognitionState createState() => _CharacterRecognitionState();
}

class _CharacterRecognitionState extends State<CharacterRecognition> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(child: Text("This is Character Recognition Page")));
  }
}