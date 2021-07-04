import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:vocal/channel/models/room.dart';
import 'package:vocal/res/widgets/my_loader.dart';

class RoomShareButton extends StatefulWidget {

  final Room room;
  const RoomShareButton({Key key, this.room}) : super(key: key);

  @override
  _RoomShareButtonState createState() => _RoomShareButtonState();
}

class _RoomShareButtonState extends State<RoomShareButton> {
  String _linkMessage;
  bool _isCreatingLink = false;

  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          if (deepLink != null) {
            Navigator.pushNamed(context, deepLink.path);
          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  Future<void> _createDynamicLink(bool short) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://vocalcast.page.link',
      link: Uri.parse('https://vocalcast.page.link/room:${widget.room.roomId}'),
      androidParameters: AndroidParameters(
        packageName: 'com.u1morecode.vocal',
        minimumVersion: 23,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      // iosParameters: IosParameters(
      //   bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
      //   minimumVersion: '0',
      // ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }
    print("Url Created $url");

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.all(5),
      onPressed: () async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => new CupertinoAlertDialog(
              title: new Center(
                child: MyLoader(),
              ),
            ));
        if(!_isCreatingLink)
          await _createDynamicLink(true);
        Navigator.of(context).pop();
        if (_linkMessage != null) {
          Share.share('Join Channel to ${widget.room.title} $_linkMessage');
        }
      },
      child: new Icon(Icons.share),
    );
  }
}
