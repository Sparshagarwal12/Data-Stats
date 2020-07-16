import 'package:flutter/cupertino.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:internship/Screens/picSelection.dart';
import 'package:internship/Screens/video.dart';
import 'dart:convert';
import 'package:internship/pdfView.dart';

import 'package:internship/Screens/Features.dart';

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
  // Navigator.push(
  //     context, MaterialPageRoute(builder: (context) => Editor(link: r.body)));
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) => PicEdit(
                picUrl: r.body,
                index: number,
              )),
      (route) => false);
}

void addTextTop(
    String link, BuildContext context, String text,int number) async {
  String url = 'https://dankcli-api.herokuapp.com/meme-gen';
  var body = {"URL": link, "TOP": text, "BOTTOM": ""};
  Response r = await post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  print(r.body);
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) => PicEdit(
                picUrl: r.body,
                index: number,
              )),
      (route) => false);
}

void addTextBottom(
    String link, BuildContext context, String text, int number) async {
  String url = 'https://dankcli-api.herokuapp.com/meme-gen';

  var body = {"URL": link, "TOP": "", "BOTTOM": text};

  Response r = await post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  print(r.body);
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) => PicEdit(
                picUrl: r.body,
                index: number,
              )),
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
  print(head);
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) => PicEdit(
                picUrl: r.body,
                index: number,
              )),
      (route) => false);
}

void resize(String link, BuildContext context, String choice, int height,
    int width) async {
  String url = 'https://cam-scanner.herokuapp.com/resize';
  var body = {"URL": link, "Choice": choice, "Height": height, "Width": width};
  Response r = await post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  print(r.body);
  // Navigator.push(
  // context, MaterialPageRoute(builder: (context) => Editor(link: r.body)));
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) => Editor(link: r.body, edit: "no", place: 0)),
      (route) => false);
}

void pdf(List<String> link, BuildContext context) async {
  String url = 'https://cam-scanner.herokuapp.com/PDF';
  var body = {"URL": link};
  Response r = await post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  print(r.body);
  // Navigator.push(
  // context, MaterialPageRoute(builder: (context) => Editor(link: r.body)));
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
          builder: (context) => PdfView(
                url: r.body,
              )),
      (route) => false);
}
