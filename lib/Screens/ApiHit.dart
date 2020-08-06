import 'package:flutter/cupertino.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:internship/Screens/picSelection.dart';
import 'dart:convert';
import 'package:internship/pdfView.dart';

import 'package:internship/Screens/Features.dart';

void base2url(String link, BuildContext context) async {
  String url = "https://cam-scanner.herokuapp.com/bs2url";
  var body = {"BASE64": link};
  Response r = await post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  print(r.body);
  dynamic mod = json.decode(r.body);
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) => Editor(link: mod["URL"], edit: "no", place: 0)),
      (route) => false);
}

void removeShadow(String link, BuildContext context, int number) async {
  String name = "SADAD";
  String url = "https://cam-scanner.herokuapp.com/remove_shadow";
  var body = {"URL": link, "Name": name};
  Response r = await post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  print(r.body);
  dynamic mod = json.decode(r.body);
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) => PicEdit(
                picUrl: mod["URL"],
                index: number,
                merge: false,
              )),
      (route) => false);
}

void addTextTop(String link, BuildContext context, String top, String bot,
    int number) async {
  String url = 'https://cam-scanner.herokuapp.com/text_on_image';
  var body = {"URL": link, "TOP": top, "BOTTOM": bot};
  Response r = await post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  dynamic mod = json.decode(r.body);
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) =>
              PicEdit(picUrl: mod["URL"], index: number, merge: false)),
      (route) => false);
}

void watermarkBot(
    String link, BuildContext context, int number, String text) async {
  String url = 'https://cam-scanner.herokuapp.com/watermark_at_bottom';
  var body = {
    "URL": link,
    "Size": 33,
    "Text": text,
  };
  Response r = await post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  dynamic mod = json.decode(r.body);
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) =>
              PicEdit(picUrl: mod["URL"], index: number, merge: false)),
      (route) => false);
}

void watermarkMid(
    String link, BuildContext context, int number, String text) async {
  String url = 'https://cam-scanner.herokuapp.com/watermark_in_middle';
  var body = {"URL": link, "Text": text, "Font_Scale": 2};
  Response r = await post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  dynamic mod = json.decode(r.body);
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) =>
              PicEdit(picUrl: mod["URL"], index: number, merge: false)),
      (route) => false);
}

void addHead(String link, BuildContext context, String head, int number) async {
  String url = 'https://cam-scanner.herokuapp.com/Heading_on_image';
  var body = {"URL": link, "Text": head};
  Response r = await post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  print(r.body);
  dynamic mod = json.decode(r.body);
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) => PicEdit(
                picUrl: mod["URL"],
                index: number,
                merge: false,
              )),
      (route) => false);
}

void img2scan(
    String link, BuildContext context, String head, int number) async {
  String url = 'https://cam-scanner.herokuapp.com/img2scan';
  var body = {"URL": link};
  Response r = await post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  print(r.body);
  dynamic mod = json.decode(r.body);
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) => PicEdit(
                picUrl: mod["URL"],
                index: number,
                merge: false,
              )),
      (route) => false);
}
