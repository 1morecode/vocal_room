import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:vocal/main/navigation/navigation_home_screen.dart';
import 'package:vocal/res/global_data.dart';
import 'package:vocal/stories/util/new_status_util.dart';

class CropImageScreen extends StatefulWidget {
  final String id;
  final String resource;

  CropImageScreen({this.id, this.resource});

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final cropKey = GlobalKey<CropState>();
  File file;
  File _file;

  @override
  void initState() {
    file = File(widget.resource);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return _file != null
          ? Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leadingWidth: 100,
          leading: CupertinoButton(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: new Text("Undo"),
            onPressed: () {
              setState(() {
                _file = null;
              });
            },
          ),
          elevation: 0.0,
          actions: <Widget>[
            Builder(builder: (_context) => CupertinoButton(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: new Text("Create"),
              onPressed: () {
                onStatusCreate(_context, context);
              },
            ),),
          ],
        ),
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Hero(
              tag: widget.id,
              child: Image.file(_file, fit: BoxFit.contain, width: MediaQuery.of(context).size.width,),
            ),
          ),
        ),
      )
          : Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: CupertinoButton(
          padding: EdgeInsets.all(5),
          child: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0.0,
        actions: <Widget>[
          Builder(builder: (_context) => CupertinoButton(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: new Text("Crop"),
            onPressed: () {
              _cropImage();
            },
          ),),
        ],
      ),
      body: SafeArea(
        child: _buildCroppingImage(),
      ),
    );
  }

  Widget _buildCroppingImage() {
    return Crop.file(file, key: cropKey);
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: file,
      preferredSize: (2000 / scale).round(),
    );

    final ff = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();

    setState(() {
      _file = ff;
    });

    debugPrint('E $file');
  }

  onStatusCreate(_context, context) async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: new Text("Creating"),
        content: Center(child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: new CircularProgressIndicator(),
        ),),
      ),
    );
    if (file != null) {
      bool status = await NewStatusUtil.createNewStatus(context, file);
      Navigator.of(context).pop();
      if (status) {
        GlobalData.showSnackBar(
            "Status created successfully!", _context, Colors.black);
        Timer(Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationHomeScreen(),
              ),
                  (route) => false);
        });
      } else {
        GlobalData.showSnackBar(
            "Failed to Upload Status!", _context, Colors.red);
      }
    } else {
      GlobalData.showSnackBar("Please select file!", _context, Colors.red);
    }
  }
}
