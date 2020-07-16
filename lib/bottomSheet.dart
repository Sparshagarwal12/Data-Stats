import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:internship/Screens/ApiHit.dart';
import 'package:http/http.dart' as http;

import 'package:internship/Screens/picSelection.dart';

import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

var mode = 0, mode2 = 0;
bool check = false;
Future<dynamic> k;
File file;
int height, width;
dynamic docurl;
TextEditingController text = TextEditingController();
String pos;

void settingModalBottomSheet(context, link, index) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          crop(File file) async {
            File croppedFile = await ImageCropper.cropImage(
              sourcePath: file.path,
              maxWidth: 512,
              maxHeight: 512,
            );
            String fileName = croppedFile.path;
            StorageReference firebaseStorageRef =
                FirebaseStorage.instance.ref().child(fileName);
            StorageUploadTask uploadTask =
                firebaseStorageRef.putFile(croppedFile);
            StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
            final String url = await firebaseStorageRef.getDownloadURL();
            setState(() {
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PicEdit(picUrl: url, index: index)),
                  (route) => false);
            });
          }

          return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(0.0))),
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                                        child: CircularProgressIndicator()));
                              },
                            );
                            removeShadow(link, context, index);
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.remove_from_queue,
                              ),
                              Text("Remove Shadow")
                            ],
                          )),
                      GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: "Please Wait",
                                toastLength: Toast.LENGTH_SHORT);
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.photo_size_select_large,
                              ),
                              Text("Resize")
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Widget cancelButton = FlatButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            );
                            Widget continueButton = FlatButton(
                              child: Text("Submit"),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        content: Center(
                                            child:
                                                CircularProgressIndicator()));
                                  },
                                );
                                text.clear();
                                addHead(link, context, text.text, index);
                                Fluttertoast.showToast(
                                    msg: "Please Wait",
                                    toastLength: Toast.LENGTH_SHORT);
                              },
                            );
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("AlertDialog"),
                                  content: TextField(
                                    controller: text,
                                    decoration: InputDecoration(
                                        hintText: "Enter the Text"),
                                  ),
                                  actions: [
                                    cancelButton,
                                    continueButton,
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Icon(Icons.view_headline),
                              Text("Heading")
                            ],
                          )),
                      GestureDetector(
                          onTap: () async {
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
                                        child: CircularProgressIndicator()));
                              },
                            );
                            Directory tempDir = await getTemporaryDirectory();
                            String tempPath = tempDir.path;
                            File file =
                                new File('$tempPath' + "scanKaro" + '.png');
                            http.Response response = await http.get(link);
                            await file.writeAsBytes(response.bodyBytes);
                            crop(file);
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.rotate_90_degrees_ccw,
                              ),
                              Text("Rotate")
                            ],
                          )),
                    ],
                  ),
                ],
              ));
        });
      });
}
