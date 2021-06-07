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
        5,
        5,
        10,
      ),
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(),));
        },
        child: new Container(
          height: 100,
          alignment: Alignment.center,
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
                    foregroundColor: colorScheme.onSecondary,
                    backgroundImage: NetworkImage(
                        "https://support.meetpolaroid.com/hc/article_attachments/360001501028/snap-app.png",)),
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
