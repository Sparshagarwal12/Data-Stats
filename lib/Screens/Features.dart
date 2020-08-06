import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'ApiHit.dart';

import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

import 'package:esys_flutter_share/esys_flutter_share.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/cupertino.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:internship/Screens/picSelection.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Editor extends StatefulWidget {
  dynamic link;
  String edit;
  int place;
  Editor(
      {Key key, @required this.link, @required this.edit, @required this.place})
      : super(key: key);
  @override
  _Editor createState() => _Editor();
}

List<File> galleryFile;
List<String> image = [];

class _Editor extends State<Editor> {
  ScrollController scrollController;
  bool dialVisible = true;
  File galleryFile;
  @override
  void initState() {
    if (widget.edit == "no") {
      image.add(widget.link);
    }
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  bool val = false;
  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Color(0xFF007f5f),
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.add_photo_alternate, color: Colors.white),
          backgroundColor: Colors.purple.shade300,
          onTap: () async {
            galleryFile =
                await ImagePicker.pickImage(source: ImageSource.gallery);
            setState(() {
              val = true;
              final bytes = File(galleryFile.path).readAsBytesSync();

              String fileImage = base64Encode(bytes);
              base2url(fileImage, context);
            });
          },
          label: 'Gallery',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.purple.shade300,
        ),
        SpeedDialChild(
          child: Icon(Icons.add_a_photo, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () async {
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

              String cameraImage = base64Encode(bytes);
              base2url(cameraImage, context);
            });
          },
          label: 'Camera',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
      ],
    );
  }

  String _imagePath = 'Unknown';
  File example;
  @override
  Widget build(BuildContext context) {
    if (widget.edit == "yes") {
      setState(() {
        image[widget.place] = widget.link;
        widget.edit = "no";
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("DocScanner"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Fluttertoast.showToast(
                            msg: "Please Wait",
                            toastLength: Toast.LENGTH_SHORT);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                content: Center(
                                    child: SpinKitSpinningCircle(
                                        color: Color(0xFF000000))));
                          },
                        );
                      },
                      child: Icon(
                        Icons.picture_as_pdf,
                        size: 30,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        Fluttertoast.showToast(
                            msg: "Function not Called",
                            toastLength: Toast.LENGTH_SHORT);
                      },
                      child: Icon(
                        Icons.merge_type,
                        size: 30,
                      )),
                ],
              ))
        ],
        backgroundColor: Color(0xFF007f5f),
      ),
      floatingActionButton: buildSpeedDial(),
      body: Container(
          child: val
              ? Center(child: SpinKitSpinningCircle(color: Color(0xFF007f5f)))
              : GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(image.length, (index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => PicEdit(
                                        picUrl: image[index],
                                        index: index,
                                        merge: false,
                                      )));
                        },
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade500,
                                        offset: Offset(3, 3),
                                        blurRadius: 5.0,
                                        spreadRadius: 1.0)
                                  ],
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(image[index].toString()),
                                      fit: BoxFit.cover)),
                              height: 180,
                              width: 140,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(
                                          msg: "Deleted",
                                          toastLength: Toast.LENGTH_SHORT);
                                      setState(() {
                                        if (image[index].length >= 1) {
                                          image.remove(image[index]);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Can't Delete Image",
                                              toastLength: Toast.LENGTH_SHORT);
                                        }
                                      });
                                    },
                                    child: Icon(
                                      Icons.restore_from_trash,
                                      color: Colors.black,
                                      size: 40,
                                    )),
                              ),
                            )));
                  }))),
    );
  }
}
