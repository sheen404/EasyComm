import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class GestureDetection extends StatefulWidget {
  //const GestureDetection({Key key}) : super(key: key);

  @override
  _GestureDetectionState createState() => _GestureDetectionState();
}

class _GestureDetectionState extends State<GestureDetection> {

  final picker = ImagePicker();
  late File _image;
  bool _loading = false;
  late List _output;
  FlutterTts flutterTts = FlutterTts();

  pickImage() async{
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyModel(_image);
  }

  pickGalleryImage() async{
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyModel(_image);
  }


  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value){
        //setState(() {
        //});
    });
  }

  @override
  void dispose(){
    Tflite.close();
    super.dispose();
  }

  classifyModel(File image) async{
    var output = await Tflite.runModelOnImage(path: image.path,
        numResults: 2,
        threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5
    );
    setState(() {
      _loading = false;
      _output = output!;
    });
  }

  loadModel() async {
    await Tflite.loadModel(model: 'assets/model_unquant.tflite',
        labels: 'assets/labels.txt');

  }

  @override
  Widget build(BuildContext context) {
    speak() async{
      await flutterTts.speak('${_output[0]['label']}');
    }
    return Scaffold(
      //backgroundColor: ,
      appBar: AppBar(
        backgroundColor: Color(0xff004AAD),
        title: Text("Gesture Detection"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            Text("Capture IMAGE for detecting the Gesture.",
            style: TextStyle(
              fontSize: 18
            ),),
            SizedBox(
              height: 60.0,
            ),
            Center(
              child: _loading ? Container(
                width: 250.0,
                height: 250.0,
                color: const Color(0xff1F1F1F),
                child: Column(
                  children: [],
                ),
              ) : Container(child: Column(
                children: [
                  Container(
                    height: 200,
                    child: Image.file(_image),
                  ),
                  SizedBox(height: 20.0,),
                  _output != null ? Text('${_output[0]['label']}',
                    style: TextStyle(
                      fontSize: 25
                    ),) : Container()
                ],
              ),),
            ),
            SizedBox(height: 5,),
            Container(width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xff004AAD),
                  ),
                  child: TextButton(
                      onPressed: (){
                        pickImage();
                      },
                      child: Text("Take a Photo",
                        style: TextStyle(
                            fontSize: 20.0,
                          color: Colors.white
                        ),)),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xff1F1F1F),
                  ),
                  child: TextButton(
                      onPressed: (){
                        pickGalleryImage();
                      },
                      child: Text("Camera Roll",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white
                        ),)),
                ),
              ],
            ),
            ),
            IconButton(onPressed: () => speak(), icon: Icon(Icons.play_arrow, size: 25,))
          ],
        ),
      ),
    );
  }
}