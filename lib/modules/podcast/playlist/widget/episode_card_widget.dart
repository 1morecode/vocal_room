import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/modules/podcast/model/episode_model.dart';
import 'package:vocal/res/widgets/custom_list_tile.dart';

class EpisodeCardWidget extends StatefulWidget {
  final EpisodeModel episodeModel;

  EpisodeCardWidget(this.episodeModel);

  @override
  _EpisodeCardWidgetState createState() => _EpisodeCardWidgetState();
}

class _EpisodeCardWidgetState extends State<EpisodeCardWidget> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        elevation: 1,
        shadowColor: colorScheme.secondaryVariant.withOpacity(0.5),
        color: colorScheme.onPrimary,
        child: new Row(
          children: [
            new Expanded(
                child: new CupertinoButton(
                  padding: EdgeInsets.all(0),
                    child: new Row(
                  children: [
                    new Container(
                      height: 60,
                      width: 60,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
                              fit: BoxFit.cover)),
                    ),
                    new SizedBox(width: 10,),
                    new Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text("${widget.episodeModel.title}", style: TextStyle(color: colorScheme.onSecondary, fontWeight: FontWeight.w600, fontSize: 18),),
                          new Text("${widget.episodeModel.description}", style: TextStyle(color: colorScheme.secondaryVariant, fontWeight: FontWeight.w400, fontSize: 14),),
                        ],
                      ),
                    )
                  ],
                ), onPressed: (){})),
            PopupMenuButton(
              color: colorScheme.onSurface,
              padding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              itemBuilder: (context) {
                return List.generate(5, (index) {
                  return PopupMenuItem(
                    value: index,
                    enabled: false,
                    child: CustomListTile(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      onPressed: () {},
                      title: "Title",
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
