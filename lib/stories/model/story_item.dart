import 'package:flutter/material.dart';

class StoryItem {
  /// Name of the story circle
  String name;

  String uId;

  /// Image to display on the circle of the image
  ImageProvider thumbnail;

  /// List of pages to display as stories under this story
  List<Scaffold> stories;

  /// Add a story
  StoryItem(
      {@required this.name, @required this.uId, @required this.thumbnail, @required this.stories});
}
