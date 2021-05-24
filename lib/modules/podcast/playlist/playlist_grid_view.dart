import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';
import 'package:vocal/modules/podcast/playlist/util/pod_cast_playlist_util.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';
import 'package:vocal/modules/podcast/widgets/playlist_card_widget.dart';

class PlaylistGridView extends StatefulWidget {
  @override
  _PlaylistGridViewState createState() => _PlaylistGridViewState();
}

class _PlaylistGridViewState extends State<PlaylistGridView> {
  Future<List<PodCastPlaylistModel>> playlistFuture;

  @override
  void initState() {
    playlistFuture = PodCastPlaylistUtil.fetchAllPlaylistModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var playlistState = Provider.of<PodCastState>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      initialData: playlistState.podCastPlaylistList,
      future: playlistFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("DSDSDSDSDSDSDSD");
          if (playlistState.podCastPlaylistList.length > 0) {
            return GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              padding: EdgeInsets.symmetric(horizontal: 5),
              children: List.generate(playlistState.podCastPlaylistList.length,
                  (index) {
                return new PlayListCardWidget(index);
              }),
            );
          } else {
            return new Container(
                padding: EdgeInsets.all(15),
                child: Center(
                    child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_emotions,
                      size: 50,
                      color: colorScheme.secondaryVariant,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Playlist Not Available",
                      style: TextStyle(
                          color: colorScheme.secondaryVariant,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CupertinoButton(
                      color: colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      minSize: 25,
                      borderRadius: BorderRadius.circular(25),
                      child: Shimmer.fromColors(
                        child: new Text(
                          "Retry",
                          style: TextStyle(color: colorScheme.onPrimary),
                        ),
                        baseColor: colorScheme.secondaryVariant,
                        highlightColor: colorScheme.primary,
                      ),
                      onPressed: () {
                        playlistFuture = PodCastPlaylistUtil.fetchAllPlaylistModel(context);
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                )));
          }
        } else {
          return GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            padding: EdgeInsets.symmetric(horizontal: 5),
            children: List.generate(4, (index) {
              return Shimmer.fromColors(
                baseColor: colorScheme.onPrimary,
                highlightColor: colorScheme.secondaryVariant.withOpacity(0.3),
                enabled: false,
                child: new Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorScheme.onPrimary,
                  ),
                ),
              );
            }),
          );
        }
      },
    );
  }
}
