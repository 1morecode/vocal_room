import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vocal/modules/podcast/category/util/category_util.dart';
import 'package:vocal/modules/podcast/model/category_model.dart';
import 'package:vocal/modules/podcast/search/widget/category_grid_card.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';
import 'package:vocal/modules/podcast/widgets/playlist_card_widget.dart';

class CategoryGridView extends StatefulWidget {
  const CategoryGridView({Key key}) : super(key: key);

  @override
  _CategoryGridViewState createState() => _CategoryGridViewState();
}

class _CategoryGridViewState extends State<CategoryGridView> {
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
            return GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              padding: EdgeInsets.symmetric(horizontal: 5),
              children: List.generate(playlistState.categoriesList.length,
                      (index) {
                    return new CategoryGridCard(playlistState.categoriesList[index]);
                  }),
            );
          } else {
            return new Container();
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
                highlightColor: colorScheme.secondaryVariant.withOpacity(0.3),
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
    );
  }
}
