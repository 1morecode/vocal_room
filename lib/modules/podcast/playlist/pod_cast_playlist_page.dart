import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/util/episode_util.dart';
import 'package:vocal/modules/dashboard/playlist/shimmer/episode_shimmer.dart';
import 'package:vocal/modules/dashboard/savedPlaylist/util/playlist_pref.dart';
import 'package:vocal/modules/podcast/model/pod_cast_episode_model.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';
import 'package:vocal/modules/podcast/playlist/widget/episode_card_widget.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';
import 'package:vocal/playerState/audio_service_state.dart';
import 'package:vocal/playerState/playlist_shared_pref.dart';
import 'package:vocal/res/widgets/circular_tab_indicator.dart';

class PlayListPage extends StatefulWidget {
  final int index;
  final String id;
  final bool saved;

  PlayListPage(this.index, this.saved, this.id);

  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  int initialIndex = 0;
  String isSaved = "Save";
  Future<bool> episodesFuture;

  @override
  void initState() {
    episodesFuture = EpisodeUtil.fetchAllEpisodeModel(context, widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var playlistState = Provider.of<PodCastState>(context, listen: true);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    // final episodeState = Provider.of<PodCastState>(context, listen: true);
    var savedPlaylistState = Provider.of<SavedPlaylistState>(context, listen: true);
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
                    Text(widget.saved ? '${savedPlaylistState.playlists[widget.index].title}' : '${playlistState.podCastPlaylistList[widget.index].title}',
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
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: new Column(
                        children: [
                          new Text(
                            widget.saved ? '${savedPlaylistState.playlists[widget.index].title}' : "${playlistState.podCastPlaylistList[widget.index].title}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: colorScheme.onSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                          new Text(
                            widget.saved ? '${savedPlaylistState.playlists[widget.index].collection}' : "${playlistState.podCastPlaylistList[widget.index].collection}",
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
                                            isSaved == "Save" ? CupertinoIcons.heart: CupertinoIcons.heart_fill,
                                            color: colorScheme.onSecondary,
                                          ),
                                          new Text(
                                            "${getSaveText(context, playlistState.podCastPlaylistList[widget.index].id)}",
                                            style: TextStyle(
                                                color: colorScheme.onSecondary),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        if(savedPlaylistState.playlists.length != 0){
                                          for(var i = 0; i < savedPlaylistState.playlists.length; i++){
                                            print("$i  ${savedPlaylistState.playlists.length}");
                                            PodCastPlaylistModel p = savedPlaylistState.playlists[i];
                                            if(p.id == playlistState.podCastPlaylistList[widget.index].id){
                                              print("Contains");
                                              savedPlaylistState.playlists.remove(p);
                                              savedPlaylistState.removePlaylist();
                                              break;
                                            }else if(i+1 == savedPlaylistState.playlists.length){
                                              print("Not Contains");
                                              savedPlaylistState.addNewPlaylist(playlistState.podCastPlaylistList[widget.index]);
                                              break;
                                            }else{
                                              print('Nothing');
                                            }
                                          }
                                        }else{
                                          savedPlaylistState.addNewPlaylist(playlistState.podCastPlaylistList[widget.index]);
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
                                      onPressed: () async{
                                        if(playlistState.episodeModelList.length != 0){
                                          await PlaylistSharedPref.savePreferences(playlistState.episodeModelList);
                                          setState(() {
                                            PodCastEpisodeModel.episodesList = playlistState.episodeModelList;
                                            print("PLAYLIST 1 ${playlistState.episodeModelList[0].title}");
                                          });
                                          print("SSSS ${PodCastEpisodeModel.episodesList.length}");
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AudioMainScreen(0),));
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
                            child: _getEpisodesWidget(context, playlistState.podCastPlaylistList[widget.index].id),
                          ),
                        )
                      : ConstrainedBox(
                          constraints:
                              new BoxConstraints(minHeight: size.height),
                          child: _getAboutWidget(playlistState.podCastPlaylistList[widget.index].desc),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  String getSaveText(context, id){
    var savedPlaylistState = Provider.of<SavedPlaylistState>(context, listen: true);
    for(var i = 0; i < savedPlaylistState.playlists.length; i++){
      print("$i  ${savedPlaylistState.playlists.length}");
      PodCastPlaylistModel p = savedPlaylistState.playlists[i];
      if(p.id == id){
        isSaved = "Remove";
        break;
      }else if(i+1 == savedPlaylistState.playlists.length){
        isSaved = "Save";
        break;
      }else{
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
      constraints: new BoxConstraints(minHeight: size.height-70),
      child: new Container(
        color: colorScheme.onPrimary,
        child: FutureBuilder(
            builder: (context, snapshot) {
              print("SSS ${snapshot.hasData}");
              if (snapshot.hasData && playlistState.episodeModelList.length != 0) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: playlistState.episodeModelList.length,
                  padding: EdgeInsets.only(top: 5, bottom: 65),
                  itemBuilder: (context, index) {
                    return CupertinoButton(
                      padding: EdgeInsets.all(0),
                      onPressed: (){
                        PodCastEpisodeModel.episodesList = playlistState.episodeModelList;
                        // currentPlayerState.updateCurrentPlayingState(null, EpisodeModel.episodesList,EpisodeModel.episodesList[0]);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AudioMainScreen(0),));
                      },
                      child: new EpisodeListWidget(
                          playlistState.episodeModelList[index].id),
                    );
                  },
                );
              } else if (snapshot.hasData &&
                  playlistState.episodeModelList.length == 0) {
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
                      ],
                    ));
              }else {
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

  _getAboutWidget(desc) {
    return new Container(
      padding: EdgeInsets.all(25),
      child: new Text(
          "$desc",style: TextStyle(color: Theme.of(context).colorScheme.secondaryVariant, fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }

}
