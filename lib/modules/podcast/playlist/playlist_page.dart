import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/podcast/model/episode_model.dart';
import 'package:vocal/modules/podcast/playlist/widget/episode_card_widget.dart';
import 'package:vocal/modules/podcast/state/current_player_state.dart';
import 'package:vocal/res/widgets/circular_tab_indicator.dart';
import 'package:vocal/state/audio_state.dart';
import 'package:vocal/state/test.dart';

class PlayListPage extends StatefulWidget {

  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  int initialIndex = 0;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    var currentPlayerState = Provider.of<CurrentPlayerState>(context, listen: true);
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
                    Text('Playlist Title',
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
                    child: new Column(
                      children: [
                        new Text(
                          "Playlist Title",
                          style: TextStyle(
                              color: colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        new Text(
                          "Auther Name",
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
                                          CupertinoIcons.add,
                                          color: colorScheme.onSecondary,
                                        ),
                                        new Text(
                                          "Follow",
                                          style: TextStyle(
                                              color: colorScheme.onSecondary),
                                        )
                                      ],
                                    ),
                                    onPressed: () {}),
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
                                    onPressed: () {
                                      currentPlayerState.updateCurrentPlayingState(null, EpisodeModel.episodesList,EpisodeModel.episodesList[0]);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AudioMainScreen(0),));
                                    }),
                              ),
                            ],
                          ),
                        )
                      ],
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
                            child: _getEpisodesWidget(),
                          ),
                        )
                      : ConstrainedBox(
                          constraints:
                              new BoxConstraints(minHeight: size.height),
                          child: _getAboutWidget(),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getEpisodesWidget() {
    return FutureBuilder(
      builder: (context, snapshot) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: EpisodeModel.episodesList.length,
          itemBuilder: (context, index) {
            return EpisodeCardWidget(EpisodeModel.episodesList[index], index);
          },
        );
      },
    );
  }

  _getAboutWidget() {
    return new Container(
      padding: EdgeInsets.all(15),
      child: new Text(
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.\n\nLorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\n\nIt has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }

}
