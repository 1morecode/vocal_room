import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/modules/podcast/playlist/playlist_page.dart';

class PlayListCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return new CupertinoButton(child: Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorScheme.onPrimary,
        image: DecorationImage(
          image: NetworkImage(
              "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/172107537/original/3ac68a0d8c213e56d4a27db3fe0b1b5fd6a4eb6c/make-a-playlist-banner-or-artwork.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: new Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: new LinearGradient(
              colors: [
                colorScheme.primary.withOpacity(0.2),
                colorScheme.onPrimary
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.5, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: new Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                "This is a playlists, title and description goes here",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    color: colorScheme.onSecondary.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            )
          ],
        ),
      ),
    ), onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => PlayListPage(),));
    }, padding: EdgeInsets.all(0),);
  }
}
