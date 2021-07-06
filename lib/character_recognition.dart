import 'package:easy_comm/brain.dart';
import 'package:easy_comm/constants.dart';
import 'package:easy_comm/drawing_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';


class CharacterRecognition extends StatefulWidget {
  CharacterRecognition({Key? key}) : super(key: key);


  @override
  _RecognizerScreen createState() => _RecognizerScreen();
}

class _RecognizerScreen extends State<CharacterRecognition> {
  List<Offset> points = <Offset>[];
  AppBrain brain = AppBrain();
  String headerText = 'Header placeholder';
  String footerText = '.....';
  FlutterTts flutterTts = FlutterTts();

  void _cleanDrawing() {
    setState(() {
      points = <Offset>[];
      _resetLabels();
    });
  }



  @override
  void initState() {
    super.initState();
    brain.loadModel();
    _resetLabels();
  }

  @override
  Widget build(BuildContext context) {

    speak() async{
      await flutterTts.speak(footerText);
    }

    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Character Recognition'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(16),
                //color: Colors.red,
                alignment: Alignment.center,
                child: Text(
                  headerText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
            ),
            Container(
              decoration: new BoxDecoration(
                border: new Border.all(
                  width: 3.0,
                  color: Colors.blue,
                ),
              ),
              child: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject() as RenderBox;
                        points.add(
                            renderBox.globalToLocal(details.globalPosition));
                      });
                    },
                    onPanStart: (details) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject() as RenderBox;
                        points.add(
                            renderBox.globalToLocal(details.globalPosition));
                      });
                    },
                    onPanEnd: (details) async {
                      //points.add(null);
                      List? predictions = await brain.processCanvasPoints(points);
                      print(predictions);
                      setState(() {
                        _setLabelsForGuess(predictions!.first['label']);
                      });
                    },
                    child: ClipRect(
                      child: CustomPaint(
                        size: Size(kCanvasSize, kCanvasSize),
                        painter: DrawingPainter(
                          offsetPoints: points,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 32, 0, 64),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(
                        child: Text(
                          footerText,
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ),
                      IconButton(onPressed: () => speak(), icon: Icon(Icons.play_arrow, size: 25,))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _cleanDrawing();
        },
        tooltip: 'Clean',
        child: Icon(Icons.delete),
      ),
    );
  }

  void _resetLabels() {
    headerText = kWaitingForInputHeaderString;
    footerText = kWaitingForInputFooterString;
  }

  void _setLabelsForGuess(String guess) {
    headerText = ""; // Empty string
    footerText = kGuessingInputString + guess;
  }
}
