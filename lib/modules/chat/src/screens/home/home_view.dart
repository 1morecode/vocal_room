import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/chat/src/data/local_database/db_provider.dart';
import 'package:vocal/modules/chat/src/data/providers/chats_provider.dart';
import 'package:vocal/modules/chat/src/screens/add_chat/add_chat_view.dart';
import 'package:vocal/modules/chat/src/screens/home/home_controller.dart';
import 'package:vocal/modules/chat/src/widgets/chat_card.dart';
import 'package:vocal/modules/chat/src/widgets/custom_app_bar.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({Key key}) : super(key: key);

  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  ChatHomeController _homeController;

  @override
  void initState() {
    super.initState();
    DBProvider.db.database;
    _homeController = ChatHomeController(context: context);
  }

  @override
  void dispose() {
    _homeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _homeController.initProvider();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return StreamBuilder<Object>(
      stream: _homeController.streamController.stream,
      builder: (context, snapshot) {
        return Scaffold(
          body: SafeArea(
            child: _homeController.loading
                ? Text(
                    'Connecting...',
                    style: TextStyle(color: colorScheme.onSecondary),
                  )
                : usersList(context),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddChatScreen(),));
            },
            backgroundColor: colorScheme.primary,
            child: Icon(
              Icons.search,
              color: colorScheme.onPrimary,
            ),
          ),
        );
      },
    );
  }

  Widget usersList(BuildContext context) {
    // if (_homeController.loading) {
    //   return SliverFillRemaining(
    //     child: Center(
    //       child: CupertinoActivityIndicator(),
    //     ),
    //   );
    // }
    // if (_homeController.error) {
    //   return SliverFillRemaining(
    //     child: Center(
    //       child: Text('Ocorreu um erro ao buscar suas conversas.'),
    //     ),
    //   );
    // }
    if (_homeController.chats.length == 0) {
      return Center(
        child: Text('You have no conversations.'),
      );
    }
    bool theresChatsWithMessages = _homeController.chats.where((chat) {
          return chat.messages.length > 0;
        }).length >
        0;
    if (!theresChatsWithMessages) {
      return Center(
        child: Text('You have no conversations.'),
      );
    }
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: _homeController.chats.map((chat) {
            if (chat.messages.length == 0) {
              return Container(height: 0, width: 0);
            }
            return Column(
              children: <Widget>[
                ChatCard(
                  chat: chat,
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
