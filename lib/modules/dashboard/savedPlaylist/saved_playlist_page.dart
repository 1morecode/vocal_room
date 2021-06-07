import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/dashboard/savedPlaylist/util/playlist_pref.dart';
import 'package:vocal/modules/dashboard/savedPlaylist/widget/saved_playlist_widget.dart';
import 'package:vocal/res/global_data.dart';

class SavedPlaylistPage extends StatefulWidget {
  @override
  _SavedPlaylistPageState createState() => _SavedPlaylistPageState();
}

class _SavedPlaylistPageState extends State<SavedPlaylistPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    final savedPlaylistState =
        Provider.of<SavedPlaylistState>(context, listen: true);
    return Scaffold(
      body: SafeArea(
        child: savedPlaylistState.playlists.length != 0
            ? ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: savedPlaylistState.playlists.length,
                padding: EdgeInsets.only(top: 5, bottom: 65),
                itemBuilder: (context, index) {
                  return Dismissible(// Each Dismissible must contain a Key. Keys allow Flutter to
                    // uniquely identify widgets.
                      key: Key(savedPlaylistState.playlists[index].id),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      onDismissed: (direction) {
                        // Remove the item from the data source.
                        savedPlaylistState.playlists.remove(savedPlaylistState.playlists[index]);
                        savedPlaylistState.removePlaylist();

                        GlobalData.showSnackBar("Playlist removed!", context, colorScheme.onPrimary);
                      }, child: new SavedPlaylistWidget(index));
                },
              )
            : Center(
                child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_collection_outlined,
                    size: 100,
                    color: colorScheme.secondaryVariant,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Playlist Not Saved",
                    style: TextStyle(
                        color: colorScheme.secondaryVariant,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              )),
      ),
    );
  }
}
