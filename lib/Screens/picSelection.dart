import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:internship/Screens/Features.dart';
import 'package:internship/bottomSheet.dart';
import 'package:flutter/cupertino.dart';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';




class PicEdit extends StatefulWidget {
  String picUrl;
  int index;
  PicEdit({Key key, @required this.picUrl, @required this.index})
      : super(key: key);
  @override
  _PicEdit createState() => _PicEdit();
}

class _PicEdit extends State<PicEdit> {
  ScrollController scrollController;
  String progress = "0";
  bool dialVisible = true;
  @override
  void initState() {
    print(widget.picUrl);
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  String imageId;
  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      backgroundColor: Color(0xFF007f5f),
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.brush, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () {
            settingModalBottomSheet(context, widget.picUrl, widget.index);
          },
          label: 'Edits',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
            child: Icon(Icons.share, color: Colors.white),
            backgroundColor: Colors.blue,
            onTap: () async {
              Fluttertoast.showToast(
                  msg: "Share", toastLength: Toast.LENGTH_SHORT);
              var request = await HttpClient()
                  .getUrl(Uri.parse(widget.picUrl.toString()));
              var response = await request.close();
              Uint8List bytes =
                  await consolidateHttpClientResponseBytes(response);
              await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
            },
            label: 'Share',
            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            labelBackgroundColor: Colors.blue),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doc Scanner"),
        backgroundColor: Color(0xFF007f5f),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => Editor(
                                    link: widget.picUrl,
                                    edit: "yes",
                                    place: widget.index)),
                            (route) => false);
                      },
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 30,
                      )),
                  SizedBox(width: 20),
                  GestureDetector(
                      onTap: () async {
                        imageId =
                            await ImageDownloader.downloadImage(widget.picUrl);
                        Fluttertoast.showToast(
                            msg: "Please Wait",
                            toastLength: Toast.LENGTH_SHORT);
                      },
                      child: Icon(
                        Icons.file_download,
                        size: 30,
                      ))
                ],
              ))
        ],
      ),
      floatingActionButton: buildSpeedDial(),
      body: Container(
          child: Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(image: NetworkImage(widget.picUrl.toString()))),
        // child: Text(widget.picUrl.toString()),
      )),
    );
  }
}
