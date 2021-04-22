import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/libraries/stories/Stories_for_Flutter.dart';
import 'package:vocal/libraries/stories/fullPageView.dart';

class StoryCircle extends StatelessWidget {
  final List<StoryItem> story;
  final int selectedIndex;
  final TextStyle storyCircleTextStyle;
  final Color highLightColor;
  final double circleRadius;
  final double circlePadding;
  final double borderThickness;
  final TextStyle fullPagetitleStyle;
  final Color paddingColor;

  /// Choose whether progress has to be shown
  final bool displayProgress;

  /// Color for visited region in progress indicator
  final Color fullpageVisitedColor;

  /// Color for non visited region in progress indicator
  final Color fullpageUnvisitedColor;

  /// Horizontal space between stories
  final double spaceBetweenStories;

  /// Whether image has to be show on top left of the page
  final bool showThumbnailOnFullPage;

  /// Size of the top left image
  final double fullpageThumbnailSize;

  /// Whether image has to be show on top left of the page
  final bool showStoryNameOnFullPage;

  /// Status bar color in full view of story
  final Color storyStatusBarColor;

  StoryCircle({
    this.story,
    this.selectedIndex,
    this.storyCircleTextStyle,
    this.highLightColor,
    this.circleRadius,
    this.circlePadding,
    this.borderThickness,
    this.fullPagetitleStyle,
    this.paddingColor,
    this.displayProgress,
    this.fullpageVisitedColor,
    this.fullpageUnvisitedColor,
    this.spaceBetweenStories,
    this.showThumbnailOnFullPage,
    this.fullpageThumbnailSize,
    this.showStoryNameOnFullPage,
    this.storyStatusBarColor,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    double altRadius = 32;
    double altPadding;
    if (circleRadius != null) {
      altRadius = circleRadius;
    }
    if (circlePadding != null) {
      altPadding = altRadius + circlePadding;
    } else
      altPadding = altRadius + 3;
    return Container(
      margin: EdgeInsets.fromLTRB(
        spaceBetweenStories ?? 5,
        0,
        spaceBetweenStories ?? 5,
        10,
      ),
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullPageView(
                storiesMapList: story,
                storyNumber: selectedIndex,
                fullPagetitleStyle: fullPagetitleStyle,
                displayProgress: displayProgress,
                fullpageVisitedColor: fullpageVisitedColor,
                fullpageUnvisitedColor: fullpageUnvisitedColor,
                fullpageThumbnailSize: fullpageThumbnailSize,
                showStoryNameOnFullPage: showStoryNameOnFullPage,
                showThumbnailOnFullPage: showThumbnailOnFullPage,
                storyStatusBarColor: storyStatusBarColor,
              ),
            ),
          );
        },
        child: new Container(
          width: 80,
          child: Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.secondary, width: 2)),
                child: CircleAvatar(
                    radius: altRadius,
                    backgroundColor: colorScheme.onPrimary,
                    backgroundImage: story[selectedIndex].thumbnail),
              ),

              new SizedBox(
                height: 5,
              ),
              Text(
                story[selectedIndex].name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: storyCircleTextStyle ?? TextStyle(fontSize: 13, color: colorScheme.onSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
