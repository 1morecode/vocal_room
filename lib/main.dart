// @dart=2.9

import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:vocal/auth/login_page.dart';
import 'package:vocal/channel/pages/home/home_page.dart';
import 'package:vocal/channel/pages/room/util/room_state.dart';
import 'package:vocal/channel/util/style.dart';
import 'package:vocal/theme/app_state.dart';
import 'package:vocal/unilinks/my_unilinks.dart';
import 'package:vocal/unilinks/util.dart';

bool isLoggedIn = false;
final FirebaseDynamicLinks _firebaseDynamicLinks = FirebaseDynamicLinks.instance;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var firebaseAuth = FirebaseAuth.instance;

  if (firebaseAuth.currentUser != null) {
    isLoggedIn = true;
  } else {
    isLoggedIn = false;
    print("CURRENT USER EMPTY");
  }

  initUniLinks();

  runApp(
    MultiProvider(
      providers: [
        ListenableProvider(
          create: (_) => ThemeState(),
        ),ListenableProvider(
          create: (_) => RoomState(),
        ),
        // ChangeNotifierProvider(create: (_) => RoomState()),
      ],
      child: OverlaySupport.global(child: MyApp(),),
    ),
  );

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

Future<Null> initUniLinks() async {
  UniLinkUtil.uniLinkResp = null;
  try {
    PendingDynamicLinkData initialLink = await _firebaseDynamicLinks.getInitialLink();
    if(initialLink != null){
      Uri parseUri = initialLink.link;
      var referralRoute = parseUri.path.substring(1);
      if (referralRoute.isNotEmpty || referralRoute.length != 0) {
        // GlobalData.deepLinkReferralId = referralRoute;
        print("Success Deep Link_______________$referralRoute}");
        UniLinkUtil.uniLinkResp = referralRoute;
      }else{
        print("Failed Main_______________${initialLink.link}");
      }
    }
  } on PlatformException {
    print("Exception Main_______________");
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeState>(
      builder: (context, themeState, child) => FeatureDiscovery(
          child: MaterialApp(
              // themeMode:
              //     themeState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              title: 'Vocal Cast',
              // theme: AppTheme.lightTheme,
              // darkTheme: AppTheme.darkTheme,
              theme: ThemeData(
                scaffoldBackgroundColor: Style.LightBrown,
                appBarTheme: AppBarTheme(
                  color: Style.LightBrown,
                  elevation: 0.0,
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                ),
              ),
              color: Colors.blue,
              home: isLoggedIn
                      ? UniLinkUtil.uniLinkResp != null ? MyUniLinkPage() : HomePage(null)
                      : LoginPage())),
    );
  }
}
