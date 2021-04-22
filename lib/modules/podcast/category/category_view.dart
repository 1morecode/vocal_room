import 'package:flutter/material.dart';
import 'package:vocal/modules/podcast/category/widget/category_widget.dart';

class CategoryView extends StatefulWidget {
  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  int itemCount = 9;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 200,
      width: size.width,
      // color: colorScheme.primary,
      child: new ListView.builder(
        itemCount: itemCount.isOdd ? ((itemCount+1)~/2).toInt() : itemCount/2,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        shrinkWrap: false,
        itemBuilder: (context, index) {
          if(itemCount.isOdd && index*2+1 == itemCount){
            return new Column(
              children: [
                new CategoryWidget(),
                new Container()
              ],
            );
          }else{
            return new Column(
              children: [
                new CategoryWidget(),
                new CategoryWidget(),
              ],
            );
          }
      },),
    );
  }
}
