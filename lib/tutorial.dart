import 'package:flutter/material.dart';

class Tutorial extends StatefulWidget {
  //const Tutorial({Key key}) : super(key: key);

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("This is Tutorial Page"),
      ),
    );
  }
}