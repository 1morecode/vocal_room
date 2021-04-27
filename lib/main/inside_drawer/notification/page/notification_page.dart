import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/main/inside_drawer/notification/modal/notification_modal.dart';
import 'package:vocal/main/navigation/my_drawer_button.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: MyDrawerButton(),
        middle: Text(
          "Notification",
          style: TextStyle(color: colorScheme.primary),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: false,
          itemBuilder: (context, i) {
            return Card(
              elevation: 1.0,
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.bell_fill,
                      size: 30.0,
                      color: colorScheme.primary,
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("${NotificationUtil.notificationList[i].title}"),
                          Text(
                            "${NotificationUtil.notificationList[i].subtitle}",
                            style: TextStyle(fontWeight: FontWeight.w300),
                            maxLines: 3,
                          ),
                          Text(
                            "${NotificationUtil.notificationList[i].subtitle}",
                            style: TextStyle(fontWeight: FontWeight.w300),
                            maxLines: 3,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: NotificationUtil.notificationList.length,
        ),
      ),
    );
  }
}
