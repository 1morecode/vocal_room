import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vocal/modules/podcast/story/util/story_util.dart';
import 'package:vocal/stories/model/story_item.dart';
import 'package:vocal/stories/library/story_view.dart';
import 'package:vocal/stories/model/story_model.dart';

class StoriesView extends StatefulWidget {
  @override
  _StoriesViewState createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  var firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<StoryModel>>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stories(
            circlePadding: 2,
            paddingColor: colorScheme.primary,
            highLightColor: colorScheme.primary,
            fullpageVisitedColor: colorScheme.primary,
            fullpageUnisitedColor: colorScheme.onSecondary,
            displayProgress: true,
            storyItemList: List.generate(snapshot.data.length, (index) => StoryItem(
              name: firebaseAuth.currentUser.email == snapshot.data[index].email ? "Your Story" : "${snapshot.data[index].name}",
              thumbnail: NetworkImage(
                "${snapshot.data[index].picture}",
              ),
              stories: List.generate(snapshot.data[index].status.length, (ind) => Scaffold(
                backgroundColor: Colors.black,
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "${snapshot.data[index].status[ind].assetsUrl}",
                      ),
                    ),
                  ),
                ),
              )),
            )),
          );
        } else {
          return new Container();
        }
      },
      future: StoryUtil.fetchAllStoriesModel(context),
    );
  }
}
