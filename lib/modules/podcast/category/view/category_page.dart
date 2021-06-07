import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vocal/modules/global/widget/category_playlist_card.dart';
import 'package:vocal/modules/podcast/category/util/category_util.dart';
import 'package:vocal/modules/podcast/model/category_model.dart';
import 'package:vocal/modules/podcast/model/podcast_playlist_model.dart';
import 'package:vocal/modules/podcast/playlist/util/pod_cast_playlist_util.dart';

class CategoryPage extends StatefulWidget {
  final CategoryModel categoryModel;

  CategoryPage(this.categoryModel);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Future<List<PodCastPlaylistModel>> playlistFuture;

  @override
  void initState() {
    playlistFuture = CategoryUtil.fetchAllPlaylistModelByCategory(
        context, widget.categoryModel.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CupertinoNavigationBar(),
      body: new Column(
        children: [
          new Container(
            width: size.width,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: new Text(
              "${widget.categoryModel.title}",
              style: TextStyle(color: colorScheme.secondaryVariant, fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          FutureBuilder(
            future: playlistFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("DSDSDSDSDSDSDSD");
                if (snapshot.data.length > 0) {
                  return GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    children: List.generate(snapshot.data.length, (index) {
                      return new CategoryPlaylistCard(snapshot.data[index]);
                    }),
                  );
                } else {
                  return new Container(
                      padding: EdgeInsets.all(15),
                      child: Center(
                          child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new SizedBox(height: 50,),
                          Image.asset(
                            "assets/no_record_found.png",
                            height: 70,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      )));
                }
              } else {
                return GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  children: List.generate(4, (index) {
                    return Shimmer.fromColors(
                      baseColor: colorScheme.onPrimary,
                      highlightColor:
                          colorScheme.secondaryVariant.withOpacity(0.3),
                      enabled: false,
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    );
                  }),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
