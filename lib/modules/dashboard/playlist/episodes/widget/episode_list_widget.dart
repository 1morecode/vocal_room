import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/util/episode_util.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/view/episode_update_page.dart';
import 'package:vocal/modules/podcast/model/pod_cast_episode_model.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/global_data.dart';

class EpisodeListWidget extends StatefulWidget {
  final String id;
  final PodCastPlaylistModel playlistModel;

  EpisodeListWidget(this.id, this.playlistModel);

  @override
  _EpisodeListWidgetState createState() => _EpisodeListWidgetState();
}

class _EpisodeListWidgetState extends State<EpisodeListWidget> {
  List<String> ll = ["Delete", "Edit"];

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
      child: Row(
        children: [
          Expanded(
            child: new Row(
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
          PopupMenuButton(
            padding: EdgeInsets.all(0),
            color: colorScheme.onSurface,
            offset: Offset(-20, 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                    color: colorScheme.secondaryVariant, width: 1)),
            onSelected: (value) {
              print(value);
              if (value == "Delete") {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: new Text(
                      "Warning!",
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    message: new Text(
                        "You really want to delete this episode?"),
                    actions: [
                      CupertinoActionSheetAction(
                        child: new Text("Yes"),
                        onPressed: () {
                          onDeleteTap(
                              episodeModel.first.id, context);
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: new Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              } else if (value == "Edit") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdateEpisodePage(episodeModel.first, widget.playlistModel),
                    ));
              }
            },
            itemBuilder: (BuildContext context) {
              return ll.map((link) {
                return PopupMenuItem(
                  textStyle: TextStyle(color: colorScheme.primary),
                  height: 40,
                  value: link,
                  child: Text(link),
                );
              }).toList();
            },
          )
        ],
      ),
    );
  }

  onDeleteTap(String id, context) async {
    // bool status = await EpisodeUtil.deleteEpisodeModel(context, id);
    if (true) {
      GlobalData.showSnackBar(
          "Episode deleted successfully!", context, Colors.black);
      await EpisodeUtil.fetchAllEpisodeModel(context, widget.id);
    } else {
      GlobalData.showSnackBar(
          "Failed to delete episode!", context, Colors.red);
    }
  }
}
