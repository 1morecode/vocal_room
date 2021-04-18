import 'package:flutter/material.dart';
import 'package:vocal/main/banner/banner_view.dart';
import 'package:vocal/main/story/story_view.dart';

class PodCastPage extends StatefulWidget {
  @override
  _PodCastPageState createState() => _PodCastPageState();
}

class _PodCastPageState extends State<PodCastPage> {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: [
        StoriesView(),
        TopBannerView()
      ],
    );
  }
}
