import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/modules/podcast/model/category_model.dart';

class CategoryWidget extends StatefulWidget {
  final CategoryModel categoryModel;

  CategoryWidget(this.categoryModel);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return new CupertinoButton(child: Container(
      height: 70,
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.all(10),
      width: size.width * 0.4,
      child: new Stack(
        alignment: Alignment.centerRight,
        children: [
          new Row(
            children: [
              new Expanded(
                child: new Container(),
                flex: 1,
              ),
              new Expanded(
                child: new ClipRRect(
                  child: Image.network(
                    "${widget.categoryModel.image}",
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                flex: 1,
              ),
            ],
          ),
          new Container(
            width: size.width * 0.4,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: new LinearGradient(
                  colors: [colorScheme.onPrimary, colorScheme.primary.withOpacity(0.2)],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.6, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: new Row(
              children: [
                new Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: new Text(
                      "${widget.categoryModel.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: colorScheme.onSecondary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  flex: 2,
                ),
                new Expanded(
                  child: new Container(),
                  flex: 1,
                ),
              ],
            ),
          )
        ],
      ),
    ), onPressed: (){}, padding: EdgeInsets.all(0),);
  }
}
