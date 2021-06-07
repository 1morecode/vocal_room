import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/mainPage/profile/user_profile_page.dart';
import 'package:vocal/modules/chat/details/views/chat_screen.dart';
import 'package:vocal/modules/chat/model/chet_user.dart';

class UserDetails extends StatelessWidget {
  final ChatUser document;

  UserDetails({Key key, @required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: CupertinoButton(
          child: Row(
            children: <Widget>[
              document.image != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: colorScheme.onSurface
                    ),
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onSurface),
                    ),
                    width: 35.0,
                    height: 35.0,
                  ),
                  imageUrl: document.image,
                  width: 35.0,
                  height: 35.0,
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(
                Icons.account_circle,
                size: 35.0,
                color: colorScheme.secondaryVariant,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${document.name}',
                          style: TextStyle(color: colorScheme.onSecondary, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'Last Seen',
                          style: TextStyle(color: colorScheme.secondaryVariant, fontSize: 10, fontWeight: FontWeight.w400),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage(document.id),));
          },
          padding: EdgeInsets.all(0),
        ),
        centerTitle: false,
      ),
      body: ChatScreen(
        peerId: document.id,
        peerAvatar: document.image,
      ),
    );
  }
}
