import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class EditImageScreen extends StatefulWidget {
  final String id;
  final String resource;
  final Uint8List uint;
  final bool isPath;

  EditImageScreen({
    this.id,
    this.resource,
    this.uint,
    this.isPath
  });

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
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
          IconButton(
            icon: Icon(Icons.check, size: 32,),
            color: colorScheme.primary,
            onPressed: () {},
          ),
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
              child: widget.isPath ? Image.file(new File(widget.resource)) : Image.memory(widget.uint),
            ),
          )
        ],
      ),
    );
  }
}