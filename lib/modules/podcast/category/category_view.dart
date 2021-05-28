import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vocal/modules/podcast/category/util/category_util.dart';
import 'package:vocal/modules/podcast/category/widget/category_widget.dart';
import 'package:vocal/modules/podcast/model/category_model.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';

class CategoryView extends StatefulWidget {
  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  int itemCount = 9;
  Future<List<CategoryModel>> categoryFuture;

  @override
  void initState() {
    categoryFuture = CategoryUtil.fetchAllCategoriesModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var playlistState = Provider.of<PodCastState>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      initialData: playlistState.categoriesList,
      future: categoryFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("DSDSDSDSDSDSDSD");
          if (playlistState.categoriesList.length > 0) {
            return Container(
              height: 200,
              width: size.width,
              // color: colorScheme.primary,
              child: new ListView.builder(
                itemCount: playlistState.categoriesList.length.isOdd ? ((playlistState.categoriesList.length+1)~/2).toInt() : (playlistState.categoriesList.length~/2).toInt(),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                shrinkWrap: false,
                itemBuilder: (context, index) {
                  // return new CategoryWidget(playlistState.categoriesList[index*2]);
                  if(playlistState.categoriesList.length.isOdd && index*2+1 == playlistState.categoriesList.length){
                    return new Column(
                      children: [
                        new CategoryWidget(playlistState.categoriesList[index*2]),
                        new Container()
                      ],
                    );
                  }else{
                    return new Column(
                      children: [
                        new CategoryWidget(playlistState.categoriesList[index*2]),
                        new CategoryWidget(playlistState.categoriesList[index*2+1]),
                      ],
                    );
                  }
                },),
            );
          } else {
            return Container(
              height: 200,
              width: size.width,
              // color: colorScheme.primary,
              child: new ListView.builder(
                itemCount: 3,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: false,
                itemBuilder: (context, index) {
                  return new Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: colorScheme.onPrimary,
                        highlightColor: colorScheme.secondaryVariant.withOpacity(0.3),
                        enabled: false,
                        child: new Container(
                          width: size.width * 0.4,
                          height: 70,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: colorScheme.onPrimary,
                        highlightColor: colorScheme.secondaryVariant.withOpacity(0.3),
                        enabled: false,
                        child: new Container(
                          width: size.width * 0.4,
                          height: 70,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      )
                    ],
                  );
                },),
            );
          }
        } else {
          return new Container();
        }
      },
    );
  }
}
