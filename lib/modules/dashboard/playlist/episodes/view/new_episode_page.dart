import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/util/episode_util.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/util/new_episode_util.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/widget/select_new_episode_image.dart';
import 'package:vocal/modules/dashboard/playlist/model/playlist_model.dart';
import 'package:vocal/res/global_data.dart';

class NewEpisodePage extends StatefulWidget {
  final PlaylistModel playlistModel;

  NewEpisodePage(this.playlistModel);

  @override
  _NewEpisodePageState createState() => _NewEpisodePageState();
}

class _NewEpisodePageState extends State<NewEpisodePage> {
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  void dispose() {
    NewEpisodeUtil.episodeNameController.clear();
    NewEpisodeUtil.episodeDescController.clear();
    NewEpisodeUtil.tagController.clear();
    NewEpisodeUtil.episodeFile.clear();
    NewEpisodeUtil.file = null;
    NewEpisodeUtil.media = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text(
          "New Episode",
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
                SizedBox(height: size.height * 0.05),
                Center(
                  child: SelectNewEpisodeImage(),
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
                      controller: NewEpisodeUtil.episodeNameController,
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
                    minLines: 1,
                    maxLines: 2,
                    controller: NewEpisodeUtil.episodeDescController,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    placeholder: "Sort Description",
                  ),
                ),
                new SizedBox(
                  height: 10,
                ),
                new Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                  child: new Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 55,
                          child: CupertinoTextField(
                            placeholder: "Enter New Tag",
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            controller: NewEpisodeUtil.tagController,
                            onChanged: (text) {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      new SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 55,
                        width: 55,
                        child: new CupertinoButton(
                            color: colorScheme.primary,
                            padding: EdgeInsets.all(0),
                            onPressed: NewEpisodeUtil
                                    .tagController.text.isNotEmpty
                                ? () {
                                    setState(() {
                                      NewEpisodeUtil.tags.add(
                                          NewEpisodeUtil.tagController.text);
                                    });
                                    NewEpisodeUtil.tagController.clear();
                                  }
                                : null,
                            child: Icon(
                              Icons.add_circle_outline,
                              color:
                                  NewEpisodeUtil.tagController.text.isNotEmpty
                                      ? colorScheme.onPrimary
                                      : colorScheme.secondaryVariant,
                            )),
                      ),
                    ],
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: NewEpisodeUtil.tags.length > 0
                      ? new Wrap(
                          alignment: WrapAlignment.start,
                          children: List.generate(
                              NewEpisodeUtil.tags.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 0),
                                    child: new Chip(
                                      label: new Text(
                                          "${NewEpisodeUtil.tags[index]}"),
                                      backgroundColor: colorScheme.onPrimary,
                                      labelStyle: TextStyle(color: colorScheme.primary),
                                      deleteIcon: Icon(Icons.cancel_outlined, color: colorScheme.primary,),
                                      onDeleted: (){
                                        setState(() {
                                          NewEpisodeUtil.tags.removeAt(index);
                                        });
                                      },
                                    ),
                                  )),
                        )
                      : new Center(
                          child: new Text(
                            "No Tag Added",
                            style: TextStyle(
                                color: colorScheme.secondaryVariant,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                  child: SizedBox(
                    height: 55,
                    child: CupertinoTextField(
                      controller: NewEpisodeUtil.episodeFile,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      placeholder: "Select episode file",
                      readOnly: true,
                      suffix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.attach_file),
                      ),
                      onTap: (){
                        getMedia();
                      },
                    ),
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
                            onEpisodeCreate(_context, context);
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

  Future getMedia() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file =  File(result.files.single.path);
      NewEpisodeUtil.episodeFile.text = file.path;
      setState(() {
        NewEpisodeUtil.media = file;
      });
    } else {
      print('No image selected.');
    }
  }

  onEpisodeCreate(_context, context) async {
    if (NewEpisodeUtil.file != null) {
      if (NewEpisodeUtil.episodeNameController.text.isNotEmpty &&
          NewEpisodeUtil.episodeDescController.text.isNotEmpty) {
        bool status = await NewEpisodeUtil.addNewEpisode(context, widget.playlistModel.id);
        if (status) {
          _btnController.success();
          GlobalData.showSnackBar(
              "Episode created successfully!", _context, Colors.black);
          await EpisodeUtil.fetchAllEpisodeModel(context);
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
      } else {
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