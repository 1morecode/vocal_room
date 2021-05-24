import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class EpisodeBrief extends Equatable {
  final String title;
  final String description;
  final int pubDate;
  final int enclosureLength;
  final String enclosureUrl;
  final String feedTitle;
  final String primaryColor;
  final int duration;
  final int explicit;
  final String imagePath;
  final String mediaId;
  final int isNew;
  final int skipSecondsStart;
  final int skipSecondsEnd;
  final String episodeImage;
  final String chapterLink;

  EpisodeBrief(
      this.title,
      this.enclosureUrl,
      this.enclosureLength,
      this.pubDate,
      this.feedTitle,
      this.primaryColor,
      this.duration,
      this.explicit,
      this.imagePath,
      this.isNew,
      {this.mediaId,
        this.skipSecondsStart,
        this.skipSecondsEnd,
        this.description = '',
        this.chapterLink = '',
        this.episodeImage = ''})
      : assert(enclosureUrl != null);

  MediaItem toMediaItem() {
    return MediaItem(
        id: mediaId,
        title: title,
        artist: feedTitle,
        album: feedTitle,
        duration: Duration.zero,
        artUri: imagePath == '' ? episodeImage : Uri.parse('file://$imagePath'),
        extras: {
          'skipSecondsStart': skipSecondsStart,
          'skipSecondsEnd': skipSecondsEnd
        });
  }

  ImageProvider get avatarImage {
    return File(imagePath).existsSync()
        ? FileImage(File(imagePath))
        : File(episodeImage).existsSync()
        ? FileImage(File(episodeImage))
        : (episodeImage != '')
        ? CachedNetworkImageProvider(episodeImage)
        : AssetImage('assets/avatar_backup.png');
  }

  Color backgroundColor(BuildContext context) {
    if (primaryColor == '') return Theme.of(context).colorScheme.primary;
    return Theme.of(context).colorScheme.onPrimary;
  }

  EpisodeBrief copyWith({
    String mediaId,
  }) =>
      EpisodeBrief(title, enclosureUrl, enclosureLength, pubDate, feedTitle,
          primaryColor, duration, explicit, imagePath, isNew,
          mediaId: mediaId ?? this.mediaId,
          skipSecondsStart: skipSecondsStart,
          skipSecondsEnd: skipSecondsEnd,
          description: description);

  @override
  List<Object> get props => [enclosureUrl, title];
}
