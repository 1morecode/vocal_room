import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:vocal/modules/dashboard/playlist/model/playlist_model.dart';
import 'package:vocal/modules/dashboard/playlist/util/playlist_util.dart';
import 'package:vocal/modules/dashboard/playlist/util/update_paylist_util.dart';
import 'package:vocal/modules/dashboard/playlist/widget/update_select_image.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';
import 'package:vocal/res/api_data.dart';
import 'package:vocal/res/global_data.dart';

class PlaylistUpdatePage extends StatefulWidget {
  final PodCastPlaylistModel playlistModel;

  PlaylistUpdatePage(this.playlistModel);

  @override
  _PlaylistUpdatePageState createState() => _PlaylistUpdatePageState();
}

class _PlaylistUpdatePageState extends State<PlaylistUpdatePage> {
  final RoundedLoadingButtonController _btnController =
  new RoundedLoadingButtonController();

  @override
  void initState() {
    UpdatePlaylistUtil.playlistNameController.text = "${widget.playlistModel.title}";
    UpdatePlaylistUtil.playlistDescController.text = "${widget.playlistModel.desc}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final vendorState = Provider.of<VendorState>(context, listen: false);
    // print("VVV ${vendorState.vendorModel.vendorDataId}");
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text(
          "Update Playlist",
          style: TextStyle(color: colorScheme.primary),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                SizedBox(height: size.height * 0.02),
                Container(
                    alignment: Alignment.centerLeft,
                    padding:
                    EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                    child: Text(
                      "Update Playlist",
                      style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 42,
                          fontWeight: FontWeight.w800),
                      textAlign: TextAlign.start,
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                  child: Text(
                      "Edit and update playlist for your episodes series!",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: colorScheme.secondaryVariant,
                          fontSize: 18,
                          fontWeight: FontWeight.w400)),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: UpdateSelectPlaylistImage("${APIData.imageBaseUrl}${widget.playlistModel.image}"),
                ),
                new SizedBox(
                  height: 25,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                  child: SizedBox(
                    height: 55,
                    child: CupertinoTextField(
                      controller: UpdatePlaylistUtil.playlistNameController,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      placeholder: "Playlist Name",
                    ),
                  ),
                ),
                new SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                  child: CupertinoTextField(
                    minLines: 3,
                    maxLines: 5,
                    controller: UpdatePlaylistUtil.playlistDescController,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    placeholder: "About Playlist...",
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(25.0),
                    width: size.width,
                    child: Builder(
                      builder: (_context) => RoundedLoadingButton(
                          controller: _btnController,
                          color: colorScheme.primary,
                          height: 45,
                          child: new Text(
                            "Update",
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                          onPressed: () {
                            onPlaylistUpdate(_context, context);
                            // _onSendOtpPressed(_context);
                          }),
                    )),
                new SizedBox(
                  height: 10,
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onPlaylistUpdate(_context, context) async {
    if (UpdatePlaylistUtil.playlistNameController.text.isNotEmpty && UpdatePlaylistUtil.playlistDescController.text.isNotEmpty) {
      bool status = await UpdatePlaylistUtil.updatePlaylist(context, widget.playlistModel.id);
      if (status) {
        _btnController.success();
        GlobalData.showSnackBar(
            "Playlist updated successfully!", _context, Colors.black);
        await PlaylistUtil.fetchAllPlaylistModel(context);
        Navigator.of(context).pop();
        _btnController.reset();
      } else {
        _btnController.error();
        GlobalData.showSnackBar(
            "Failed to update playlist!", _context, Colors.red);
        Timer(Duration(seconds: 2), () {
          _btnController.reset();
        });
      }
    }else{
      _btnController.error();
      GlobalData.showSnackBar(
          "All fields are mandatory!", _context, Colors.red);
      Timer(Duration(seconds: 2), () {
        _btnController.reset();
      });
    }
  }
}
