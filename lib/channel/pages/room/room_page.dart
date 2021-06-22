

import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/auth/util/auth_util.dart';
import 'package:vocal/channel/models/room.dart';
import 'package:vocal/channel/pages/home/profile_page.dart';
import 'package:vocal/channel/pages/room/widgets/room_profile.dart';
import 'package:vocal/channel/util/data.dart';
import 'package:vocal/channel/util/history.dart';
import 'package:vocal/channel/util/style.dart';
import 'package:vocal/channel/widgets/round_button.dart';
import 'package:vocal/channel/widgets/round_image.dart';
import 'package:vocal/model/user.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/user_token.dart';

class RoomPage extends StatefulWidget {
  final Room room;
  final ClientRole clientRole;

  const RoomPage({Key key, this.room, this.clientRole}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool _isLogin = false;
  bool _isInChannel = false;
  final _broadcaster = <FirebaseUserModel>[];
  final _audience = <String>[];
  final Map<int, FirebaseUserModel> _allUsers = {};
  ClientRole role = ClientRole.Audience;

  AgoraRtmClient _client;
  AgoraRtmChannel _channel;
  RtcEngine _engine;

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
    removeUser();
    super.dispose();
  }

  void removeUser(){
    FirebaseUserModel firebaseUserModel = new FirebaseUserModel(
        id: AuthUtil.firebaseAuth.currentUser.uid,
        name: AuthUtil.firebaseAuth.currentUser.displayName,
        username: AuthUtil.firebaseAuth.currentUser.email,
        picture: AuthUtil.firebaseAuth.currentUser.photoURL);
    Room room = widget.room;
    var usr = room.users.where((i) => i['_id'] == AuthUtil.firebaseAuth.currentUser.uid).toList();
    print("UNS $usr");

    if (usr.length != 0) {
      room.users.remove(firebaseUserModel.toJson());
      final DocumentReference messageDoc = FirebaseFirestore.instance
          .collection('rooms')
          .doc(room.roomId);
      messageDoc.update({
        'users': room.users,
      });
    } else {
print("User Not Available");
    }
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    role = widget.clientRole;
    initialize();
    _createClient();
  }

  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // await _engine.enableWebSdkInteroperability(true);
    await _engine.joinChannel(null, widget.room.roomId, null, 0);
    _engine.joinChannelWithUserAccount(null, widget.room.roomId, AuthUtil.firebaseAuth.currentUser.uid);
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
          FirebaseUserModel firebaseUserModel = new FirebaseUserModel(
              id: AuthUtil.firebaseAuth.currentUser.uid,
              name: AuthUtil.firebaseAuth.currentUser.displayName,
              username: AuthUtil.firebaseAuth.currentUser.email,
              picture: AuthUtil.firebaseAuth.currentUser.photoURL);
          _allUsers.putIfAbsent(uid, () => firebaseUserModel);
        });
        if (widget.clientRole == ClientRole.Broadcaster) {
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
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _users.add(uid);
        });
      },
      userOffline: (uid, reason) {
        setState(() {
          final info = 'userOffline: $uid , reason: $reason';
          _infoStrings.add(info);
          _users.remove(uid);
        });
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'firstRemoteVideoFrame: $uid';
          _infoStrings.add(info);
        });
      },
    ));
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance(APIData.agoraAppId);
    // _client.onConnectionStateChanged = (int state, int reason) {
    //   if (state == 5) {
    //     _client.logout();
    //     print('Logout.');
    //     setState(() {
    //       _isLogin = false;
    //     });
    //   }
    // };
    // FirebaseUserModel firebaseUserModel = new FirebaseUserModel(
    //     id: AuthUtil.firebaseAuth.currentUser.uid,
    //     name: AuthUtil.firebaseAuth.currentUser.displayName,
    //     username: AuthUtil.firebaseAuth.currentUser.email,
    //     picture: AuthUtil.firebaseAuth.currentUser.photoURL);

    String userId = AuthUtil.firebaseAuth.currentUser.uid;
    await _client.login(null, userId);
    print('Login success: ' + userId);
    setState(() {
      _isLogin = true;
    });
    String channelName = widget.room.roomId;
    _channel = await _createChannel(channelName);
    await _channel.join();
    print('RTM Join channel success.');
    setState(() {
      _isInChannel = true;
    });
    await _channel.sendMessage(AgoraRtmMessage.fromText('$localUid:join'));
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      print("Peer msg: " + peerId + ", msg: " + message.text);

      var userData = message.text.split(':');

      if (userData[1] == 'leave') {
        print('In here');
        setState(() {
          _allUsers.remove(int.parse(userData[0]));
        });
      } else {

        setState(() async{
          FirebaseUserModel firebaseUserModel = await UserToken.getUserByUId(peerId);
          _allUsers.putIfAbsent(int.parse(userData[0]), () => firebaseUserModel);
        });
      }
    };
    print('All users lists: $_allUsers');
    _channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      print(
          'Outside channel message received : ${message.text} from ${member.userId}');

      var userData = message.text.split(':');

      if (userData[1] == 'leave') {
        setState(() {
          _allUsers.remove(int.parse(userData[0]));
        });
      } else {
        print('Broadcasters list : $_users');
        print('All users lists: ${_allUsers.values}');
        setState(() async{
          FirebaseUserModel firebaseUserModel = await UserToken.getUserByUId(member.userId);
          _allUsers.putIfAbsent(int.parse(userData[0]), () => firebaseUserModel);
        });
      }
    };

    // for (var i = 0; i < _users.length; i++) {
    //   if (_allUsers.containsKey(_users[i])) {
    //     setState(() {
    //       _broadcaster.add(_allUsers[_users[i]]);
    //     });
    //   } else {
    //     setState(() {
    //       _audience.add('${_allUsers.values}');
    //     });
    //   }
    // }
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
        (AgoraRtmMessage message, AgoraRtmMember member) async{
      print('Channel message received : ${message.text} from ${member.userId}');

      var userData = message.text.split(':');

      if (userData[1] == 'leave') {
        _allUsers.remove(int.parse(userData[0]));
      } else {
        FirebaseUserModel firebaseUserModel = await UserToken.getUserByUId(member.userId);
        _allUsers.putIfAbsent(int.parse(userData[0]), () => firebaseUserModel);
      }
    };
    return channel;
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
              '${widget.room.title}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                History.pushPage(
                  context,
                  ProfilePage(
                    profile: myProfile,
                  ),
                );
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
      body: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
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
                children: [
                  buildTitle(widget.room.title),
                  SizedBox(
                    height: 30,
                  ),
                  buildSpeakers(widget.room.users.sublist(0, widget.room.speakerCount)),
                  buildOthers(widget.room.users.sublist(widget.room.speakerCount)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildBottom(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(String title) {
    return Row(
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
                  Text(
                    " ${widget.room.users.where((element) => element['_id'] == widget.room.createdBy).first['name']}",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
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
    );
  }

  Widget buildSpeakers(List<dynamic> users) {
    return GridView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 150,
      ),
      itemCount: users.length,
      itemBuilder: (gc, index) {
        return RoomProfile(
          user: users[index],
          clientRole: role,
          isMute: index == 3,
          rtcEngine: _engine,
          size: 80,
        );
      },
    );
  }

  Widget buildOthers(List<dynamic> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Others in the room',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.grey.withOpacity(0.6),
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisExtent: 100,
          ),
          itemCount: users.length,
          itemBuilder: (gc, index) {
            return RoomProfile(
              user: users[index],
              clientRole: role,
              rtcEngine: _engine,
              size: 60,
            );
          },
        ),
      ],
    );
  }

  Widget buildBottom(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          RoundButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Style.LightGrey,
            child: Text(
              '✌️ Leave quietly',
              style: TextStyle(
                color: Style.AccentRed,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Spacer(),
          RoundButton(
            onPressed: () {},
            color: Style.LightGrey,
            isCircle: true,
            child: Icon(
              Icons.add,
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
