import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/global/playlist_page.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';
import 'package:vocal/res/api_data.dart';

class CategoryPlaylistCard extends StatefulWidget {
  final PodCastPlaylistModel podCastPlaylistModel;

  CategoryPlaylistCard(this.podCastPlaylistModel);

  @override
  _CategoryPlaylistCardState createState() => _CategoryPlaylistCardState();
}

class _CategoryPlaylistCardState extends State<CategoryPlaylistCard> {

  @override
  Widget build(BuildContext context) {
    final episodeState = Provider.of<PodCastState>(context, listen: true);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return new CupertinoButton(child: Container(
      margin: EdgeInsets.all(10),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorScheme.onPrimary,
        image: DecorationImage(
          image: NetworkImage(
              "${APIData.imageBaseUrl}${widget.podCastPlaylistModel.image}"),
          fit: BoxFit.cover,
        ),
      ),
      child: new Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: new LinearGradient(
              colors: [
                colorScheme.primary.withOpacity(0.2),
                colorScheme.onPrimary
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.5, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                "${widget.podCastPlaylistModel.title}",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    color: colorScheme.onSecondary.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            )
          ],
        ),
      ),
    ), onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => PlayListPage(widget.podCastPlaylistModel),));
    }, padding: EdgeInsets.all(0),);
  }
}
