import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:internship/Screens/ApiHit.dart';

import 'package:flutter/services.dart';
import 'package:edge_detection/edge_detection.dart';

import 'dart:convert';

class Picker extends StatefulWidget {
  @override
  _Picker createState() => _Picker();
}

class _Picker extends State<Picker> {
  String _imagePath = 'Unknown';
  @override
  void initState() {
    super.initState();
    // initPlatformState();
    val = false;
  }

  File galleryFile;
  File cameraFile;

  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (galleryFile != null) {
        val = true;
      }
    });
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: galleryFile.path,
    );

    final bytes = File(croppedFile.path).readAsBytesSync();

    String fileImage = base64Encode(bytes);
    base2url(fileImage, context);
  }

  void initPlatformState() async {
    String imagePath;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      imagePath = await EdgeDetection.detectEdge;
    } on PlatformException {
      imagePath = 'Failed to get cropped image path.';
    }
    if (!mounted) return;

    setState(() {
      val = true;
      _imagePath = imagePath;
      final bytes = File(_imagePath).readAsBytesSync();

      String cameraFile = base64Encode(bytes);
      base2url(cameraFile, context);
    });
  }

  bool val;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: val == true
          ? null
          : FloatingActionButton(
              backgroundColor: Color(0xFF007f5f),
              onPressed: () {
                initPlatformState();
              },
              child: Icon(Icons.camera),
            ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: val != false
              ? Center(
                  child: SpinKitWave(
                      color: Color(0xFF007f5f), type: SpinKitWaveType.center))
              : GestureDetector(
                  onTap: () {
                    imageSelectorGallery();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Image.asset(
                        'assets/upload.png',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                      )),
                      Center(
                        child: Text("Tap To Select Image",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontFamily: "Berkshire Swash")),
                      )
                    ],
                  ))),
    );
  }
}
