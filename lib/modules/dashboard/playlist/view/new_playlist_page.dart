import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:vocal/modules/dashboard/playlist/util/new_playlist_util.dart';
import 'package:vocal/modules/dashboard/playlist/util/playlist_util.dart';
import 'package:vocal/modules/dashboard/playlist/widget/select_playlist_image.dart';
import 'package:vocal/modules/podcast/category/util/category_util.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';
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
    CategoryUtil.fetchAllCategoriesModel(context);
    NewPlaylistUtil.categoryController.clear();
    NewPlaylistUtil.selectedCategory = null;
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
    final vendorState = Provider.of<PodCastState>(context, listen: false);
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
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
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
              child: CupertinoTextField(
                readOnly: true,
                controller: NewPlaylistUtil.categoryController,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                placeholder: "Select Category",
                onTap: (){
                  if(vendorState.categoriesList.length != 0){
                    _showPicker(context);
                  }else{
                    CategoryUtil.fetchAllCategoriesModel(context);
                  }
                },
              ),
            ),
            new SizedBox(
              height: 10,
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
            new Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: NewPlaylistUtil.tags.length > 0
                  ? new Wrap(
                alignment: WrapAlignment.start,
                children: List.generate(
                    NewPlaylistUtil.tags.length,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      child: new Chip(
                        label: new Text(
                            "${NewPlaylistUtil.tags[index]}"),
                        backgroundColor: colorScheme.onPrimary,
                        labelStyle: TextStyle(color: colorScheme.primary),
                        deleteIcon: Icon(Icons.cancel_outlined, color: colorScheme.primary,),
                        onDeleted: (){
                          setState(() {
                            NewPlaylistUtil.tags.removeAt(index);
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
                        controller: NewPlaylistUtil.tagController,
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
                        onPressed: NewPlaylistUtil
                            .tagController.text.isNotEmpty
                            ? () {
                          setState(() {
                            NewPlaylistUtil.tags.add(
                                NewPlaylistUtil.tagController.text);
                          });
                          NewPlaylistUtil.tagController.clear();
                        }
                            : null,
                        child: Icon(
                          Icons.add_circle_outline,
                          color:
                          NewPlaylistUtil.tagController.text.isNotEmpty
                              ? colorScheme.onPrimary
                              : colorScheme.secondaryVariant,
                        )),
                  ),
                ],
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
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext ctx) async{
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final vendorState = Provider.of<PodCastState>(context, listen: false);
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
          height: MediaQuery.of(context).size.width*0.7,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.onSurface,
            borderRadius: BorderRadius.circular(10)
          ),
          padding: EdgeInsets.all(10),
          child: CupertinoPicker(
            backgroundColor: colorScheme.onSurface,
            itemExtent: 30,
            scrollController: FixedExtentScrollController(initialItem: 0),
            children: List.generate(vendorState.categoriesList.length, (index) => new Text("${vendorState.categoriesList[index].title}")),
            onSelectedItemChanged: (value) {
              setState(() {
                NewPlaylistUtil.selectedCategory = vendorState.categoriesList[value];
                NewPlaylistUtil.categoryController.text = vendorState.categoriesList[value].title;
              });
            },
          ),
        ));
  }

  onPlaylistCreate(_context, context) async {
    if(NewPlaylistUtil.file != null){
      if (NewPlaylistUtil.playlistNameController.text.isNotEmpty && NewPlaylistUtil.playlistDescController.text.isNotEmpty && NewPlaylistUtil.categoryController.text.isNotEmpty) {
        bool status = await NewPlaylistUtil.createNewPlaylist(context, NewPlaylistUtil.playlistNameController.text, NewPlaylistUtil.playlistDescController.text, );
        if (status) {
          _btnController.success();
          GlobalData.showSnackBar(
              "Playlist created successfully!", _context, Colors.black);
          await PlaylistUtil.fetchAllPlaylistModel(context);
          Navigator.of(context).pop();
          _btnController.reset();
        } else {
          _btnController.error();
          GlobalData.showSnackBar(
              "Failed to created playlist!", _context, Colors.red);
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
