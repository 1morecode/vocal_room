import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal/modules/podcast/category/view/category_page.dart';
import 'package:vocal/modules/podcast/model/category_model.dart';
import 'package:vocal/modules/podcast/state/pod_cast_state.dart';

class CategoryGridCard extends StatefulWidget {
  final CategoryModel categoryModel;

  CategoryGridCard(this.categoryModel);

  @override
  _CategoryGridCardState createState() => _CategoryGridCardState();
}

class _CategoryGridCardState extends State<CategoryGridCard> {
  @override
  Widget build(BuildContext context) {
    var playlistState = Provider.of<PodCastState>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return new CupertinoButton(
      child: Container(
        margin: EdgeInsets.all(10),
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorScheme.onPrimary,
          image: DecorationImage(
            image: NetworkImage("${widget.categoryModel.image}"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "${widget.categoryModel.title}",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 21),
            ),
          ),
        ),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryPage(widget.categoryModel)));
      },
      padding: EdgeInsets.all(0),
    );
  }
}
