import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pothole and Crack Detection',
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Center(
        child: Column(
          children: <Widget>[
            new GradientAppBar("Pothole and Crack Detection"),
            new ButtonList()
          ],
        ),
      ),
    );
  }
}

class UploadPage extends StatefulWidget {
  UploadPage({Key key, this.url}) : super(key: key);

  final String url;

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Image state = Image(image: AssetImage('assets/transparent.png'),width: 1, height: 1);

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Center(
        child: Column(
          children: <Widget>[
            new GradientAppBar("Pothole and Crack Detection"),
            SizedBox(height: 200),
            SizedBox(child: state, height: 200,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey[700],
          child: Icon(Icons.image),
          onPressed: () async {
            setState(() {
              state = Image(image: AssetImage('assets/loading.gif'));
            });
            File file =
                await ImagePicker.pickImage(source: ImageSource.gallery);

            var request = http.MultipartRequest('POST', Uri.parse(widget.url));
            request.files
                .add(await http.MultipartFile.fromPath('image', file.path));

            // send
            var response = await request.send();
            print(response.statusCode);

            // listen for response
            response.stream.listen((value) {
              print(value);
              setState(() {
                state = Image.memory(value,fit: BoxFit.cover,);
              });
            });
          }),
    );
  }
}

class GradientAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 66.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      height: 140.0,
      padding: new EdgeInsets.only(top: statusBarHeight),
      child: new Center(
        child: new Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Simplifica',
                fontWeight: FontWeight.w600,
                fontSize: 36.0)),
      ),
      decoration: new BoxDecoration(
        boxShadow: [new BoxShadow(blurRadius: 50.0)],
        borderRadius: new BorderRadius.vertical(
          bottom:
              new Radius.elliptical(MediaQuery.of(context).size.width, 75.0),
        ),
        gradient: new LinearGradient(
          colors: [Colors.blueGrey[500], Colors.blueGrey[800]],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.9],
          tileMode: TileMode.clamp,
        ),
      ),
    );
  }
}

class ButtonList extends StatelessWidget {
  void switchScreen(str, context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadPage(url: str),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return new Flexible(
      child: new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              padding: EdgeInsets.only(bottom: 30),
              onPressed: () => switchScreen(
                  "https://sriyaR.pythonanywhere.com/segment", context),
              child: Text(
                "Crack Segmentation",
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontFamily: 'Simplifica',
                  fontWeight: FontWeight.w600,
                  fontSize: 40,
                ),
              ),
            ),
            FlatButton(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                "Pothole Detection",
                style: const TextStyle( 
                  color: Colors.blueGrey,
                  fontFamily: 'Simplifica',
                  fontWeight: FontWeight.w600,
                  fontSize: 40,
                ),
              ),
              onPressed: () => switchScreen(
                  "https://sriyaR.pythonanywhere.com/detect/rcnn", context),
            ),
          ],
        ),
      ),
    );
  }
}
