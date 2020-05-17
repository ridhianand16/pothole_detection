import 'package:flutter/material.dart';

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
        body: MyBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {},
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class MyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text('Location - '),
            ),


          new RaisedButton(
            onPressed: () {},
            child: Text('Report Issue'),
          ),
        ],
      ),
    );
  }
}
