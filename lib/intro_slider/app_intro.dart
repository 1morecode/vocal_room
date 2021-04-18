import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocal/auth/login_page.dart';
import 'firstpage.dart';
import 'fourthpage.dart';
import 'secondpage.dart';
import 'thirdpage.dart';

class SlideIntro extends StatefulWidget {

  @override
  _SlideIntroState createState() => _SlideIntroState();
}

class _SlideIntroState extends State<SlideIntro> {
  PageController _controller;
  double _position;
  @override
  void initState() {
    super.initState();
    _position = 0;
    _controller = PageController()
      ..addListener(() {
        setState(() {
          _position = _controller.page;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _indicatorWidget(int index) {
    final distance = (_position - index).abs();
    final size = distance > 1 ? 10.0 : 10 * (2 - distance);
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: distance < 0.2
            ? Text(
          (index + 1).toString(),
          style: TextStyle(color: Color.fromRGBO(35, 204, 198, 1)),
        )
            : Center(),
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Container(
          child: Stack(
            children: <Widget>[
              PageView(
                physics: const PageScrollPhysics(),
                controller: _controller,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FirstPage(),
                  SecondPage(),
                  ThirdPage(),
                  FourthPage(),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  color: Colors.grey[100].withOpacity(0.5),
                  width: size.width,
                  padding:
                  EdgeInsets.only(left: 40, right: 20, bottom: 30, top: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: size.width / 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _indicatorWidget(0),
                            _indicatorWidget(1),
                            _indicatorWidget(2),
                            _indicatorWidget(3)
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          //boxShadow: _customShadow,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: _position < 2.5
                              ? InkWell(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                              onTap: () => _controller.animateToPage(
                                  _position.toInt() + 1,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.linear),
                              child: SizedBox(
                                  height: 40,
                                  width: 80,
                                  child: Center(
                                      child: Text("Next",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.bold)))))
                              : InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () async{
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setBool("intro", true);
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => false);
                              },
                              child: SizedBox(
                                  height: 40,
                                  width: 80,
                                  child: Center(
                                      child: Text("Done",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.bold))))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
