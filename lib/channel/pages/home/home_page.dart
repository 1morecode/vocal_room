import 'package:flutter/material.dart';
import 'package:vocal/channel/pages/home/profile_page.dart';
import 'package:vocal/channel/pages/home/widgets/home_app_bar.dart';
import 'package:vocal/channel/pages/lobby/follower_page.dart';
import 'package:vocal/channel/pages/lobby/lobby_page.dart';
import 'package:vocal/channel/util/history.dart';

class HomePage extends StatefulWidget {
  final Function callback;

  HomePage(this.callback);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.callback != null) {
      navigate();
    }
  }

  navigate(){
    Future.delayed(Duration(seconds: 1), () {
      widget.callback(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: HomeAppBar(
          onProfileTab: () {
            // History.pushPage(context, ProfilePage());
          },
        ),
      ),
      body: PageView(
        children: [
          LobbyPage(),
          // FollowerPage(),
        ],
      ),
    );
  }
}
