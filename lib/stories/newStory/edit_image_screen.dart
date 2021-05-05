import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/stories/util/new_status_util.dart';
import 'package:vocal/main/navigation/navigation_home_screen.dart';
import 'package:vocal/res/global_data.dart';

class EditImageScreen extends StatefulWidget {
  final String id;
  final String resource;
  final Uint8List uint;
  final bool isPath;

  EditImageScreen({this.id, this.resource, this.uint, this.isPath});

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  File file;

  @override
  void initState() {
    if (widget.isPath) {
      file = File(widget.resource);
    } else {
      file = File.fromRawPath(widget.uint);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        actions: <Widget>[
          Builder(builder: (_context) => IconButton(
            icon: Icon(
              Icons.check,
              size: 32,
            ),
            color: colorScheme.primary,
            onPressed: () {
              onStatusCreate(_context, context);
            },
          ),),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height - 220.0,
            child: Hero(
              tag: widget.id,
              child: Image.file(file),
            ),
          )
        ],
      ),
    );
  }

  onStatusCreate(_context, context) async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: new Text("Uploading"),
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
