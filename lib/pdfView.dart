import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

import 'package:fluttertoast/fluttertoast.dart';

class PdfView extends StatefulWidget {
  String url;
  PdfView({Key key, @required this.url}) : super(key: key);
  @override
  _PdfView createState() => _PdfView();
}

class _PdfView extends State<PdfView> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    // loadDocument();
    changePDF();
  }

  changePDF() async {
    setState(() => _isLoading = true);
    document = await PDFDocument.fromURL(widget.url);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF007f5f),
        title: const Text('FlutterPluginPDFViewer'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "Functionality Left",
                        toastLength: Toast.LENGTH_SHORT);
                  },
                  child: Icon(
                    Icons.file_download,
                    size: 30,
                  )))
        ],
      ),
      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: document)),
    );
  }
}
