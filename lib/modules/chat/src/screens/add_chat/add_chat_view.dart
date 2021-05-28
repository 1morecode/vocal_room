
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/modules/chat/src/screens/add_chat/add_chat_controller.dart';
import 'package:vocal/modules/chat/src/widgets/custom_app_bar.dart';
import 'package:vocal/modules/chat/src/widgets/user_card.dart';

class AddChatScreen extends StatefulWidget {

  @override
  _AddChatScreenState createState() => _AddChatScreenState();
}

class _AddChatScreenState extends State<AddChatScreen> {
  AddChatController _addChatController;

  @override
  void initState() {
    super.initState();
    _addChatController = AddChatController(
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return StreamBuilder<Object>(
        stream: _addChatController.streamController.stream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: CustomAppBar(
              title: Text('New chat', style: TextStyle(color: colorScheme.onSecondary),),
            ),
            body: renderUsers(context),
          );
        });
  }

  Widget renderUsers(context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (_addChatController.loading) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    // if (_addChatController.error) {
    //   return Center(
    //     child: Text('There was an error fetching users.'),
    //   );
    // }
    if (_addChatController.users.length == 0) {
      return Center(
        child: Text('No users found'),
      );
    }
    return ListView.builder(
      itemCount: 1,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: _addChatController.users.map((user) {
            return Column(
              children: <Widget>[
                UserCard(
                  user: user,
                  onTap: _addChatController.newChat,
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
