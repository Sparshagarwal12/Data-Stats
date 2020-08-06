import 'dart:io' as Io;
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart' hide ImageSource;
import 'package:internship/Screens/picSelection.dart';

class ExtendedImageExample extends StatefulWidget {
  final imagePath;
  dynamic editImage;
  int ind;
  ExtendedImageExample(
      {Key key, @required this.editImage, @required this.ind, this.imagePath})
      : super(key: key);
  @override
  _ExtendedImageExampleState createState() => _ExtendedImageExampleState();
}

class _ExtendedImageExampleState extends State<ExtendedImageExample> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  ImageProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ExtendedNetworkImageProvider(widget.editImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF007f5f),
        title: const Text('Scan Karo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              await crop();
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: buildImage(),
            ),
            Expanded(
              child: SliderTheme(
                data: const SliderThemeData(
                  showValueIndicator: ShowValueIndicator.always,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height / 9),
                    _buildSat(),
                    _buildBrightness(),
                    _buildCon(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return ExtendedImage(
      image: provider,
      extendedImageEditorKey: editorKey,
      mode: ExtendedImageMode.editor,
      fit: BoxFit.contain,
      initEditorConfigHandler: (ExtendedImageState state) {
        return EditorConfig(
          cornerColor: Colors.transparent,
        );
      },
    );
  }

  Future<void> crop() async {
    final ExtendedImageEditorState state = editorKey.currentState;
    final Uint8List img = state.rawImageData;

    final ImageEditorOption option = ImageEditorOption();

    option.addOption(ColorOption.saturation(sat));
    option.addOption(ColorOption.brightness(bright));
    option.addOption(ColorOption.contrast(con));
    final Uint8List result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    // print('result.length = ${result.length}');
    final tempDir = await getTemporaryDirectory();
    final file = await new Io.File('${tempDir.path}/image.jpg').create();
    // file.writeAsBytesSync(result);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Center(child: CircularProgressIndicator()));
      },
    );
    uploadPic(file);
  }

  uploadPic(Io.File file) async {
    final bytes = Io.File(file.path).readAsBytesSync();

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
              builder: (context) =>
                  PicEdit(picUrl: mod["URL"], index: widget.ind, merge: false)),
          (route) => false);
    });
  }

  double sat = 7;
  double bright = 1;
  double con = 6;

  Widget _buildSat() {
    return Slider(
      activeColor: Color(0xFF007f5f),
      inactiveColor: Color(0xFF007f5f),
      label: 'sat : ${sat.toStringAsFixed(2)}',
      onChanged: (double value) {
        setState(() {
          sat = value;
        });
      },
      value: sat,
      min: 0,
      max: 10,
    );
  }

  Widget _buildBrightness() {
    return Slider(
      activeColor: Color(0xFF007f5f),
      inactiveColor: Color(0xFF007f5f),
      label: 'brightness : ${bright.toStringAsFixed(2)}',
      onChanged: (double value) {
        setState(() {
          bright = value;
        });
      },
      value: bright,
      min: 0,
      max: 2,
    );
  }

  Widget _buildCon() {
    return Slider(
      activeColor: Color(0xFF007f5f),
      inactiveColor: Color(0xFF007f5f),
      label: 'con : ${con.toStringAsFixed(2)}',
      onChanged: (double value) {
        setState(() {
          con = value;
        });
      },
      value: con,
      min: 0,
      max: 10,
    );
  }
}
