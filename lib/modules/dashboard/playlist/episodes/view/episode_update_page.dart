import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/util/episode_util.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/util/update_episode_util.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/widget/select_update_episode_image.dart';
import 'package:vocal/modules/dashboard/playlist/model/episode_model.dart';
import 'package:vocal/res/global_data.dart';

class UpdateEpisodePage extends StatefulWidget {
  final EpisodeModel episodeModel;

  UpdateEpisodePage(this.episodeModel);
  @override
  _UpdateEpisodePageState createState() => _UpdateEpisodePageState();
}

class _UpdateEpisodePageState extends State<UpdateEpisodePage> {
  final RoundedLoadingButtonController _btnController =
  new RoundedLoadingButtonController();

  @override
  void initState() {
    UpdateEpisodeUtil.episodeNameController.text = "${widget.episodeModel.title}";
    UpdateEpisodeUtil.episodeDescController.text = "${widget.episodeModel.desc}";
    UpdateEpisodeUtil.episodeFile.text = "${widget.episodeModel.audio[0]['path']}";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text(
          "Update Episode",
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
                  child: SelectUpdateEpisodeImage("${widget.episodeModel.graphic[0]['path']}"),
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
                      controller: UpdateEpisodeUtil.episodeNameController,
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
                    controller: UpdateEpisodeUtil.episodeDescController,
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
                            controller: UpdateEpisodeUtil.tagController,
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
                            onPressed: UpdateEpisodeUtil
                                .tagController.text.isNotEmpty
                                ? () {
                              setState(() {
                                UpdateEpisodeUtil.tags.add(
                                    UpdateEpisodeUtil.tagController.text);
                              });
                              UpdateEpisodeUtil.tagController.clear();
                            }
                                : null,
                            child: Icon(
                              Icons.add_circle_outline,
                              color:
                              UpdateEpisodeUtil.tagController.text.isNotEmpty
                                  ? colorScheme.onPrimary
                                  : colorScheme.secondaryVariant,
                            )),
                      ),
                    ],
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: UpdateEpisodeUtil.tags.length > 0
                      ? new Wrap(
                    alignment: WrapAlignment.start,
                    children: List.generate(
                        UpdateEpisodeUtil.tags.length,
                            (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          child: new Chip(
                            label: new Text(
                                "${UpdateEpisodeUtil.tags[index]}"),
                            backgroundColor: colorScheme.onPrimary,
                            labelStyle: TextStyle(color: colorScheme.primary),
                            deleteIcon: Icon(Icons.cancel_outlined, color: colorScheme.primary,),
                            onDeleted: (){
                              setState(() {
                                UpdateEpisodeUtil.tags.removeAt(index);
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
                      controller: UpdateEpisodeUtil.episodeFile,
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
                            "Update",
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                          onPressed: () {
                            onEpisodeUpdate(_context, context);
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
      UpdateEpisodeUtil.episodeFile.text = file.path;
      setState(() {
        UpdateEpisodeUtil.media = file;
      });
    } else {
      print('No image selected.');
    }
  }

  onEpisodeUpdate(_context, context) async {
    if (UpdateEpisodeUtil.episodeNameController.text.isNotEmpty &&
        UpdateEpisodeUtil.episodeDescController.text.isNotEmpty) {
      bool status = await UpdateEpisodeUtil.updateEpisode(context, widget.episodeModel.id);
      if (status) {
        _btnController.success();
        GlobalData.showSnackBar(
            "Episode updated successfully!", _context, Colors.black);
        await EpisodeUtil.fetchAllEpisodeModel(context);
        Navigator.of(context).pop();
        _btnController.reset();
      } else {
        _btnController.error();
        GlobalData.showSnackBar(
            "Failed to update episode!", _context, Colors.red);
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
  }
}
