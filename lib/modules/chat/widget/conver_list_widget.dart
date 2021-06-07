import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vocal/modules/chat/database/database.dart';
import 'package:vocal/modules/chat/details/user_details.dart';
import 'package:vocal/modules/chat/model/chet_user.dart';

class ConvoListItem extends StatelessWidget {
  ConvoListItem(
      {Key key,
        @required this.user,
        @required this.peer,
        @required this.lastMessage})
      : super(key: key);

  final User user;
  final ChatUser peer;
  Map<dynamic, dynamic> lastMessage;

  BuildContext context;
  // String groupId;
  bool read;

  @override
  Widget build(BuildContext context) {
    if (lastMessage['idFrom'] == user.uid) {
      read = true;
    } else {
      read = lastMessage['read'] == null ? true : lastMessage['read'];
    }
    this.context = context;
    // groupId = getGroupChatId();

    return buildContent(context);
  }

  Widget buildContent(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.only(bottom: 1.0),
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        borderRadius: BorderRadius.circular(0),
        color: colorScheme.onPrimary,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => UserDetails(
                  document: peer,)));
        },
        child: buildConvoDetails(peer, context),
      ),
    );
  }

  Widget buildConvoDetails(ChatUser chatUser, BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            chatUser.image != null
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
                  width: 50.0,
                  height: 50.0,
                  padding: EdgeInsets.all(15.0),
                ),
                imageUrl:  chatUser.image,
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
            )
                : Icon(
              Icons.account_circle,
              size: 50.0,
              color: colorScheme.secondaryVariant,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${chatUser.name}',
                        style: TextStyle(color: colorScheme.onSecondary, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            lastMessage['type'] == 1 ? lastMessage['idTo'] != "${chatUser.id}" ? 'Image File' : 'You: Image File' :
                            lastMessage['type'] == 2 ? lastMessage['idTo'] != "${chatUser.id}" ? 'Emoji' : 'You: Emoji' :
                            lastMessage['idTo'] != "${chatUser.id}" ? '${lastMessage['content']}' : 'You: ${lastMessage['content']}',
                            style: TextStyle(color: colorScheme.secondaryVariant, fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          // child: FutureBuilder(
                          //   future: Database.getLastMessage(getGroupChatId()),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.hasData) {
                          //       return Text(
                          //         snapshot.data['idTo'] != "${chatUser.id}" ? '${snapshot.data['content']}' : 'You: ${snapshot.data['content']}',
                          //         style: TextStyle(color: colorScheme.secondaryVariant, fontSize: 14, fontWeight: FontWeight.w400),
                          //       );
                          //     } else {
                          //       return new Container();
                          //     }
                          //   },
                          // ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        ),
                        new Text("${getTime(lastMessage['timestamp'])}", style: TextStyle(color: colorScheme.secondaryVariant, fontSize: 10, fontWeight: FontWeight.w400),)
                      ],
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 5.0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String getTime(String timestamp) {
    DateTime dateTime =
    DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    DateFormat format;
    if (dateTime.difference(DateTime.now()).inMilliseconds <= 86400000) {
      format = DateFormat('jm');
    } else {
      format = DateFormat.yMd('en_US');
    }
    return format
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  }

  String getGroupChatId() {
    if (user.uid.hashCode <= peer.id.hashCode) {
      return user.uid + '_' + peer.id;
    } else {
      return peer.id + '_' + user.uid;
    }
  }
}
