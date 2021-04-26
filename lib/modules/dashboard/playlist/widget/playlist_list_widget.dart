import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/view/episodes_page.dart';
import 'package:vocal/modules/dashboard/playlist/model/playlist_model.dart';
import 'package:vocal/modules/dashboard/playlist/util/playlist_state.dart';

class PlaylistWidget extends StatefulWidget {
  final String id;

  PlaylistWidget(this.id);
  @override
  _PlaylistWidgetState createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  List<String> ll = ["Delete", "Share"];

  @override
  Widget build(BuildContext context) {
    final playlistState =
        Provider.of<PlaylistState>(context, listen: true);
    Iterable<PlaylistModel> playlistModel = playlistState.playlistModelList
        .where((element) => element.id == widget.id);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return CupertinoButton(child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.network(
                    '${playlistModel.first.image}',
                    fit: BoxFit.contain,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${playlistModel.first.title}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '2 Episodes listed',
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
                new Icon(Icons.chevron_right)
                // Builder(
                //   builder: (_context) => PopupMenuButton(
                //     onSelected: (value) {
                //       print(value);
                //       if (value == "Delete") {
                //         playlistState.removePlaylistModal(
                //             widget.playlistModel);
                //         showDeleteSnackBar(
                //             _context, widget.playlistModel);
                //       }
                //     },
                //     padding: EdgeInsets.all(10),
                //     color: colorScheme.onPrimary,
                //     itemBuilder: (BuildContext context) {
                //       return ll.map((link) {
                //         return PopupMenuItem(
                //           textStyle: TextStyle(color: colorScheme.primary),
                //           height: 35,
                //           value: link,
                //           child: Text(link),
                //         );
                //       }).toList();
                //     },
                //   ),
                // )
              ],
            ),
          ],
        ),
      ),
    ), onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => EpisodesPage(widget.id),));
    }, padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),);
  }

  static void showDeleteSnackBar(
      BuildContext context, PlaylistModel playlistModel) {
    final playlistState =
        Provider.of<PlaylistState>(context, listen: true);
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text(
        'Item Deleted Successfully!',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      action: SnackBarAction(
        onPressed: () {
          playlistState.addPlaylistModal(playlistModel);
        },
        label: "Undo",
        textColor: Theme.of(context).colorScheme.primary,
      ),
    );
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
