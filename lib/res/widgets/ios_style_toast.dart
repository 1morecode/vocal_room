import 'package:flutter/material.dart';

class IosStyleToast extends StatefulWidget {
  final String message;

  IosStyleToast(this.message);

  @override
  _IosStyleToastState createState() => _IosStyleToastState();
}

class _IosStyleToastState extends State<IosStyleToast> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    Text(widget.message.isNotEmpty ? '${widget.message}': 'Success')
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}