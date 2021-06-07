
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/chat/chat_list_builder.dart';
import 'package:vocal/modules/chat/database/database.dart';
import 'package:vocal/modules/chat/model/chet_user.dart';
import 'package:vocal/modules/chat/model/conver.dart';

class ChatHomePage extends StatelessWidget {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Convo>>.value(
      initialData: [],
        value: Database.streamConversations(firebaseAuth.currentUser.uid),
        child: ConversationDetailsProvider(user: firebaseAuth.currentUser));
  }
}

class ConversationDetailsProvider extends StatelessWidget {
  const ConversationDetailsProvider({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ChatUser>>.value(
      initialData: [],
        value: Database.getUsersByList(
            getUserIds(Provider.of<List<Convo>>(context))),
        child: HomeBuilder());
  }

  List<String> getUserIds(List<Convo> _convos) {
    final List<String> users = <String>[];
    if (_convos != null) {
      for (Convo c in _convos) {
        c.userIds[0] != user.uid
            ? users.add(c.userIds[0])
            : users.add(c.userIds[1]);
      }
    }
    return users;
  }
}