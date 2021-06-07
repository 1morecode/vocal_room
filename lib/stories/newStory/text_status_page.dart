import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:vocal/stories/newStory/edit_image_screen.dart';
import 'package:path_provider/path_provider.dart';

class TextStatusPage extends StatefulWidget {
  @override
  _TextStatusPageState createState() => _TextStatusPageState();
}

class _TextStatusPageState extends State<TextStatusPage> {
  TextEditingController _textController = new TextEditingController();
  GlobalKey _globalKey = new GlobalKey();
  ColorSwatch _tempMainColor = Colors.cyan;

  Future<Uint8List> _captureImage() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new AppBar(
        toolbarHeight: 1,
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: _textController.text.isEmpty ? null : FloatingActionButton(
        backgroundColor: colorScheme.onPrimary,
        child: new Icon(CupertinoIcons.arrow_right),
        onPressed: () async{
          FocusScope.of(context).unfocus();
          Timer(Duration(seconds: 1), () async{
            Uint8List base = await _captureImage();
            String path = await _createFileFromString(base);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CropImageScreen(
                        id: "itemPanel-0",
                        resource: path,
                      ),
                ));
          });
        },
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          color: _tempMainColor,
          child: new Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new CupertinoButton(child: Icon(Icons.close, color: colorScheme.primary,), onPressed: (){
                      Navigator.of(context).pop();
                    }, padding: EdgeInsets.all(5), color: colorScheme.onSurface.withOpacity(0.5),),
                    new CupertinoButton(child: Icon(CupertinoIcons.color_filter, color: colorScheme.primary,), onPressed: (){
                      FocusScope.of(context).unfocus();
                      displayColorDialog(context);
                    }, padding: EdgeInsets.all(5), color: colorScheme.onSurface.withOpacity(0.5),)
                  ],
                ),
              ),
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  width: size.width,
                  height: size.height * 0.8,
                  color: _tempMainColor,
                  alignment: Alignment.center,
                  child: Center(
                    child: AutoSizeTextField(
                      textAlign: TextAlign.center,
                      fullwidth: false,
                      autofocus: true,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      maxLines: 15,
                      minLines: 1,
                      controller: _textController,
                      minFontSize: 12,
                      style: TextStyle(fontSize: 64),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> displayColorDialog(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            title: Text(
              "Choose Background Color",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.secondaryVariant),
            ),
            actions: [
              CupertinoButton(child: new Text("Done"), onPressed: (){
                Navigator.of(context).pop();
              })
            ],
            content: MaterialColorPicker(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              circleSize: 50,
              allowShades: false,
              selectedColor: _tempMainColor,
              onMainColorChange: (color) => setState(() => _tempMainColor = color),
            ),
          );
        });
  }

  Future<String> _createFileFromString(Uint8List bytes) async {
    // final encodedStr = "...";
    // Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fullPath = '$dir/${DateTime.now().toString()}.png';
    print("local file full path $fullPath");
    File file = File(fullPath);
    await file.writeAsBytes(bytes);
    print(file.path);

    final result = await ImageGallerySaver.saveImage(bytes);
    print(result);

    return file.path;
  }
}
