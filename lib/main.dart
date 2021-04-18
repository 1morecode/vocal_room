import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocal/auth/login_page.dart';
import 'package:vocal/main/main_page.dart';
import 'package:vocal/theme/app_state.dart';
import 'package:vocal/theme/app_theme.dart';
import 'intro_slider/app_intro.dart';

bool isLoggedIn = false;

///Initial theme settings
 bool intro = false;
Future main() async {
  timeDilation = 1.0;
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  var firebaseAuth = FirebaseAuth.instance;

  if(firebaseAuth.currentUser != null){
    isLoggedIn = true;
    print("CURRENT USER ${firebaseAuth.currentUser.displayName}");
    //x-auth-token
  }else{
    isLoggedIn = false;
    print("CURRENT USER EMPTY");
  }

  final prefs = await SharedPreferences.getInstance();
  if(prefs.containsKey("intro")){
    intro = prefs.getBool("intro");
  }else{
    intro = false;
  }

  runApp(
    MultiProvider(
      providers: [
        ListenableProvider(
          create: (_) => ThemeState(),
        ),
      ],
      child: MyApp(),
    ),
  );
  var systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeState>(builder: (context, themeState, child) => FeatureDiscovery(
        child: MaterialApp(
            themeMode: themeState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            title: 'Vocal Cast',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            color: Colors.blue,
            home: !intro
                ? SlideIntro()
                : isLoggedIn ? MainPage() : LoginPage())),);
  }
}
