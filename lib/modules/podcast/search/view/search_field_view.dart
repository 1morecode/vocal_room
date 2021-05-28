import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/modules/podcast/search/view/category_grid_view.dart';
import 'package:vocal/res/always_focus_node.dart';

class SearchFieldView extends StatefulWidget {
  const SearchFieldView({Key key}) : super(key: key);

  @override
  _SearchFieldViewState createState() => _SearchFieldViewState();
}

class _SearchFieldViewState extends State<SearchFieldView> {
  TextEditingController searchTextController = new TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // searchTextController.
    super.initState();
  }

  @override
  void didChangeDependencies() {
    FocusScope.of(context).requestFocus(focusNode);
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new AppBar(
        title: new CupertinoButton(
          onPressed: (){
            // Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(),));
          },
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: new Container(
            height: 40,
            child: CupertinoSearchTextField(
              controller: searchTextController,
                focusNode: focusNode,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: colorScheme.onSurface
              ),
              placeholder: "Search here...",
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: new Container(),
      ),
    );
  }
}
