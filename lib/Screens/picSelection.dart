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

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path_provider/path_provider.dart';

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

class PicEdit extends StatefulWidget {
  String picUrl;
  int index;
  bool merge;
  PicEdit(
      {Key key,
      @required this.picUrl,
      @required this.index,
      @required this.merge})
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
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);
    print(widget.picUrl);
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  // final String _fileUrl = "http://lot.services/blog/files/DSCF0277.jpg";
  //
  static DateTime net = DateTime.now();
  final String _fileName = net.toString();
  final Dio _dio = Dio();

  String _progress = "-";

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.High, importance: Importance.Max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android, iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }

  Future<Directory> _getDownloadDirectory() async {
    return await getExternalStorageDirectory();
  }

  Future<bool> _requestPermissions() async {
    var permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }

    return permission == PermissionStatus.granted;
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + "%";
      });
    }
  }

  Future<void> _startDownload(String savePath) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(widget.picUrl, savePath,
          onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      await _showNotification(result);
    }
  }

  Future<void> _download() async {
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();

    if (isPermissionStatusGranted) {
      final savePath = path.join(dir.path, _fileName + '.jpg');
      await _startDownload(savePath);
    } else {
      // handle the scenario when user declines the permissions
    }
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
                  widget.merge != true
                      ? GestureDetector(
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
                          ))
                      : SizedBox(height: 0, width: 0),
                  SizedBox(width: 20),
                  GestureDetector(
                      onTap: () async {
                        Fluttertoast.showToast(
                            msg: "Please Wait",
                            toastLength: Toast.LENGTH_SHORT);
                        _download();
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
        // child: Center(
        //     child: PinchZoomImage(
        //   image: Image.network(
        //     widget.picUrl.toString(),
        //   ),
        //   zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
        //   hideStatusBarWhileZooming: true,
        // )),
      )),
    );
  }
}
