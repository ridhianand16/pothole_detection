import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Center(
            child: Text('Pothole and Crack Reporting')
          ),
          backgroundColor: Colors.blueGrey[900],
        ),
        body: Center(
          child: Text ("Take a photo and upload"),
        )
      ),
    ),
  );
}