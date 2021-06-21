
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/pages/room/widgets/room_user.dart';
import 'package:vocal/channel/util/style.dart';
import 'package:vocal/channel/widgets/round_button.dart';
import 'package:vocal/channel/widgets/round_image.dart';
import 'package:vocal/res/api_data.dart';

class CallScreen extends StatefulWidget {
  final String channelName;
  final String userId;
  final String roomId;
  final ClientRole role;

  CallScreen({this.channelName, this.userId, this.roomId, this.role});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool _isLogin = false;
  bool _isInChannel = false;
  final _broadcaster = <String>[];
  final _audience = <String>[];
  final Map<int, String> _allUsers = {};
  ClientRole role = ClientRole.Audience;

  AgoraRtmClient _client;
  AgoraRtmChannel _channel;
  RtcEngine _engine;

  final buttonStyle = TextStyle(color: Colors.white, fontSize: 15);

  int localUid;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    _channel.leave();
    _allUsers.clear();
    _broadcaster.clear();
    _audience.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    role = widget.role;
    initialize();
    _createClient();

  }

  Future<void> initialize() async {

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // await _engine.enableWebSdkInteroperability(true);
    await _engine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APIData.agoraAppId);
    await _engine.disableVideo();
    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) async {
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
          localUid = uid;
          _allUsers.putIfAbsent(uid, () => widget.userId);
        });
        if (widget.role == ClientRole.Broadcaster) {
          setState(() {
            _users.add(uid);
          });
        }
      },
      leaveChannel: (stats) async {
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
          _allUsers.remove(localUid);
        });
        await _channel.sendMessage(AgoraRtmMessage.fromText('$localUid:leave'));
      },
      userJoined: (uid, elapsed) {
        print("User Joined $uid");
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _allUsers.putIfAbsent(uid, () => "$uid");
          _users.add(uid);
        });
      },
      userOffline: (uid, reason) {
        print("User Leave $uid");
        setState(() {
          final info = 'userOffline: $uid , reason: $reason';
          _infoStrings.add(info);
          _allUsers.remove(uid);
          _users.remove(uid);
        });
      },
      // firstRemoteVideoFrame: (uid, width, height, elapsed) {
      //   setState(() {
      //     final info = 'firstRemoteVideoFrame: $uid';
      //     _infoStrings.add(info);
      //   });
      // },
    ));
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance(APIData.agoraAppId);
    _client.onConnectionStateChanged = (int state, int reason) {
      if (state == 5) {
        _client.logout();
        print('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };

    String userId = widget.userId;
    await _client.login(null, userId);
    print('Login success: ' + userId);
    setState(() {
      _isLogin = true;
    });
    String channelName = widget.roomId;
    _channel = await _createChannel(channelName);
    await _channel.join();
    print('RTM Join channel success.');
    setState(() {
      _isInChannel = true;
    });
    await _channel.sendMessage(AgoraRtmMessage.fromText('$localUid:join'));
    // _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
    //   print("Peer msg: " + peerId + ", msg: " + message.text);
    //
    //   var userData = message.text.split(':');
    //
    //   if (userData[1] == 'leave') {
    //     print('In here');
    //     setState(() {
    //       _allUsers.remove(int.parse(userData[0]));
    //     });
    //   } else {
    //     setState(() {
    //       _allUsers.putIfAbsent(int.parse(userData[0]), () => peerId);
    //     });
    //   }
    // };
    // _channel.onMessageReceived =
    //     (AgoraRtmMessage message, AgoraRtmMember member) {
    //   print(
    //       'Outside channel message received : ${message.text} from ${member.userId}');
    //
    //   var userData = message.text.split(':');
    //
    //   if (userData[1] == 'leave') {
    //     setState(() {
    //       _allUsers.remove(int.parse(userData[0]));
    //     });
    //   } else {
    //     print('Broadcasters list : $_users');
    //     print('All users lists: ${_allUsers.values}');
    //     setState(() {
    //       _allUsers.putIfAbsent(int.parse(userData[0]), () => member.userId);
    //     });
    //   }
    // };

    for (var i = 0; i < _users.length; i++) {
      _broadcaster.clear();
      _audience.clear();
      if (_allUsers.containsKey(_users[i])) {
        setState(() {
          _broadcaster.add(_allUsers[_users[i]]);
        });
      } else {
        setState(() {
          _audience.add('${_allUsers.values}');
        });
      }
    }
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel channel = await _client.createChannel(name);
    channel.onMemberJoined = (AgoraRtmMember member) async {
      print('Member joined : ${member.userId}');
      // setState(() {

      // });
      await _client.sendMessageToPeer(
          member.userId, AgoraRtmMessage.fromText('$localUid:join'));
    };
    channel.onMemberLeft = (AgoraRtmMember member) async {
      var reversedMap = _allUsers.map((k, v) => MapEntry(v, k));
      print('Member left : ${member.userId}:leave');
      print('Member left : ${reversedMap[member.userId]}:leave');

      setState(() {
        _allUsers.remove(reversedMap[member.userId]);
      });
      await channel.sendMessage(
          AgoraRtmMessage.fromText('${reversedMap[member.userId]}:leave'));
    };
    channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      print('Channel message received : ${message.text} from ${member.userId}');

      var userData = message.text.split(':');

      if (userData[1] == 'leave') {
        _allUsers.remove(int.parse(userData[0]));
      } else {
        _allUsers.putIfAbsent(int.parse(userData[0]), () => member.userId);
      }
    };
    return channel;
  }

  _onPressToggleRole() {
    this.setState(() {
      if(role == ClientRole.Audience){
        role = ClientRole.Broadcaster;
        _users.add(localUid);
      }else{
        _users.remove(localUid);
        role =  ClientRole.Audience;
      }
      _engine.setClientRole(role);
    });
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  Widget getMicButton(){
    return widget.role == ClientRole.Audience
        ? RoundButton(
      onPressed: _onToggleMute,
      color: Style.LightGrey,
      isCircle: true,
      child:Icon(
        muted ? Icons.mic_off : Icons.mic,
        color: Colors.blueAccent,
        size: 15.0,
      ),
    ) : RoundButton(
      onPressed: _onToggleMute,
      color: Style.LightGrey,
      isCircle: true,
      child:Icon(
        muted ? Icons.mic_off : Icons.mic,
        color: Colors.blueAccent,
        size: 15.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              '${widget.channelName}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                // History.pushPage(
                //   context,
                //   ProfilePage(
                //     profile: myProfile,
                //   ),
                // );
              },
              child: RoundImage(
                url: AuthUtil.firebaseAuth.currentUser.photoURL,
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              left: 0,
              right: 0,
              bottom: 0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    bottom: 80,
                    top: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitle(widget.channelName),
                      SizedBox(
                        height: 15,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(12),
                      //   child: Text(
                      //     'Broadcaster',
                      //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      buildBroadcaster(),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Others in the room',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey.withOpacity(0.6),
                          ),
                        ),
                      ),
                      buildAudience(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: buildBottom(context),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildBroadcaster() {
    return GridView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 150,
      ),
      itemCount: _users.length,
      itemBuilder: (gc, index) {
        return _allUsers.containsKey(_users[index])
            ? UserView(
          userName: _allUsers[_users[index]],
          role: ClientRole.Broadcaster,
          engine: _engine,
        )
            : Container();
      },
    );
  }

  Widget buildAudience() {
    return GridView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 150,
      ),
      itemCount: (_allUsers.length - _users.length).abs(),
      itemBuilder: (gc, index) {
        return _users.contains(_allUsers.keys.toList()[index])
            ? Container()
            : UserView(
          role: ClientRole.Audience,
          userName: _allUsers.values.toList()[index],
        );
      },
    );
  }

  Widget buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Row(
                    children: [
                      new Icon(Icons.mic_external_on, size: 14,),
                      // Text(
                      //   " ${widget.room.users.where((element) => element['_id'] == widget.room.createdBy).first['name']}",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w400,
                      //     fontSize: 12,
                      //   ),
                      // ),
                    ],
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
          ),
          Container(
            child: IconButton(
              onPressed: () {},
              iconSize: 30,
              icon: Icon(Icons.more_horiz),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottom(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.red,
            ],
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RoundButton(
            onPressed: () => _onCallEnd(context),
            color: Style.LightGrey,
            child: Text(
              '✌️ Leave quietly',
              style: TextStyle(
                color: Style.AccentRed,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          getMicButton(),
          RoundButton(
            onPressed: _onPressToggleRole,
            color: Style.LightGrey,
            isCircle: true,
            child: Icon(
              role == ClientRole.Broadcaster ? CupertinoIcons.minus: CupertinoIcons.add,
              size: 15,
              color: Colors.black,
            ),
          ),
          RoundButton(
            onPressed: () {},
            color: Style.LightGrey,
            isCircle: true,
            child: Icon(
              CupertinoIcons.hand_raised,
              size: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
