import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart';

import 'dart:convert';
import 'package:internship/Screens/ApiHit.dart';
import 'package:internship/Screens/bright.dart';
import 'package:internship/Screens/picSelection.dart';

var mode = 0, mode2 = 0;
bool check = false;
Future<dynamic> k;
File file;
int height, width;
dynamic docurl;
TextEditingController text = TextEditingController();
TextEditingController bottext = TextEditingController();
TextEditingController toptext = TextEditingController();
TextEditingController watertext = TextEditingController();
String pos;

void settingModalBottomSheet(context, link, index) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          crop(File file) async {
            File croppedFile = await ImageCropper.cropImage(
              cropStyle: CropStyle.rectangle,
              sourcePath: file.path,
              androidUiSettings: AndroidUiSettings(
                  toolbarTitle: 'Scan Karo',
                  toolbarColor: Color(0xFF007f5f),
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
            );
            final bytes = File(croppedFile.path).readAsBytesSync();

            String fileImage = base64Encode(bytes);
            String url = "https://cam-scanner.herokuapp.com/bs2url";
            var body = {"BASE64": fileImage};
            Response r = await post(
              Uri.parse(url),
              headers: {"Content-Type": "application/json"},
              body: json.encode(body),
            );
            print(r.body);
            dynamic mod = json.decode(r.body);
            setState(() {
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PicEdit(
                            picUrl: mod["URL"],
                            index: index,
                            merge: false,
                          )),
                  (route) => false);
            });
          }

          return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(50.0),
                      topRight: const Radius.circular(50.0))),
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.4,
                    child: ListTile(
                        title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.brush, color: Color(0xFF007f5f)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Tools',
                          style: TextStyle(
                              color: Color(0xFF007f5f),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 4,
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
                                          child: CircularProgressIndicator()));
                                },
                              );
                              removeShadow(link, context, index);
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xFF007f5f),
                                  child: Icon(Icons.remove_from_queue,
                                      color: Colors.white),
                                ),
                                Text("Remove\nShadow")
                              ],
                            )),
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
                              // resize(link, context, index);
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xFF007f5f),
                                  child: Icon(Icons.photo_size_select_large,
                                      color: Colors.white),
                                ),
                                Text("Resize")
                              ],
                            )),
                        GestureDetector(
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: "Please Wait",
                                  toastLength: Toast.LENGTH_SHORT);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text("Select Watermark Location"),
                                      content: Container(
                                        height: 150,
                                        child: Column(
                                          children: <Widget>[
                                            TextField(
                                              controller: watertext,
                                            ),
                                            SizedBox(height: 30),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            elevation: 0,
                                                            content: Center(
                                                                child:
                                                                    CircularProgressIndicator()));
                                                      },
                                                    );
                                                    watermarkMid(link, context,
                                                        index, watertext.text);
                                                  },
                                                  child: Container(
                                                      height: 40,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color: Colors.blue),
                                                      child: Center(
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: Text(
                                                                "Middle",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )))),
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              elevation: 0,
                                                              content: Center(
                                                                  child:
                                                                      CircularProgressIndicator()));
                                                        },
                                                      );
                                                      watermarkBot(
                                                          link,
                                                          context,
                                                          index,
                                                          watertext.text);
                                                    },
                                                    child: Container(
                                                        height: 40,
                                                        width: 80,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            color: Colors.blue),
                                                        child: Center(
                                                            child: Padding(
                                                                padding: EdgeInsets
                                                                    .all(10),
                                                                child: Text(
                                                                    "Bottom",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Colors.white)))))),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                                },
                              );
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xFF007f5f),
                                  child: Icon(Icons.branding_watermark,
                                      color: Colors.white),
                                ),
                                Text("WaterMark")
                              ],
                            )),
                        GestureDetector(
                            onTap: () {
                              // addText(link, context, "pos");
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
                                  Fluttertoast.showToast(
                                      msg: "Please Wait",
                                      toastLength: Toast.LENGTH_SHORT);
                                  addTextTop(
                                      link,
                                      context,
                                      toptext.text.toString(),
                                      bottext.text.toString(),
                                      index);
                                  toptext.clear();
                                  bottext.clear();
                                },
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Add Text"),
                                    content: Stack(
                                      children: [
                                        TextField(
                                          controller: toptext,
                                          decoration: InputDecoration(
                                              hintText: "Enter the Top Text"),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  15),
                                          child: TextField(
                                            controller: bottext,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Enter the Bottom Text"),
                                          ),
                                        )
                                      ],
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
                                CircleAvatar(
                                  backgroundColor: Color(0xFF007f5f),
                                  child: Icon(Icons.text_format,
                                      color: Colors.white),
                                ),
                                Text("Add Text")
                              ],
                            )),
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
                                  addHead(link, context, text.text, index);
                                  Fluttertoast.showToast(
                                      msg: "Please Wait",
                                      toastLength: Toast.LENGTH_SHORT);
                                  text.clear();
                                },
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Add Heading"),
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
                                CircleAvatar(
                                  backgroundColor: Color(0xFF007f5f),
                                  child: Icon(Icons.view_headline,
                                      color: Colors.white),
                                ),
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
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ExtendedImageExample(
                                        editImage: link,
                                        ind: index,
                                      )),
                                      (route) => false);
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xFF007f5f),
                                  child: Icon(Icons.brightness_6,
                                      color: Colors.white),
                                ),
                                Text("Brightness")
                              ],
                            )),
                        GestureDetector(
                            onTap: () async {
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
                                CircleAvatar(
                                  backgroundColor: Color(0xFF007f5f),
                                  child: Icon(Icons.rotate_90_degrees_ccw,
                                      color: Colors.white),
                                ),
                                Text("Rotate")
                              ],
                            )),
                        GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Select Conversiong Type"),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                    content: Center(
                                                        child:
                                                            CircularProgressIndicator()));
                                              },
                                            );
                                            // jpg2png(link, context, index);
                                          },
                                          child: Container(
                                              height: 40,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.blue),
                                              child: Center(
                                                  child: Text(
                                                "JPG To PNG",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      elevation: 0,
                                                      content: Center(
                                                          child:
                                                              CircularProgressIndicator()));
                                                },
                                              );
                                              // png2jpg(link, context, index);
                                            },
                                            child: Container(
                                                height: 40,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Colors.blue),
                                                child: Center(
                                                    child: Text("PNG To JPG",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white))))),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xFF007f5f),
                                  child: Icon(Icons.image, color: Colors.white),
                                ),
                                Text("Conversion")
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              ));
        });
      });
}
