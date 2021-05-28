import 'package:flutter/material.dart';
import 'package:vocal/modules/chat/src/widgets/settings_item.dart';

class SettingsContainer extends StatelessWidget {

  final List<SettingsItem> children;

  SettingsContainer({
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: colorScheme.secondaryVariant,
          ),
          top: BorderSide(
            width: 1,
            color: colorScheme.secondaryVariant,
          ),
        ),
      ),
      child: Column(
        children: children.asMap().map((int index, SettingsItem settingsItem) {
          var newSettingsItem = settingsItem;
          if (index == children.length - 1) {
            newSettingsItem = newSettingsItem.copyWith(border: false);
          }
          return MapEntry(index, newSettingsItem);
        }).values.toList(),
      ),
    );
  }
}