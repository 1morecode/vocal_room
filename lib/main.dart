import 'package:audio_service/audio_service.dart';
import 'package:camera/camera.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocal/auth/login_page.dart';
import 'package:vocal/libraries/new/camera_page.dart';
import 'package:vocal/main/navigation/navigation_home_screen.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/util/episode_state.dart';
import 'package:vocal/modules/dashboard/playlist/util/playlist_state.dart';
import 'package:vocal/modules/podcast/state/current_player_state.dart';
import 'package:vocal/theme/app_state.dart';
import 'package:vocal/theme/app_theme.dart';
import 'intro_slider/app_intro.dart';

bool isLoggedIn = false;

///Initial theme settings
 bool intro = false;
Future main() async {
  timeDilation = 1.0;
  WidgetsFlutterBinding.ensureInitialized();

  try {
    cameras = await availableCameras();
    // qrCameras = await qr.availableCameras();
  } on CameraException catch (e) {
    print(e.code+'\n'+ e.description);
  }

  await Firebase.initializeApp();
  var firebaseAuth = FirebaseAuth.instance;

  if(firebaseAuth.currentUser != null){
    isLoggedIn = true;
    print("CURRENT USER ${await firebaseAuth.currentUser.getIdToken(true)}");
    IdTokenResult ss =  await firebaseAuth.currentUser.getIdTokenResult(true);
    print("Token ${ss.token}");
    // final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    // pattern.allMatches("CURRENT ${await firebaseAuth.currentUser.getIdTokenResult(true)}").forEach((match) async{
    //   print(match.group(0));
    //   await AuthUtil.updateToken();
    // });
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
        ListenableProvider(
          create: (_) => PlaylistState(),
        ),
        ListenableProvider(
          create: (_) => EpisodeState(),
        ),ListenableProvider(
          create: (_) => CurrentPlayerState(),
        ),
      ],
      child: MyApp(),
    ),
  );

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
                : isLoggedIn ? NavigationHomeScreen() : LoginPage())),);
  }
}
