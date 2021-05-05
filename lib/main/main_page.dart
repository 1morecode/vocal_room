import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vocal/main/navigation/my_drawer_button.dart';
import 'package:vocal/modules/channel/channel_page.dart';
import 'package:vocal/modules/dashboard/dashboard_page.dart';
import 'package:vocal/modules/podcast/podcast_page.dart';
import 'package:vocal/res/global_data.dart';
import 'package:vocal/res/user_token.dart';
import 'package:vocal/theme/app_state.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  var firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserToken.updateToken();
    FirebaseMessaging.instance.onTokenRefresh.listen(UserToken.saveTokenToDatabase);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    // var themeProvider = Provider.of<ThemeState>(context, listen: true);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: colorScheme.onPrimary,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
      key: GlobalData.scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // brightness: Brightness.dark,
        title: new Container(
          width: size.width,
          decoration: BoxDecoration(
              color: colorScheme.onSurface,
              borderRadius: BorderRadius.circular(10)),
          height: 45,
          child: new Row(
            children: [
              MyDrawerButton(),
              new SizedBox(width: 15,),
              Expanded(
                  child: new CupertinoButton(
                    onPressed: (){},
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: new Row(
                  children: [
                    new Icon(
                      CupertinoIcons.search,
                      color: colorScheme.secondaryVariant,
                      size: 18,
                    ),
                    new SizedBox(
                      width: 5,
                    ),
                    new Expanded(child: new Text(
                      "Search playlist, episodes, etc.",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: colorScheme.secondaryVariant,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ))
                  ],
                ),
              )),
              new SizedBox(width: 15,),
              IconButton(
                color: colorScheme.primary,
                icon: Icon(
                  CupertinoIcons.bell_circle,
                  size: 28,
                ),
                onPressed: () {},
              ),
              IconButton(
                color: colorScheme.primary,
                icon: new Container(
                  height: 28,
                  width: 28,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: colorScheme.primary, shape: BoxShape.circle),
                  child: ClipRRect(
                    child: Image.network(firebaseAuth.currentUser != null
                        ? "${firebaseAuth.currentUser.photoURL}"
                        : "https://www.w3schools.com/howto/img_avatar.png", fit: BoxFit.cover,),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: getPages(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (val) {
          // Vibration.vibrate(
          //   duration: 100,
          //   intensities: [8, 16, 8, 16],
          // );
          setState(() {
            selectedIndex = val;
          });
        },
        selectedLabelStyle: TextStyle(color: colorScheme.primary),
        unselectedItemColor: colorScheme.secondaryVariant,
        backgroundColor: colorScheme.onPrimary,
        selectedItemColor: colorScheme.primary,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.music_house),
              label: "Podcast",
              activeIcon: Icon(CupertinoIcons.music_house_fill)),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_3x2),
              label: "Dashboard",
              activeIcon: Icon(CupertinoIcons.square_grid_3x2_fill)),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.mic_circle),
              label: "Channel",
              activeIcon: Icon(CupertinoIcons.mic_circle_fill)),
        ],
      ),
    );
  }


  getPages() {
    switch (selectedIndex) {
      case 0:
        {
          return PodCastPage();
        }
        break;
      case 1:
        {
          return DashboardPage();
        }
        break;
      case 2:
        {
          return ChannelPage();
        }
        break;
      default:
        {
          return PodCastPage();
        }
        break;
    }
  }
}
