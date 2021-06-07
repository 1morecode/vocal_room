
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/chat/model/chet_user.dart';
import 'package:vocal/modules/chat/model/conver.dart';
import 'package:vocal/modules/chat/searchUsers/search_users_page.dart';
import 'package:vocal/modules/chat/widget/conver_list_widget.dart';

class HomeBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final List<Convo> _convos = Provider.of<List<Convo>>(context);
    final List<ChatUser> _users = Provider.of<List<ChatUser>>(context);
    return Scaffold(

        body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: getWidgets(context, firebaseAuth.currentUser, _convos, _users)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: new Icon(Icons.search_rounded),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchUsersPage(),));
        },
      ),
    );
  }

  // void createNewConvo(BuildContext context) {
  //   Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
  //       builder: (BuildContext context) => NewMessageProvider()));
  // }

  Map<String, ChatUser> getUserMap(List<ChatUser> users) {
    final Map<String, ChatUser> userMap = Map();
    for (ChatUser u in users) {
      userMap[u.id] = u;
    }
    return userMap;
  }

  List<Widget> getWidgets(
      BuildContext context, User user, List<Convo> _convos, List<ChatUser> _users) {
    print("USERS $user, $_convos, $_users");
    final List<Widget> list = <Widget>[];
    if (_convos != null && _users != null && user != null) {
      if(_convos.length > 0 && _users.length > 0){
        final Map<String, ChatUser> userMap = getUserMap(_users);
        for (Convo c in _convos) {
          if (c.userIds[0] == user.uid) {
            list.add(ConvoListItem(
                user: user,
                peer: userMap[c.userIds[1]],
                lastMessage: c.lastMessage));
          } else {
            list.add(ConvoListItem(
                user: user,
                peer: userMap[c.userIds[0]],
                lastMessage: c.lastMessage));
          }
        }
      }
    }

    return list;
  }
}
