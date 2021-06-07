
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vocal/modules/chat/model/chet_user.dart';
import 'package:vocal/modules/chat/searchUsers/widget/user_search_card.dart';
import 'package:vocal/modules/chat/widget/loading.dart';

class SearchUsersPage extends StatefulWidget {
  const SearchUsersPage({Key key}) : super(key: key);

  @override
  _SearchUsersPageState createState() => _SearchUsersPageState();
}

class _SearchUsersPageState extends State<SearchUsersPage> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final ScrollController listScrollController = ScrollController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController textEditingController = new TextEditingController();
  List<dynamic> users = [];

  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  getUsers(val) async {
    print("Start");
    try {
      QuerySnapshot streamQuery = await FirebaseFirestore.instance
          .collection('allUsers')
          .limit(_limit)
          .get();
      print("All USERS  ${streamQuery.docs.toList()}");
      users.clear();
      users = streamQuery.docs.toList();
      print("SUERS $users $val");
      setState(() {
        users = users
            .where(
                (s) => s['nickname'].toLowerCase().contains(val.toLowerCase()))
            .toList();
      });
    } catch (err) {
      print("ERR $err");
    }
    print("New SUERS $users");
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: new AppBar(
        title: new CupertinoButton(
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(),));
          },
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: new Container(
            height: 40,
            child: CupertinoSearchTextField(
              controller: textEditingController,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: colorScheme.onSurface),
              onSubmitted: (val) {
                if (val.isNotEmpty) {
                  getUsers("$val");
                }else{
                  users.clear();
                }
              },
              onChanged: (val){
                if (val.length > 0) {
                  getUsers("$val");
                }else{
                  users.clear();
                }
              },
              placeholder: "Search here...",
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          // List
          ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 5),
            itemBuilder: (context, index) => buildItem(context, users[index]),
            itemCount: users.length,
            controller: listScrollController,
          ),

          // Loading
          Positioned(
            child: isLoading ? const Loading() : Container(),
          )
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document.data()['id'] == firebaseAuth.currentUser.uid) {
      return Container();
    } else {
      ChatUser chatUser = new ChatUser(image: document.data()['photoUrl'], id: document.id, name: document.data()['nickname']);
      return UserSearchCard(
        document: chatUser,
      );
    }
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
