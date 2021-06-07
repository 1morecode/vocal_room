import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:vocal/modules/podcast/model/user.dart';
import 'package:vocal/res/user_token.dart';
import 'package:vocal/res/widgets/ios_style_toast.dart';

class UserProfilePage extends StatefulWidget {
  final String uid;

  UserProfilePage(this.uid);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {


  @override
  void initState() {
    print("UID ${widget.uid}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new CupertinoNavigationBar(
        trailing: new CupertinoButton(child: new Icon(CupertinoIcons.arrowshape_turn_up_right_fill), onPressed: (){}),
      ),
      body: FutureBuilder<UserModel>(
        future: UserToken.getUserByUId(widget.uid),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView(
              children: [
                new Container(
                  width: size.width,
                  height: size.width*0.7,
                  padding: EdgeInsets.only(top: size.width*0.1),
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          colorScheme.onPrimary,
                          colorScheme.onSurface,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: new Column(
                    children: [
                      new CircleAvatar(
                        backgroundColor: colorScheme.onSurface,
                        radius: 60,
                        backgroundImage: NetworkImage("${snapshot.data.picture}", ),
                      ),
                      new SizedBox(height: 10,),
                      new Text("${snapshot.data.name}", style: TextStyle(
                          color: colorScheme.onSecondary, fontWeight: FontWeight.bold, fontSize: 24
                      ),),
                      new SizedBox(height: 5,),
                      new Container(
                        child: new Row(
                          children: [
                            new Text("@${snapshot.data.username}", style: TextStyle(
                                color: colorScheme.onSecondary, fontWeight: FontWeight.w400, fontSize: 14
                            ),),
                            Spacer(),
                            new CupertinoButton(child: new Icon(Icons.copy, color: colorScheme.primary,), onPressed: (){
                              showOverlay((_, t) {
                                return Theme(
                                  data: Theme.of(context),
                                  child: Opacity(
                                    opacity: t,
                                    child: IosStyleToast("Copied"),
                                  ),
                                );
                              }, key: ValueKey('hello'));
                              Clipboard.setData(ClipboardData(text: "${snapshot.data.username}"));
                            }, padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0,), minSize: 30,)
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: colorScheme.onSurface
                        ),
                        height: 40,
                        width: size.width,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      )
                    ],
                  ),
                )
              ],
            );
          }else{
            return new Container();
          }
        },
      ),
    );
  }
}
