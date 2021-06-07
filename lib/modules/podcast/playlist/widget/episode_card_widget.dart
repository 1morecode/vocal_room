import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/podcast/model/pod_cast_episode_model.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';
import 'package:vocal/res/api_data.dart';

class EpisodeListWidget extends StatefulWidget {
  final String id;

  EpisodeListWidget(this.id);

  @override
  _EpisodeListWidgetState createState() => _EpisodeListWidgetState();
}

class _EpisodeListWidgetState extends State<EpisodeListWidget> {

  @override
  Widget build(BuildContext context) {
    final episodeState = Provider.of<PodCastState>(context, listen: true);
    Iterable<PodCastEpisodeModel> episodeModel = episodeState.episodeModelList
        .where((element) => element.id == widget.id);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child:  new Row(
          children: [
            Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  '${APIData.imageBaseUrl}${episodeModel.first.graphic[0]['path']}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${episodeModel.first.title}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: colorScheme.onSecondary
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${episodeModel.first.desc}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: colorScheme.secondaryVariant),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
