import 'package:flutter/material.dart';

class UserInfoItem extends StatelessWidget {
  final String name;
  final String subtitle;

  UserInfoItem({
    @required this.name,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        border: Border(
          top: BorderSide(
            width: 1,
            color: colorScheme.secondaryVariant,
          ),
          bottom: BorderSide(
            width: 1,
            color: colorScheme.secondaryVariant,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: colorScheme.primary,
            radius: 25,
            child: Text(
              name[0],
              style: TextStyle(color: colorScheme.onPrimary, fontSize: 18),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colorScheme.secondaryVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
