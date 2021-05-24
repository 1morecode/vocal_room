import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vocal/modules/podcast/story/util/story_util.dart';
import 'package:vocal/modules/podcast/story/widget/new_story_widget.dart';
import 'package:vocal/res/api_data.dart';
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
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<StoryModel>>(
      initialData: StoryUtil.storiesList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stories(
            circlePadding: 2,
            paddingColor: colorScheme.primary,
            highLightColor: colorScheme.primary,
            fullpageVisitedColor: colorScheme.primary,
            fullpageUnisitedColor: colorScheme.onSecondary,
            displayProgress: true,
            storyItemList: List.generate(
                snapshot.data.length,
                (index) => StoryItem(
                      name: firebaseAuth.currentUser.email ==
                              snapshot.data[index].email
                          ? "Your Story"
                          : "${snapshot.data[index].name}",
                      thumbnail: NetworkImage(
                        "${snapshot.data[index].picture}",
                      ),
                      stories: List.generate(
                          snapshot.data[index].status.length,
                          (ind) => Scaffold(
                                backgroundColor: Colors.black,
                                body: firebaseAuth.currentUser.email ==
                                        snapshot.data[index].email
                                    ? Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image: NetworkImage(
                                                  "${APIData.imageBaseUrl}${snapshot.data[index].status[ind].assetsUrl}",
                                                ),
                                              ),
                                            ),
                                          ),
                                          new Container(
                                            width: size.width,
                                            child: new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Spacer(),
                                                new Container(
                                                  width: size.width,
                                                  child: new Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      new Text(
                                                          "${snapshot.data[index].status[ind].views} Views", style: TextStyle(color: colorScheme.primary, fontSize: 16, fontWeight: FontWeight.w400),),
                                                      new CupertinoButton(
                                                        child: new Text(
                                                            "Delete"),
                                                        onPressed: () {},
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 15,
                                                          vertical: 0,
                                                        ),
                                                        minSize: 15,
                                                      )
                                                    ],
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: colorScheme.onSurface
                                                        .withOpacity(0.5),
                                                  ),
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.all(15),
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
                                              "${APIData.imageBaseUrl}${snapshot.data[index].status[ind].assetsUrl}",
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
