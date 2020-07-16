import 'package:flutter/material.dart';
import 'dart:async';

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:edge_detection/edge_detection.dart';

class EdgeDetect extends StatefulWidget {
  @override
  _EdgeDetect createState() => new _EdgeDetect();
}

class _EdgeDetect extends State<EdgeDetect> {
  String _imagePath = 'Unknown';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  File example;
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String imagePath;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      imagePath = await EdgeDetection.detectEdge;
    } on PlatformException {
      imagePath = 'Failed to get cropped image path.';
    }
    if (!mounted) return;

    setState(() {
      _imagePath = imagePath;
      // example = File(filePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new Image.file(File(_imagePath)),
        ),
      ),
    );
  }
}
