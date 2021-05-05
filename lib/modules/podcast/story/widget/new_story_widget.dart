import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/stories/newStory/camera_page.dart';

class NewStoryButton extends StatefulWidget {
  @override
  _NewStoryButtonState createState() => _NewStoryButtonState();
}

class _NewStoryButtonState extends State<NewStoryButton> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(
        5,
        0,
        5,
        10,
      ),
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(),));
        },
        child: new Container(
          width: 80,
          child: Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.primary, width: 2)),
                child: CircleAvatar(
                    radius: 32,
                    backgroundColor: colorScheme.onPrimary,
                    backgroundImage: NetworkImage(
                        "https://media.istockphoto.com/vectors/colorful-camera-symbol-in-gradient-color-on-dark-background-camera-vector-id1134816336?k=6&m=1134816336&s=612x612&w=0&h=kNLu88vbYiMbC2M1DExgdEcYgUkksK7-Q3MzqigJLDU=")),
              ),
              new SizedBox(
                height: 5,
              ),
              Text(
                "Create New",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: colorScheme.onSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
