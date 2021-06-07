import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vocal/modules/dashboard/playlist/shimmer/playlist_shimmer.dart';
import 'package:vocal/modules/dashboard/playlist/util/playlist_state.dart';
import 'package:vocal/modules/dashboard/playlist/util/playlist_util.dart';
import 'package:vocal/modules/dashboard/playlist/view/new_playlist_page.dart';
import 'package:vocal/modules/dashboard/playlist/widget/playlist_list_widget.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';

class PlaylistPage extends StatefulWidget {
  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  Future<List<PodCastPlaylistModel>> playlistFuture;

  @override
  void initState() {
    playlistFuture = PlaylistUtil.fetchAllPlaylistModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    final playlistState = Provider.of<PlaylistState>(context, listen: true);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        icon: Icon(Icons.add, color: colorScheme.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        label: Shimmer.fromColors(
          child: new Text(
            "New Playlist",
            style: TextStyle(color: colorScheme.onPrimary),
          ),
          baseColor: colorScheme.onPrimary,
          highlightColor: colorScheme.primary,
        ),
        tooltip: "Add New Playlist",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewPlaylistPage(),
              ));
        },
      ),
      body: SafeArea(
        child: FutureBuilder(
          initialData: playlistState.playlistModelList,
            builder: (context, snapshot) {
              if (snapshot.hasData && playlistState.playlistModelList.length != 0) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: playlistState.playlistModelList.length,
                  padding: EdgeInsets.only(top: 5, bottom: 65),
                  itemBuilder: (context, index) {
                    return new PlaylistWidget(playlistState.playlistModelList[index].id);
                  },
                );
              } else if (snapshot.hasData && playlistState.playlistModelList.length == 0) {
                return Center(
                    child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      "assets/no_record_found.png",
                      height: 70,
                    ),
                  ],
                ));
              } else if (snapshot.hasError) {
                return Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new SizedBox(height: 50,),
                      Image.asset(
                        "assets/no_record_found.png",
                        height: 70,
                      ),
                      new SizedBox(height: 10,),
                      CupertinoButton(
                        color: colorScheme.secondaryVariant,
                        borderRadius: BorderRadius.circular(25),
                        child: Shimmer.fromColors(
                          child: new Text(
                            "Try again",
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                          baseColor: colorScheme.onPrimary,
                          highlightColor: colorScheme.primary,
                        ),
                        onPressed: () {
                          playlistFuture =
                              PlaylistUtil.fetchAllPlaylistModel(context);
                        },
                      )
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return PlayListShimmer();
                  },
                );
              }
            },
            future: playlistFuture),
      ),
    );
  }
}
