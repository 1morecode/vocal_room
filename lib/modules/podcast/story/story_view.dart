import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';
import 'package:vocal/modules/podcast/story/util/story_util.dart';
import 'package:vocal/modules/podcast/story/widget/new_story_widget.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/global_data.dart';
import 'package:vocal/stories/model/story_item.dart';
import 'package:vocal/stories/library/story_view.dart';
import 'package:vocal/stories/model/story_model.dart';

class StoriesView extends StatefulWidget {
  @override
  _StoriesViewState createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  var firebaseAuth = FirebaseAuth.instance;
  Future<List<StoryModel>> storyFuture;

  @override
  void initState() {
    storyFuture = StoryUtil.fetchAllStoriesModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final podcastState = Provider.of<PodCastState>(context, listen: false);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<StoryModel>>(
      initialData:
          podcastState.storiesList != null ? podcastState.storiesList : [],
      builder: (context, snapshot) {
        if (snapshot.hasData && podcastState.storiesList != null) {
          return Stories(
            circlePadding: 2,
            paddingColor: colorScheme.primary,
            highLightColor: colorScheme.primary,
            fullpageVisitedColor: colorScheme.primary,
            fullpageUnisitedColor: colorScheme.onSecondary,
            displayProgress: true,
            storyItemList: List.generate(
                podcastState.storiesList.length,
                (index) => StoryItem(
                      name: firebaseAuth.currentUser.email ==
                              podcastState.storiesList[index].email
                          ? "Your Story"
                          : "${podcastState.storiesList[index].name}",
                      uId: "${podcastState.storiesList[index].uid}",
                      thumbnail: NetworkImage(
                        "${podcastState.storiesList[index].picture}",
                      ),
                      stories: List.generate(
                          podcastState.storiesList[index].status.length,
                          (ind) => Scaffold(
                                backgroundColor: Colors.black,
                                body:
                                    firebaseAuth.currentUser.email ==
                                            podcastState
                                                .storiesList[index].email
                                        ? Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.contain,
                                                    image: NetworkImage(
                                                      "${APIData.imageBaseUrl}${podcastState.storiesList[index].status[ind].assets}",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              new Container(
                                                width: size.width,
                                                alignment: Alignment.center,
                                                child: new Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Spacer(),
                                                    new Container(
                                                      width: size.width,
                                                      child: new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          CupertinoButton(
                                                            child: new Icon(
                                                                CupertinoIcons
                                                                    .chevron_left_circle),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                          ),
                                                          new Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              new Text(
                                                                "${podcastState.storiesList[index].status[ind].viewsId.length}",
                                                                style: TextStyle(
                                                                    color: colorScheme
                                                                        .primary,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                  CupertinoIcons
                                                                      .eye),
                                                            ],
                                                          ),
                                                          Builder(
                                                            builder: (_context) =>
                                                                new CupertinoButton(
                                                                    child: new Icon(
                                                                        CupertinoIcons
                                                                            .delete),
                                                                    onPressed:
                                                                        () async {
                                                                      bool status = await StoryUtil.deleteStatusView(
                                                                          context,
                                                                          podcastState
                                                                              .storiesList[index]
                                                                              .status[ind]
                                                                              .assetsId);
                                                                      if (status ==
                                                                          true) {
                                                                        GlobalData.showSnackBar(
                                                                            "Status deleted successfully!",
                                                                            _context,
                                                                            Colors.black);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        await StoryUtil.fetchAllStoriesModel(
                                                                            context);
                                                                      } else {
                                                                        GlobalData.showSnackBar(
                                                                            "Failed to delete status!",
                                                                            _context,
                                                                            Colors.black);
                                                                      }
                                                                    },
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5)),
                                                          )
                                                        ],
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: colorScheme
                                                            .onSurface
                                                            .withOpacity(0.5),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          EdgeInsets.all(15),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image: NetworkImage(
                                                  "${APIData.imageBaseUrl}${podcastState.storiesList[index].status[ind].assets}",
                                                ),
                                              ),
                                            ),
                                          ),
                              )),
                    )),
          );
        } else {
          return new Container(
              width: size.width,
              height: 125,
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Container(
                    alignment: Alignment.center,
                    height: 125,
                    child: NewStoryButton(),
                  ),
                  Expanded(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        itemBuilder: (context, index) => new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                new Container(
                                  width: 80,
                                  height: 80,
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                                new Container(
                                  width: 70,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            )),
                  )
                ],
              ));
        }
      },
      future: storyFuture,
    );
  }
}
