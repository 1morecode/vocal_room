import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/res/widgets/my_loader.dart';
import 'package:vocal/unilinks/util.dart';

class MyUniLinkPage extends StatefulWidget {
  const MyUniLinkPage({Key key}) : super(key: key);

  @override
  _MyUniLinkPageState createState() => _MyUniLinkPageState();
}

class _MyUniLinkPageState extends State<MyUniLinkPage> {
  Future<void> uniLinkFuture;

  @override
  void initState() {
    uniLinkFuture = UniLinkUtil.navigateAccordingToUniLink(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(builder: (context, snapshot) {
        if(snapshot.hasData){
          return new Container();
        }else{
          return Center(
            child: new MyLoader(),
          );
        }
      },
        future: uniLinkFuture,
      ),
    );
  }
}
