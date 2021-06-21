import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:vocal/auth/login_page.dart';
import 'package:vocal/channel/pages/home/home_page.dart';
import 'package:vocal/channel/util/style.dart';
import 'package:vocal/theme/app_state.dart';
import 'package:vocal/theme/app_theme.dart';

bool isLoggedIn = false;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Firebase.initializeApp();
  var firebaseAuth = FirebaseAuth.instance;

  if (firebaseAuth.currentUser != null) {
    isLoggedIn = true;
    print("CURRENT USER ${await firebaseAuth.currentUser.getIdToken(true)}");
    IdTokenResult ss = await firebaseAuth.currentUser.getIdTokenResult(true);
    print("Token ${ss.token}");
    // final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    // pattern.allMatches("CURRENT ${await firebaseAuth.currentUser.getIdTokenResult(true)}").forEach((match) async{
    //   print(match.group(0));
    //   await AuthUtil.updateToken();
    // });
    //x-auth-token
  } else {
    isLoggedIn = false;
    print("CURRENT USER EMPTY");
  }

  runApp(
    MultiProvider(
      providers: [
        ListenableProvider(
          create: (_) => ThemeState(),
        ),
        // ChangeNotifierProvider(create: (_) => ChatsProvider()),
      ],
      child: OverlaySupport.global(child: MyApp(),),
    ),
  );

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
                      ? HomePage()
                      : LoginPage())),
    );
  }
}
