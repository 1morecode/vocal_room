import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/util/new_episode_util.dart';
import 'package:vocal/modules/dashboard/playlist/episodes/util/update_episode_util.dart';

class SelectUpdateEpisodeImage extends StatefulWidget {
  final String url;

  SelectUpdateEpisodeImage(this.url);
  @override
  _SelectUpdateEpisodeImageState createState() => _SelectUpdateEpisodeImageState();
}

class _SelectUpdateEpisodeImageState extends State<SelectUpdateEpisodeImage> {

  @override
  void initState() {
    UpdateEpisodeUtil.file = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return new Container(
      height: size.width * 0.3,
      width: size.width * 0.3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorScheme.onPrimary, width: 5),
          color: colorScheme.onSurface),
      child: new Stack(
        children: [
          new ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: UpdateEpisodeUtil.file == null && widget.url.isNotEmpty ? Image.network(
              "${widget.url}",
              height: size.width * 0.45,
              width: size.width,
              fit: BoxFit.cover,
            ) : UpdateEpisodeUtil.file != null ? Image.file(
              UpdateEpisodeUtil.file,
              height: size.width * 0.45,
              width: size.width,
              fit: BoxFit.cover,
            ) : Image.network(
              "https://lirp.cdn-website.com/343f0986cb9d4bc5bc00d8a4a79b4156/dms3rep/multi/opt/1274512-placeholder-640w.png",
              height: size.width * 0.45,
              width: size.width,
              fit: BoxFit.cover,
            ),
          ),
          new Container(
            height: size.width * 0.45,
            width: size.width,
            color: Colors.transparent,
            alignment: Alignment.bottomRight,
            child: getImagePickerButton(context),
          )
        ],
      ),
    );
  }

  Future getImage() async {
    final pickedFile =
    await UpdateEpisodeUtil.updateEpisodeBannerPicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      setState(() {
        UpdateEpisodeUtil.file = file;
      });
    } else {
      print('No image selected.');
    }
  }

  Widget getImagePickerButton(context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return new CupertinoButton(
      minSize: 30,
      child: new Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: colorScheme.onSurface,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
            border: Border.all(color: colorScheme.onPrimary, width: 2)),
        child: new Icon(
          Icons.cloud_upload_outlined,
          size: 28,
        ),
      ),
      onPressed: () {
        getImage();
      },
      padding: EdgeInsets.all(0),
    );
  }
}
