import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/util/episode_util.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/view/new_episode_page.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/widget/episode_list_widget.dart';
import 'package:vocal/modules/dashboard/playlist/shimmer/episode_shimmer.dart';
import 'package:vocal/modules/dashboard/playlist/util/playlist_state.dart';
import 'package:vocal/modules/dashboard/playlist/util/playlist_util.dart';
import 'package:vocal/modules/dashboard/playlist/view/playlist_update_page.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';
import 'package:vocal/res/global_data.dart';

class EpisodesPage extends StatefulWidget {
  final String id;

  EpisodesPage(this.id);

  @override
  _EpisodesPageState createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  Future<bool> episodeFuture;

  @override
  void initState() {
    episodeFuture = EpisodeUtil.fetchAllEpisodeModel(context, widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    final episodeState = Provider.of<PodCastState>(context, listen: true);
    final playlistState = Provider.of<PlaylistState>(context, listen: true);
    var playlistModel = playlistState.playlistModelList
        .where((element) => element.id == widget.id);
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: colorScheme.onSurface,
              elevation: 1,
              leading: CupertinoButton(
                child: Icon(
                  CupertinoIcons.back,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              floating: false,
              pinned: true,
              expandedHeight: size.width * 0.6,
              actions: [
                CupertinoButton(
                  child: new Icon(
                    CupertinoIcons.arrowshape_turn_up_right_circle,
                    size: 28,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.all(5),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.all(15),
                title: new Column(
                  children: [
                    Text('${playlistModel.first.title}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                background: new Column(
                  children: [
                    new SizedBox(
                      height: size.width * 0.15,
                    ),
                    new Container(
                      height: size.width * 0.4,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: NetworkImage(
                              'https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg',
                            ),
                            fit: BoxFit.cover),
                      ),
                    )
                  ],
                ),
              ),
            ),
            new SliverList(
              delegate: new SliverChildListDelegate(
                [
                  new Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            colorScheme.onSurface,
                            colorScheme.onPrimary
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(0.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: new Text(
                              "${playlistModel.first.title}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                          ),
                          new Text(
                            "Auther Name",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: colorScheme.secondaryVariant,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          new SizedBox(height: 10,),
                          // Padding(
                          //   padding: const EdgeInsets.all(15.0),
                          //   child: new Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       new Text("5 Episodes -||- 74 Followers", style: TextStyle(
                          //         color: colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 16
                          //       ),),
                          //     ],
                          //   ),
                          // ),
                          Container(
                              padding: EdgeInsets.all(5),
                              child: Builder(
                                builder: (_context) => new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(width: 5,),
                                    new CupertinoButton(
                                      minSize: 35,
                                      borderRadius: BorderRadius.circular(20),
                                      child: new Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.pencil,
                                            color: colorScheme.onSecondary,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10,),
                                          new Text(
                                            "Edit",
                                            style: TextStyle(
                                                color: colorScheme.onSecondary),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PlaylistUpdatePage(
                                                      playlistModel.first),
                                            ));
                                      },
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      color: colorScheme.primary,
                                    ),
                                    SizedBox(width: 5,),
                                    new CupertinoButton(
                                      minSize: 35,
                                      borderRadius: BorderRadius.circular(20),
                                      child: new Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.delete,
                                            color: colorScheme.onSecondary,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10,),
                                          new Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: colorScheme.onSecondary),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (context) =>
                                              CupertinoActionSheet(
                                            title: new Text(
                                              "Warning!",
                                              style: TextStyle(
                                                  color: colorScheme.primary),
                                            ),
                                            message: new Text(
                                                "You really want to delete this playlist?"),
                                            actions: [
                                              CupertinoActionSheetAction(
                                                child: new Text("Yes"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  onDeleteTap(
                                                      playlistModel.first.id,
                                                      context,
                                                      _context);
                                                },
                                              )
                                            ],
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                              child: new Text("No"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 5,),
                                    new CupertinoButton(
                                      minSize: 35,
                                      borderRadius: BorderRadius.circular(20),
                                      child: new Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.info,
                                            color: colorScheme.onSecondary,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10,),
                                          new Text(
                                            "Info",
                                            style: TextStyle(
                                                color: colorScheme.onSecondary),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (context) =>
                                              CupertinoActionSheet(
                                            title: new Text(
                                              "About",
                                              style: TextStyle(
                                                  color: colorScheme.primary),
                                            ),
                                            message: new Text(
                                              "${playlistModel.first.desc}",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: colorScheme
                                                      .secondaryVariant,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                              child: new Text("Dismiss"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      color: colorScheme.secondaryVariant,
                                    ),
                                    SizedBox(width: 5,),
                                    new CupertinoButton(
                                      minSize: 35,
                                      borderRadius: BorderRadius.circular(20),
                                      child: new Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.play_fill,
                                            color: colorScheme.onSecondary,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10,),
                                          new Text(
                                            "Play",
                                            style: TextStyle(
                                                color: colorScheme.onSecondary),
                                          )
                                        ],
                                      ),
                                      onPressed: () {

                                      },
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      color: colorScheme.secondary,
                                    ),
                                    SizedBox(width: 5,),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: new BoxConstraints(minHeight: size.height-70),
                    child: new Container(
                      color: colorScheme.onPrimary,
                      child: FutureBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data == true &&
                                episodeState.episodeModelList.length != 0) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: episodeState.episodeModelList.length,
                                padding: EdgeInsets.only(top: 5, bottom: 65),
                                itemBuilder: (context, index) {
                                  return new EpisodeListWidget(
                                      episodeState.episodeModelList[index].id);
                                },
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data == true &&
                                episodeState.episodeModelList.length == 0) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 25),
                                  child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.video_collection_outlined,
                                    size: 70,
                                    color: colorScheme.secondaryVariant,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Episodes Not Available",
                                    style: TextStyle(
                                        color: colorScheme.secondaryVariant,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  CupertinoButton(
                                    color: colorScheme.secondaryVariant,
                                    borderRadius: BorderRadius.circular(25),
                                    child: Shimmer.fromColors(
                                      child: new Text(
                                        "Add new episode",
                                        style: TextStyle(
                                            color: colorScheme.onPrimary),
                                      ),
                                      baseColor: colorScheme.onPrimary,
                                      highlightColor: colorScheme.primary,
                                    ),
                                    onPressed: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => NewPlaylistPage(),
                                      //     ));
                                    },
                                  )
                                ],
                              ));
                            } else if (snapshot.hasData &&
                                snapshot.data != true) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 25),
                                  child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 80,
                                    color: colorScheme.secondaryVariant,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Something went wrong!",
                                    style: TextStyle(
                                        color: colorScheme.secondaryVariant,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  CupertinoButton(
                                    color: colorScheme.secondaryVariant,
                                    borderRadius: BorderRadius.circular(25),
                                    child: Shimmer.fromColors(
                                      child: new Text(
                                        "Try again",
                                        style: TextStyle(
                                            color: colorScheme.onPrimary),
                                      ),
                                      baseColor: colorScheme.onPrimary,
                                      highlightColor: colorScheme.primary,
                                    ),
                                    onPressed: () {
                                      episodeFuture =
                                          EpisodeUtil.fetchAllEpisodeModel(
                                              context, widget.id);
                                    },
                                  )
                                ],
                              ));
                            } else {
                              return ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return EpisodeShimmer();
                                },
                              );
                            }
                          },
                          future: episodeFuture),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        icon: Icon(Icons.add, color: colorScheme.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        label: Shimmer.fromColors(
          child: new Text(
            "New Episode",
            style: TextStyle(color: colorScheme.onPrimary),
          ),
          baseColor: colorScheme.onPrimary,
          highlightColor: colorScheme.primary,
        ),
        tooltip: "Add New Episode",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewEpisodePage(playlistModel.first),
              ));
        },
      ),
    );
  }

  onDeleteTap(String id, context, _context) async {
    bool status = await PlaylistUtil.deletePlaylistModel(context, id);
    if (status) {
      GlobalData.showSnackBar(
          "Playlist deleted successfully!", _context, Colors.black);
      await PlaylistUtil.fetchAllPlaylistModel(context);
      Navigator.of(context).pop();
    } else {
      GlobalData.showSnackBar(
          "Failed to delete playlist!", _context, Colors.red);
    }
    // Navigator.of(context).pop();
  }
}
