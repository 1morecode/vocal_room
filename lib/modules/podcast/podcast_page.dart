import 'package:flutter/material.dart';
import 'package:vocal/modules/podcast/banner/banner_view.dart';
import 'package:vocal/modules/podcast/category/category_view.dart';
import 'package:vocal/modules/podcast/playlist/playlist_grid_view.dart';
import 'package:vocal/modules/podcast/story/story_view.dart';

class PodCastPage extends StatefulWidget {
  @override
  _PodCastPageState createState() => _PodCastPageState();
}

class _PodCastPageState extends State<PodCastPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return new ListView(
      // scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      // shrinkWrap: false,
      children: [
        StoriesView(),
        TopBannerView(),
        CategoryView(),
        Container(
          alignment: Alignment.topLeft,
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Text(
            "Top Playlists",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: colorScheme.onSecondary),
          ),
        ),
        PlaylistGridView()
      ],
    );
  }
}
