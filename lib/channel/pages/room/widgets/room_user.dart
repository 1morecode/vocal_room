import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserView extends StatefulWidget {
  final String userName;
  final ClientRole role;
  final RtcEngine engine;

  const UserView({Key key, this.userName, this.role, this.engine}) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  ClientRole role;
  RtcEngine engine;
  @override
  void initState() {
    role = widget.role;
    engine = widget.engine;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          decoration: BoxDecoration(
            color: widget.role == ClientRole.Audience ?  Colors.blueAccent : Colors.deepPurpleAccent,
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.green,
                width: 2
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: widget.role == ClientRole.Audience ?
              Icon(
                  Icons.people,
                  color: Colors.white
              )
                  :
              Icon(
                  Icons.person,
                  color: Colors.white
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.userName)
      ],
    );
  }

  _onPressToggleRole() {
    this.setState(() {
      role = role == ClientRole.Audience
          ? ClientRole.Broadcaster
          : ClientRole.Audience;
      engine.setClientRole(role);
    });
  }
}