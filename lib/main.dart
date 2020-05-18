import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Center(child: Text('Pothole and Crack Reporting')),
          backgroundColor: Colors.blueGrey[900],
        ),
        body: BodyState(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {},
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class BodyState extends StatefulWidget {
  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<BodyState> {
  File imageActual;
  double imageWidth, imageHeight;
  String model = "crack";
  bool busy = false;
  selectFromImagePicker() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null)
      return;
    setState(){
      busy = true;
    }
    predictionImage(image);
  }

  crackUnet(File image) async
  {
    var recognition = await Tflite.detectObjectOnImage(
        path: image.path,
        numResultsPerClass: 1
    );
  }
  predictionImage(var image) async{
    if(image == null)
      return;
    if(model == "crack") {
      await crackUnet(image);
    }
    else{
      //TODO: add the new model here;
    }

    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(){
            imageWidth = info.image.width.toDouble();
            imageHeight = info.image.height.toDouble();
          }

    })));
    setState(){
      imageActual = image;
      busy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text('Location - '),
            ),


          new RaisedButton(
            onPressed: selectFromImagePicker,
            child: Text('Report Issue'),
          ),
        ],
    );
  }
}
