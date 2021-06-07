
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProviderIcon extends StatefulWidget {
  final double size;

  LoginProviderIcon(this.size);

  @override
  _LoginProviderIconState createState() => _LoginProviderIconState();
}

class _LoginProviderIconState extends State<LoginProviderIcon> {

  getLoginProvider() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey("loginType")){
      if(sharedPreferences.getString("loginType") == "facebook"){
        return "facebook";
      }else{
        return "google";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLoginProvider(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          if(snapshot.data == "facebook"){
            return Image.asset("assets/facebook.png", height: widget.size,);
          }else{
            return Image.asset("assets/google.png", height: widget.size,);
          }
        }else{
          return new Container();
        }
      },
    );
  }
}
