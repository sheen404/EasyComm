import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:painter/painter.dart';

class CharacterRecognition extends StatefulWidget {
  @override
  _CharacterRecognitionState createState() => new _CharacterRecognitionState();
}

class _CharacterRecognitionState extends State<CharacterRecognition> {
  bool _finished = false;
  PainterController _controller = _newController();

  @override
  void initState() {
    super.initState();
  }

  static PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = const Color(0xff1F1F1F);
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        new IconButton(
          icon: new Icon(Icons.content_copy),
          tooltip: 'New Painting',
          onPressed: () => setState(() {
            _finished = false;
            _controller = _newController();
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        IconButton(
            icon: new Icon(
              Icons.undo,
            ),
            tooltip: 'Undo',
            onPressed: () {
              if (_controller.isEmpty) {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) =>
                    new Text('Nothing to undo'));
              } else {
                _controller.undo();
              }
            }),
        IconButton(
            icon: new Icon(Icons.delete),
            tooltip: 'Clear',
            onPressed: _controller.clear),
        IconButton(
            icon: new Icon(Icons.check),
            onPressed: () => _show(_controller.finish(), context)),
      ];
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Character Recognition"),
          actions: actions,
          // bottom: new PreferredSize(
          //   child: new DrawBar(_controller),
          //   preferredSize: new Size(MediaQuery.of(context).size.width, 30.0),
          // )
        ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.4,
            width: MediaQuery.of(context).size.width*0.9,
            margin: EdgeInsets.all(20),
            child: new Painter(_controller),
          ),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color(0xff1F1F1F),
            ),
            child: TextButton(
                onPressed: (){},
                child: Text("Detect",
                style: TextStyle(
                  fontSize: 20.0
                ),)),
          )
        ],
      ),
    );
  }

  void _show(PictureDetails picture, BuildContext context) {
    setState(() {
      _finished = true;
    });
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('View your image'),
        ),
        body: Container(
            alignment: Alignment.center,
            child: FutureBuilder<Uint8List>(
              future: picture.toPNG(),
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Image.memory(snapshot.data!);
                    }
                  default:
                    return Container(
                        child: FractionallySizedBox(
                          widthFactor: 0.1,
                          child: AspectRatio(
                              aspectRatio: 1.0,
                              child: CircularProgressIndicator()),
                          alignment: Alignment.center,
                        ));
                }
              },
            )),
      );
    }));
  }
}

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                  child: Slider(
                    value: _controller.thickness,
                    onChanged: (double value) => setState(() {
                      _controller.thickness = value;
                    }),
                    min: 1.0,
                    max: 20.0,
                    activeColor: Colors.white,
                  ));
            })),
        StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return RotatedBox(
                  quarterTurns: _controller.eraseMode ? 2 : 0,
                  child: IconButton(
                      icon: Icon(Icons.create),
                      tooltip: (_controller.eraseMode ? 'Disable' : 'Enable') +
                          ' eraser',
                      onPressed: () {
                        setState(() {
                          _controller.eraseMode = !_controller.eraseMode;
                        });
                      }));
            }),
      ],
    );
  }
}


// import 'dart:ffi';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:rxdart/rxdart.dart';
//
// class CharacterRecognition extends StatefulWidget {
//   //const CharacterRecognition({Key key}) : super(key: key);
//
//   @override
//   _CharacterRecognitionState createState() => _CharacterRecognitionState();
// }
//
// class _CharacterRecognitionState extends State<CharacterRecognition> {
//
//   List<DrawModel> pointsList = <DrawModel>[];
//   List<DrawModel> nullList = <DrawModel>[];
//   final pointsStream = BehaviorSubject<List<DrawModel>>();
//   GlobalKey key = GlobalKey();
//
//   @override
//   void dispose() {
//     pointsStream.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       key: key,
//       body: Column(
//         children: [
//           GestureDetector(
//
//             onPanStart: (details){
//               final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
//
//               Paint paint = Paint();
//               paint.color = Colors.black;
//               paint.strokeWidth = 3.0;
//               paint.strokeCap = StrokeCap.round;
//
//               pointsList.add(DrawModel(
//                   offset: renderBox.globalToLocal(details.globalPosition),
//                   paint: paint
//               ));
//
//               pointsStream.add(pointsList);
//             },
//             onPanUpdate: (details){
//               final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
//
//               Paint paint = Paint();
//               paint.color = Colors.black;
//               paint.strokeWidth = 3.0;
//               paint.strokeCap = StrokeCap.round;
//
//               pointsList.add(DrawModel(
//                   offset: renderBox.globalToLocal(details.globalPosition),
//                   paint: paint
//               ));
//
//               pointsStream.add(pointsList);
//             },
//             onPanEnd: (details){
//               // pointsList.add(DrawModel(offset: null, paint: null));
//               // pointsStream.add(pointsList);
//             },
//
//             child: Center(
//               child: Container(
//                 margin: EdgeInsets.only(top: 70.0),
//                 color: Colors.white,
//                 width: MediaQuery.of(context).size.width*0.9,
//                 height: MediaQuery.of(context).size.width*0.8,
//                 child: StreamBuilder<List<DrawModel>>(
//                   stream: pointsStream.stream,
//                   builder: (context, snapshot) {
//                     return CustomPaint(
//                       painter: DrawingPainter(snapshot.data??<DrawModel>[]),
//                     );
//                   }
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class DrawingPainter extends CustomPainter{
//
//   final List<DrawModel> pointsList;
//
//   DrawingPainter(this.pointsList);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//
//     for(int i =0; i< (pointsList.length - 1); i++){
//       if(pointsList[i]!=null && pointsList[i+1]!=null){
//         canvas.drawLine(pointsList[i].offset, pointsList[i+1].offset, pointsList[i].paint);
//       } else if(pointsList[i]!= null && pointsList[i+1] == null){
//         List<Offset> offsetList = <Offset>[];
//         offsetList.add(pointsList[i].offset);
//         canvas.drawPoints(PointMode.points, offsetList, pointsList[i].paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
//
// }
//
// class DrawModel{
//
//   Offset offset;
//   Paint paint;
//
//   DrawModel({this.offset, this.paint});
// }