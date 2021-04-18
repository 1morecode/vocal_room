import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class FirstPage extends StatefulWidget {

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(35, 204, 198, 1),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(40, 65, 40, 20),
                child: Text(
                  "First Page",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              SizedBox(
                  height: size.width * 3 / 4,
                  child: FlareActor(
                    'assets/longtap.flr',
                    alignment: Alignment.center,
                    animation: 'longtap',
                    fit: BoxFit.cover,
                  )),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
