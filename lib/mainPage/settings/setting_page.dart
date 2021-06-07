import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/res/widgets/custom_list_tile.dart';
import 'package:vocal/theme/app_state.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CupertinoNavigationBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(
                  "Settings",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: colorScheme.secondaryVariant),
                ),
              ),
              CustomListTile(
                title: "Edit Account",
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                leading: Icon(CupertinoIcons.person_crop_circle),
                trailing: Icon(CupertinoIcons.forward),
                onPressed: () {},
              ),
              CustomListTile(
                title: "Change Password",
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                leading: Icon(CupertinoIcons.lock_shield),
                trailing: Icon(CupertinoIcons.forward),
                onPressed: () {},
              ),
              CustomListTile(
                title: "Log Out",
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                leading: Icon(CupertinoIcons.power),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      title: new Text(
                        "Warning!",
                        style: TextStyle(color: colorScheme.primary),
                      ),
                      message: new Text(
                          "You really want to logout from this device?"),
                      actions: [
                        CupertinoActionSheetAction(
                          child: new Text("Yes"),
                          onPressed: () {
                            AuthUtil.logout(context);
                          },
                        )
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: new Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
              ),
              Container(
                alignment: Alignment.topLeft,
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(
                  "General",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: colorScheme.secondaryVariant),
                ),
              ),
              CustomListTile(
                title: "Notification",
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                leading: Icon(CupertinoIcons.bell_circle),
                trailing: Icon(CupertinoIcons.forward),
                onPressed: () {},
              ),
              CustomListTile(
                title: "Language",
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                leading: Icon(CupertinoIcons.globe),
                trailing: Icon(CupertinoIcons.forward),
                onPressed: () {},
              ),
              Consumer<ThemeState>(builder: (context, appState, child) {
                return CustomListTile(
                  title: "Dark Mode",
                  leading: Icon(appState.isDarkModeOn
                      ? CupertinoIcons.moon_circle
                      : CupertinoIcons.sun_min),
                  trailing: CupertinoSwitch(
                      value: appState.isDarkModeOn,
                      onChanged: (bool value) {
                        appState.toggleChangeTheme();
                      }),
                );
              }),

            ],
          ),
        ),
      ),
    );
  }
}
