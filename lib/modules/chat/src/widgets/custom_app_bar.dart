import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final List<Widget> actions;
  final Widget title;

  CustomAppBar({
    @required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: colorScheme.onPrimary,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          color: colorScheme.onSurface,
          height: 1,
        ),
      ),
      elevation: 0,
      title: title,
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56);
}
