import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:vocal/modules/dashboard/playlist/util/new_playlist_util.dart';
import 'package:vocal/modules/dashboard/playlist/util/playlist_util.dart';
import 'package:vocal/modules/dashboard/playlist/widget/select_playlist_image.dart';
import 'package:vocal/res/global_data.dart';

class NewPlaylistPage extends StatefulWidget {
  @override
  _NewPlaylistPageState createState() => _NewPlaylistPageState();
}

class _NewPlaylistPageState extends State<NewPlaylistPage> {
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    NewPlaylistUtil.playlistNameController.clear();
    NewPlaylistUtil.playlistDescController.clear();
    NewPlaylistUtil.file = null;
    super.dispose();
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
          "New Playlist",
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
                      "New Playlist",
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
                      "Create your new playlist for your episodes series!",
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
                  child: SelectPlaylistImage(),
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
                      controller: NewPlaylistUtil.playlistNameController,
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
                    controller: NewPlaylistUtil.playlistDescController,
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
                            "Create",
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                          onPressed: () {
                            onPlaylistCreate(_context, context);
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

  onPlaylistCreate(_context, context) async {
    if(NewPlaylistUtil.file != null){
      if (NewPlaylistUtil.playlistNameController.text.isNotEmpty && NewPlaylistUtil.playlistDescController.text.isNotEmpty) {
        bool status = await NewPlaylistUtil.createNewPlaylist(context, NewPlaylistUtil.playlistNameController.text, NewPlaylistUtil.playlistDescController.text, );
        if (status) {
          _btnController.success();
          GlobalData.showSnackBar(
              "Category created successfully!", _context, Colors.black);
          await PlaylistUtil.fetchAllPlaylistModel(context);
          Navigator.of(context).pop();
          _btnController.reset();
        } else {
          _btnController.error();
          GlobalData.showSnackBar(
              "Failed to created category!", _context, Colors.red);
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
    } else {
      _btnController.error();
      GlobalData.showSnackBar(
          "Please select playlist banner!", _context, Colors.red);
      Timer(Duration(seconds: 2), () {
        _btnController.reset();
      });
    }
  }
}
