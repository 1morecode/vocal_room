import 'package:flutter/material.dart';
import 'package:vocal/stories/model/story_item.dart';
import 'package:vocal/stories/library/story_circle_widget.dart';
import 'package:vocal/modules/podcast/story/widget/new_story_widget.dart';

class Stories extends StatelessWidget {
  /// Recieves the list of stories to display
  final List<StoryItem> storyItemList;

  /// Text style below the story circle
  final TextStyle storyCircleTextStyle;

  /// Color of the story border
  final Color highLightColor;

  /// Radius of the story circle
  final double circleRadius;

  /// Space between the story and its border
  final double circlePadding;

  /// Thickness of the border
  final double borderThickness;

  /// Textstyle of title of a story group
  final TextStyle fullPagetitleStyle;

  /// Color for region between border and circle
  final Color paddingColor;

  /// Choose whether progress has to be shown
  final bool displayProgress;

  /// Color for visited region in progress indicator
  final Color fullpageVisitedColor;

  /// Color for non visited region in progress indicator
  final Color fullpageUnisitedColor;

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

  Stories({
    this.storyItemList,
    this.storyCircleTextStyle,
    this.highLightColor,
    this.circleRadius,
    this.circlePadding,
    this.borderThickness,
    this.fullPagetitleStyle,
    this.paddingColor,
    this.displayProgress,
    this.fullpageVisitedColor,
    this.fullpageUnisitedColor,
    this.spaceBetweenStories,
    this.showThumbnailOnFullPage,
    this.fullpageThumbnailSize,
    this.showStoryNameOnFullPage,
    this.storyStatusBarColor,
  });
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: new Row(
          children: [
            NewStoryButton(),
            storyItemList == null
                ? Container()
                : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                storyItemList.length,
                    (index) => StoryCircle(
                  story: storyItemList,
                  selectedIndex: index,
                  storyCircleTextStyle: storyCircleTextStyle,
                  highLightColor: highLightColor,
                  circleRadius: circleRadius,
                  circlePadding: circlePadding,
                  borderThickness: borderThickness,
                  displayProgress: displayProgress,
                  fullPagetitleStyle: fullPagetitleStyle,
                  paddingColor: paddingColor,
                  fullpageUnvisitedColor: fullpageUnisitedColor,
                  fullpageVisitedColor: fullpageVisitedColor,
                  spaceBetweenStories: spaceBetweenStories,
                  fullpageThumbnailSize: fullpageThumbnailSize,
                  showStoryNameOnFullPage: showStoryNameOnFullPage,
                  showThumbnailOnFullPage: showThumbnailOnFullPage,
                  storyStatusBarColor: storyStatusBarColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}