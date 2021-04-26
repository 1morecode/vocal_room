import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:vocal/libraries/new/edit_image_screen.dart';

class TextStatusPage extends StatefulWidget {
  @override
  _TextStatusPageState createState() => _TextStatusPageState();
}

class _TextStatusPageState extends State<TextStatusPage> {
  TextEditingController _textController = new TextEditingController();
  GlobalKey _globalKey = new GlobalKey();
  ColorSwatch _tempMainColor = Colors.redAccent;

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
      resizeToAvoidBottomInset: false,
      floatingActionButton: _textController.text.isEmpty ? null : FloatingActionButton(
        backgroundColor: colorScheme.onPrimary,
        child: new Icon(CupertinoIcons.arrow_right),
        onPressed: () async{
          FocusScope.of(context).unfocus();
          Timer(Duration(seconds: 1), () async{
            Uint8List base = await _captureImage();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditImageScreen(
                        id: "itemPanel-0",
                        uint:
                        base,
                        isPath: false,
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
                padding: const EdgeInsets.all(10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new CupertinoButton(child: Icon(CupertinoIcons.back, color: colorScheme.primary,), onPressed: (){
                      Navigator.of(context).pop();
                    }, padding: EdgeInsets.all(5), color: colorScheme.onSurface,),
                    new CupertinoButton(child: Icon(CupertinoIcons.color_filter, color: colorScheme.primary,), onPressed: (){
                      FocusScope.of(context).unfocus();
                      displayColorDialog(context);
                    }, padding: EdgeInsets.all(5), color: colorScheme.onSurface,)
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
}
