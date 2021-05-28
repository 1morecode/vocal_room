import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/chat/src/data/models/chat.dart';
import 'package:vocal/modules/chat/src/data/models/custom_error.dart';
import 'package:vocal/modules/chat/src/data/models/user.dart';
import 'package:vocal/modules/chat/src/data/providers/chats_provider.dart';
import 'package:vocal/modules/chat/src/data/repositories/chat_repository.dart';
import 'package:vocal/modules/chat/src/data/repositories/user_repository.dart';
import 'package:vocal/modules/chat/src/screens/contact/contact_view.dart';
import 'package:vocal/modules/chat/src/utils/state_control.dart';

class AddChatController extends StateControl {
  UserRepository _userRepository = UserRepository();

  final BuildContext context;

  bool _loading = true;
  bool get loading => _loading;

  bool _error = false;
  bool get error => _error;

  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  AddChatController({
    @required this.context,
  }) {
    this.init();
  }

  @override
  void init() {
    getUsers();
  }

  void getUsers() async {
    dynamic response = await _userRepository.getUsers();
    
    if (response is CustomError) {
      _error = true;
    }
    if (response is List<UserModel>) {
      _users = response;
    }
    _loading = false;
    notifyListeners();
  }

  void newChat(UserModel user) async {
    
    // _showProgressDialog();

    final Chat chat = Chat(
      id: user.chatId,
      user: user,
    );
    final _provider = Provider.of<ChatsProvider>(context, listen: false);
    _provider.createUserIfNotExists(chat.user);
    _provider.createChatIfNotExists(chat);
    _provider.setSelectedChat(chat);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ContactScreen()));
    // _dismissProgressDialog();
    // Provider.of<ChatsProvider>(context, listen: false).setSelectedChat(chat.id);
    _loading = false;
    notifyListeners();
  }

  void closeScreen() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
