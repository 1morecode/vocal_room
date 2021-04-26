import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vocal/modules/dashboard/playlist/view/playlist_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: colorScheme.onPrimary,
                  border: BorderDirectional(
                      bottom: BorderSide(
                          color: colorScheme.secondaryVariant.withOpacity(0.5),
                          width: 1))),
              child: TabBar(
                indicatorWeight: 2,
                physics: BouncingScrollPhysics(),
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: colorScheme.secondaryVariant,
                labelPadding: EdgeInsets.symmetric(horizontal: 25),
                tabs: [
                  Tab(
                    child: Text('Playlists'),
                  ),
                  Tab(
                    child: Text('New Episode'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                dragStartBehavior: DragStartBehavior.start,
                children: [
                  PlaylistPage(),
                  new Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
