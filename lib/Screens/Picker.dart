import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:internship/Screens/Features.dart';
import 'package:flutter/services.dart';
import 'package:edge_detection/edge_detection.dart';

class Picker extends StatefulWidget {
  @override
  _Picker createState() => _Picker();
}

class _Picker extends State<Picker> {
  String link;

  Future uploadPic(BuildContext context, File _image) async {
    String fileName = _image.path;
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final String url = await firebaseStorageRef.getDownloadURL();
    link = url.toString();
    setState(() {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
              builder: (context) => Editor(link: link, edit: "no", place: 0)),
          (route) => false);
    });
  }

  String _imagePath = 'Unknown';
  @override
  void initState() {
    super.initState();
    // initPlatformState();
    val = false;
  }

  File example;

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
      maxWidth: 512,
      maxHeight: 512,
    );
    uploadPic(context, croppedFile);
  }

  void initPlatformState() async {
    String imagePath;

    setState(() {
      val = true;
      _imagePath = imagePath;
      example = File(_imagePath);

      uploadPic(context, example);
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
