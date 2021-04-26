import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/util/episode_state.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/util/episode_util.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/view/new_episode_page.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/widget/episode_list_widget.dart';
import 'package:vocal/modules/dashboard/playlist/shimmer/episode_shimmer.dart';
import 'package:vocal/modules/dashboard/playlist/util/playlist_state.dart';
import 'package:vocal/modules/dashboard/playlist/util/playlist_util.dart';
import 'package:vocal/modules/dashboard/playlist/view/playlist_update_page.dart';
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
    episodeFuture = EpisodeUtil.fetchAllEpisodeModel(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    final episodeState = Provider.of<EpisodeState>(context, listen: true);
    final playlistState = Provider.of<PlaylistState>(context, listen: true);
    var playlistModel = playlistState.playlistModelList
        .where((element) => element.id == widget.id);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle:
            new Text("${playlistModel.first.title}"),
      ),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Image.network(
                          '${playlistModel.first.image}',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${playlistModel.first.title}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${playlistModel.first.desc}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: colorScheme.secondaryVariant),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            new Row(
                              children: [
                                Chip(
                                  label: new Text("Episodes : 5"),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  backgroundColor: colorScheme.onPrimary,
                                  labelStyle:
                                      TextStyle(color: colorScheme.primary),
                                  elevation: 0,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Chip(
                                  label: new Text("Followers : 74"),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  backgroundColor: colorScheme.onPrimary,
                                  labelStyle:
                                      TextStyle(color: colorScheme.primary),
                                  elevation: 0,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 130,
                  ),
                  new CupertinoButton(
                    child: new Container(
                      height: 45,
                      width: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colorScheme.onPrimary,
                      ),
                      child: Icon(
                        CupertinoIcons.pencil,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaylistUpdatePage(
                                playlistModel.first),
                          ));
                    },
                    padding: EdgeInsets.all(0),
                  ),
                  Spacer(),
                  Builder(
                    builder: (_context) => new CupertinoButton(
                      child: new Container(
                        height: 45,
                        width: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colorScheme.onPrimary,
                        ),
                        child: Icon(
                          CupertinoIcons.delete,
                          color: colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            title: new Text(
                              "Warning!",
                              style: TextStyle(color: colorScheme.primary),
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
                            cancelButton: CupertinoActionSheetAction(
                              child: new Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        );
                      },
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                  Spacer(),
                  new CupertinoButton(
                    child: new Container(
                      height: 45,
                      width: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colorScheme.onPrimary,
                      ),
                      child: Icon(
                        CupertinoIcons.info_circle,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          title: new Text(
                            "About",
                            style: TextStyle(color: colorScheme.primary),
                          ),
                          message: new Text(
                              "${playlistModel.first.desc}", textAlign: TextAlign.start, style: TextStyle(color: colorScheme.secondaryVariant, fontSize: 18, fontWeight: FontWeight.w400),),
                          cancelButton: CupertinoActionSheetAction(
                            child: new Text("Dismiss"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                    padding: EdgeInsets.all(0),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Text(
                "All Episodes",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: colorScheme.onSecondary),
              ),
            ),
            FutureBuilder(
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
                    return Center(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.video_collection_outlined,
                              size: 100,
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
                                  style: TextStyle(color: colorScheme.onPrimary),
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
                  } else if (snapshot.hasData && snapshot.data != true) {
                    return Center(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 100,
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
                                  style: TextStyle(color: colorScheme.onPrimary),
                                ),
                                baseColor: colorScheme.onPrimary,
                                highlightColor: colorScheme.primary,
                              ),
                              onPressed: () {
                                episodeFuture = EpisodeUtil.fetchAllEpisodeModel(context);
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
                future: episodeFuture)
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
                builder: (context) => NewEpisodePage(
                    playlistModel.first),
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
