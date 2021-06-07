import 'package:audio_service/audio_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/mainPage/profile/my_profile_page.dart';
import 'package:vocal/mainPage/profile/user_profile_page.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/util/episode_util.dart';
import 'package:vocal/modules/dashboard/playlist/shimmer/episode_shimmer.dart';
import 'package:vocal/modules/dashboard/savedPlaylist/util/playlist_pref.dart';
import 'package:vocal/modules/podcast/model/pod_cast_episode_model.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';
import 'package:vocal/modules/podcast/model/user.dart';
import 'package:vocal/modules/podcast/playlist/widget/episode_card_widget.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';
import 'package:vocal/playerState/audio_service_state.dart';
import 'package:vocal/playerState/playlist_shared_pref.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/user_token.dart';
import 'package:vocal/res/widgets/circular_tab_indicator.dart';
import 'package:vocal/res/widgets/follow_unfollow_btn.dart';

class PlayListPage extends StatefulWidget {
final PodCastPlaylistModel podCastPlaylistModel;

PlayListPage(this.podCastPlaylistModel);

  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  int initialIndex = 0;
  String isSaved = "Save";
  Future<bool> episodesFuture;
  bool followed = false;
  var firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    episodesFuture = EpisodeUtil.fetchAllEpisodeModel(context, widget.podCastPlaylistModel.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var playlistState = Provider.of<PodCastState>(context, listen: true);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    var savedPlaylistState =
    Provider.of<SavedPlaylistState>(context, listen: true);
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: colorScheme.onSurface,
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
                    CupertinoIcons.arrowshape_turn_up_right_fill,
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
                    Text(
                        '${widget.podCastPlaylistModel.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                              "${APIData.imageBaseUrl}${widget.podCastPlaylistModel.image}",
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
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: new Column(
                        children: [
                          new Text(
                            "${widget.podCastPlaylistModel.title}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: colorScheme.onSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                          new Text(
                             "${widget.podCastPlaylistModel.collection}",
                            style: TextStyle(
                                color: colorScheme.secondaryVariant,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                new SizedBox(
                                  width: size.width * 0.3,
                                  child: CupertinoButton(
                                      minSize: 25,
                                      padding: EdgeInsets.all(7),
                                      borderRadius: BorderRadius.circular(25),
                                      color: colorScheme.primary,
                                      child: new Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          new Icon(
                                            getSaved(context, widget.podCastPlaylistModel.id) ==
                                                "Save"
                                                ? CupertinoIcons.heart
                                                : CupertinoIcons.heart_fill,
                                            color: colorScheme.onSecondary,
                                          ),
                                          new Text(
                                            "Favorite",
                                            style: TextStyle(
                                                color: colorScheme.onSecondary),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        if (savedPlaylistState
                                            .playlists.length !=
                                            0) {
                                          for (var i = 0;
                                          i <
                                              savedPlaylistState
                                                  .playlists.length;
                                          i++) {
                                            print(
                                                "$i  ${savedPlaylistState.playlists.length}");
                                            PodCastPlaylistModel p =
                                            savedPlaylistState.playlists[i];
                                            if (p.id ==
                                                widget.podCastPlaylistModel
                                                    .id) {
                                              print("Contains");
                                              savedPlaylistState.playlists
                                                  .remove(p);
                                              savedPlaylistState
                                                  .removePlaylist();
                                              break;
                                            } else if (i + 1 ==
                                                savedPlaylistState
                                                    .playlists.length) {
                                              print("Not Contains");
                                              savedPlaylistState.addNewPlaylist(
                                                  widget.podCastPlaylistModel);
                                              break;
                                            } else {
                                              print('Nothing');
                                            }
                                          }
                                        } else {
                                          savedPlaylistState.addNewPlaylist(
                                              widget.podCastPlaylistModel);
                                        }
                                      }),
                                ),
                                new SizedBox(
                                  width: size.width * 0.3,
                                  child: CupertinoButton(
                                      minSize: 25,
                                      padding: EdgeInsets.all(7),
                                      borderRadius: BorderRadius.circular(25),
                                      color: colorScheme.secondary,
                                      child: new Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          new Icon(
                                            CupertinoIcons.play_arrow_solid,
                                            color: colorScheme.onSecondary,
                                          ),
                                          new Text(
                                            "Play All",
                                            style: TextStyle(
                                                color: colorScheme.onSecondary),
                                          )
                                        ],
                                      ),
                                      onPressed: () async {
                                        if (playlistState
                                            .episodeModelList.length !=
                                            0) {
                                          AudioService.stop();
                                          await PlaylistSharedPref
                                              .savePreferences(playlistState
                                              .episodeModelList);
                                          setState(() {
                                            PodCastEpisodeModel.episodesList =
                                                playlistState.episodeModelList;
                                            print(
                                                "PLAYLIST 1 ${playlistState.episodeModelList[0].title}");
                                          });
                                          print(
                                              "SSSS ${PodCastEpisodeModel.episodesList.length}");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AudioMainScreen(0),
                                              ));
                                        }
                                      }),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  new DefaultTabController(
                    length: 2,
                    initialIndex: initialIndex,
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          indicator: CircleTabIndicator(
                              color: colorScheme.onSecondary, radius: 4),
                          onTap: (val) {
                            setState(() {
                              initialIndex = val;
                            });
                          },
                          tabs: [
                            Tab(
                              child: new Text("Episodes"),
                            ),
                            Tab(
                              child: new Text("About"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  initialIndex == 0
                      ? ConstrainedBox(
                    constraints:
                    new BoxConstraints(minHeight: size.height),
                    child: new Container(
                      color: colorScheme.onPrimary,
                      child: _getEpisodesWidget(context,
                          widget.podCastPlaylistModel.id),
                    ),
                  )
                      : ConstrainedBox(
                    constraints:
                    new BoxConstraints(minHeight: size.height),
                    child: _getAboutWidget(
                        widget.podCastPlaylistModel.desc,
                        widget.podCastPlaylistModel.uId),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getSaved(context, id) {
    var savedPlaylistState =
    Provider.of<SavedPlaylistState>(context, listen: true);
    for (var i = 0; i < savedPlaylistState.playlists.length; i++) {
      print("$i  ${savedPlaylistState.playlists.length}");
      PodCastPlaylistModel p = savedPlaylistState.playlists[i];
      if (p.id == id) {
        isSaved = "Remove";
        break;
      } else if (i + 1 == savedPlaylistState.playlists.length) {
        isSaved = "Save";
        break;
      } else {
        print('Save');
      }
    }
    return isSaved;
  }

  _getEpisodesWidget(context, id) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final playlistState = Provider.of<PodCastState>(context, listen: true);
    // var currentPlayerState = Provider.of<CurrentPlayerState>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: new BoxConstraints(minHeight: size.height - 70),
      child: new Container(
        color: colorScheme.onPrimary,
        child: FutureBuilder(
            builder: (context, snapshot) {
              print("SSS ${snapshot.hasData}");
              if (snapshot.hasData &&
                  playlistState.episodeModelList.length != 0) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: playlistState.episodeModelList.length,
                  padding: EdgeInsets.only(top: 5, bottom: 65),
                  itemBuilder: (context, index) {
                    return CupertinoButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        PodCastEpisodeModel.episodesList =
                            playlistState.episodeModelList;
                        // currentPlayerState.updateCurrentPlayingState(null, EpisodeModel.episodesList,EpisodeModel.episodesList[0]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AudioMainScreen(0),
                            ));
                      },
                      child: new EpisodeListWidget(
                          playlistState.episodeModelList[index].id),
                    );
                  },
                );
              } else if (snapshot.hasData &&
                  playlistState.episodeModelList.length == 0) {
                return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 25,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/no_record_found.png",
                          height: 70,
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
            future: episodesFuture),
      ),
    );
  }

  _getAboutWidget(desc, uid) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return new Container(
      padding: EdgeInsets.all(25),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.onPrimary,
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: FutureBuilder<UserModel>(
              future: UserToken.getUserByUId(uid),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return new Row(
                    children: [
                      CupertinoButton(
                          padding: EdgeInsets.all(0),
                          child: CircleAvatar(
                            backgroundColor: colorScheme.onSurface,
                            radius: 25,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                "${snapshot.data.picture}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onPressed: () {
                            print("UU $uid  ${firebaseAuth.currentUser.uid}");
                            if (uid == firebaseAuth.currentUser.uid) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyProfilePage(),
                                  ));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserProfilePage(uid),
                                  ));
                            }
                          }),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${snapshot.data.name}",
                                  style: TextStyle(
                                    color: colorScheme.onSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                new Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Playlist Creator",
                                      style: TextStyle(
                                          color: colorScheme.secondaryVariant,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Spacer(),
                                    new SizedBox(
                                      width: 90,
                                      child: FollowUnfollowButton(
                                        uid: uid,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ))
                    ],
                  );
                } else {
                  return new Container(
                    height: 50,
                  );
                }
              },
            ),
          ),
          new SizedBox(
            height: 10,
          ),
          new Text(
            "$desc",
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondaryVariant,
                fontSize: 16,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
