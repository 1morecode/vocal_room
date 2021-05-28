import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/chat/src/data/models/chat.dart';
import 'package:vocal/modules/chat/src/data/providers/chats_provider.dart';
import 'package:vocal/modules/chat/src/screens/contact/contact_view.dart';
import 'package:vocal/modules/chat/src/utils/dates.dart';

class ChatCard extends StatelessWidget {
  final Chat chat;

  final format = new DateFormat("HH:mm");

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.lightBlue,
    Colors.purple,
    Colors.black,
    Colors.cyan,
  ];

  final rng = new Random();

  ChatCard({
    @required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    initializeDateFormatting('pt_BR', null);
    return Container(
      child: CupertinoButton(
        borderRadius: BorderRadius.circular(0),
        padding: EdgeInsets.all(0),
        color: colorScheme.onPrimary,
        onPressed: () {
          ChatsProvider _chatsProvider =
              Provider.of<ChatsProvider>(context, listen: false);
          _chatsProvider.setSelectedChat(chat);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ContactScreen(),));
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            top: 10,
            bottom: 0,
          ),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      "${chat.user.picture}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  radius: 20,
                  backgroundColor: colorScheme.primary,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 2,
                    ),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Text(
                                      chat.user.name,
                                      style: TextStyle(
                                        color: colorScheme.onSecondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      chat.messages[0].message,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colorScheme.secondaryVariant
                                      ),
                                      maxLines: 2,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15, left: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      UtilDates.getSendAtDayOrHour(chat.messages[0].sendAt),
                                      style: TextStyle(
                                        color: _numberOfUnreadMessagesByMe() > 0
                                            ? colorScheme.primary
                                            : colorScheme.secondaryVariant,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    unreadMessages(context),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: colorScheme.secondaryVariant
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String messageDate(int milliseconds) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return format.format(date);
  }

  int _numberOfUnreadMessagesByMe() {
    return chat.messages.where((message) => message.unreadByMe).length;
  }

  Widget unreadMessages(context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final _unreadMessages = _numberOfUnreadMessagesByMe();
    if (_unreadMessages == 0) {
      return Container(width: 0, height: 0);
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: colorScheme.primary,
      ),
      child: Text(
        _unreadMessages.toString(),
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 12,
        ),
      ),
    );
  }
}
