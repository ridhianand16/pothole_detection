import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BodyState(),
    );
  }
}

class BodyState extends StatefulWidget {
  @override
  MyBodyState createState() => MyBodyState();
}

class MyBodyState extends State<BodyState> {
  File imageActual;
  double imageWidth, imageHeight;
  String model = "pothole";
  bool busy = false;
  List _recognitions;

  @override
  void initState() {
    super.initState();
    busy = true;

    loadModel().then((val) {
      setState(() {
        busy = false;
      });
    });
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      if(model == "crack")
      {
        res = await Tflite.loadModel(model: "assets/model/UNet_25_Crack.tflite");
      }
      else
      {
        res = await Tflite.loadModel(model: "assets/model/detect.tflite");
      
      }
      print(res);
    }
    on PlatformException
    {
      print("Failed to load model");
    }
  }

  selectFromImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      busy = true;
    });

    predictionImage(image);
  }

  crackUnet(File image) async {
    var recognition = await Tflite.detectObjectOnImage(
        path: image.path, numResultsPerClass: 1);
    setState(() {
      _recognitions = recognition;
    });
  }

  potholeSSD(File image) async {
    var recognition = await Tflite.detectObjectOnImage(
        path: image.path, numResultsPerClass: 1);
    setState(() {
      _recognitions = recognition;
    });
  }

  predictionImage(var image) async {
    if (image == null) return;
    if (model == "crack") {
      await crackUnet(image);
    } else {
      await potholeSSD(image);
      //TODO: add the new model here;
    }

    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            imageWidth = info.image.width.toDouble();
            imageHeight = info.image.height.toDouble();
          });
        })));
    setState(() {
      imageActual = image;
      busy = false;
    });
  }

  List<Widget> renderBoxes(Size screen)
  {
    if (_recognitions == null)
      return [];
    if (imageWidth == null || imageHeight == null)
      return [];

    double factorX =  screen.width;
    double factorY = imageWidth/imageHeight * factorX;

    Color red = Colors.red;

    return _recognitions.map((re)
    {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            color: red
            ),
        )
      );
      }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(Positioned(
      top: 0.0,
      left: 0.0,
      width: size.width,
      child: imageActual == null
          ? Text("No Image Selected")
          : Image.file(imageActual),
    ));

    stackChildren.addAll(renderBoxes(size));

    if (busy) {
      stackChildren.add(Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Center(child: Text('Pothole and Crack Reporting')),
        backgroundColor: Colors.blueGrey[900],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.image),
        tooltip: "Report Issue",
        onPressed: selectFromImagePicker,
      ),
      body: Stack(
        children: stackChildren,
      ),
    );
  }
}
