import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class SecondPage extends StatefulWidget {

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Color.fromRGBO(77, 145, 190, 1),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(40, 65, 40, 20),
              child: Text(
                "Second Page",
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
          ],
        ),
      ),
    );
  }
}
