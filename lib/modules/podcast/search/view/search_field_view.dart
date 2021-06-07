import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/modules/global/widget/category_playlist_card.dart';
import 'package:vocal/modules/podcast/search/util/playlist_search_util.dart';
import 'package:vocal/modules/podcast/search/widget/category_grid_card.dart';
import 'package:vocal/res/widgets/my_loader.dart';

class SearchFieldView extends StatefulWidget {
  const SearchFieldView({Key key}) : super(key: key);

  @override
  _SearchFieldViewState createState() => _SearchFieldViewState();
}

class _SearchFieldViewState extends State<SearchFieldView> {
  bool loading = false;

  @override
  void initState() {
    PlaylistSearchUtil.searchController.clear();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    FocusScope.of(context).requestFocus(PlaylistSearchUtil.focusNode);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new AppBar(
        title: new CupertinoButton(
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(),));
          },
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: new Container(
            height: 40,
            child: CupertinoSearchTextField(
              controller: PlaylistSearchUtil.searchController,
              focusNode: PlaylistSearchUtil.focusNode,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: colorScheme.onSurface),
              onSubmitted: (txt) async {
                setState(() {
                  loading = true;
                });
                await PlaylistSearchUtil.searchPlaylistModel(context);
                setState(() {
                  loading = false;
                });
              },
              placeholder: "Search here...",
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: loading
            ? MyLoader()
            : !loading && PlaylistSearchUtil.playlistModelList.length == 0 ? Center(
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
            )):new Container(
          child: new Column(
            children: [
              new Container(
                width: size.width,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: new Text(
                  "Search Result",
                  style: TextStyle(color: colorScheme.secondaryVariant, fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                padding: EdgeInsets.symmetric(horizontal: 5),
                children: List.generate(
                    PlaylistSearchUtil.playlistModelList.length, (index) {
                  return new CategoryPlaylistCard(
                      PlaylistSearchUtil.playlistModelList[index]);
                }),
              ),
            ],
          )
        )
      ),
    );
  }
}
