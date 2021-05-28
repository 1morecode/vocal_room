import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/modules/podcast/search/view/category_grid_view.dart';
import 'package:vocal/modules/podcast/search/view/search_field_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new AppBar(
        title: new CupertinoButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchFieldView(),));
          },
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Container(
            child: CupertinoTextField(
              enabled: false,
              placeholder: "Search here...",
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                borderRadius: BorderRadius.circular(5)
              ),
            ),
            height: 40,
          )
        ),
      ),
      body: SafeArea(
        child: new ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: false,
          padding: EdgeInsets.symmetric(vertical: 10),
          children: [
            CategoryGridView()
          ],
        ),
      ),
    );
  }
}
