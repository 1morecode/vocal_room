import 'package:flutter/material.dart';
import 'package:vocal/modules/podcast/widgets/playlist_card_widget.dart';

class PlaylistGridView extends StatefulWidget {
  @override
  _PlaylistGridViewState createState() => _PlaylistGridViewState();
}

class _PlaylistGridViewState extends State<PlaylistGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      padding: EdgeInsets.symmetric(horizontal: 5),
      children: List.generate(25, (index) {
        return new PlayListCardWidget();
      }),
    );
  }
}
