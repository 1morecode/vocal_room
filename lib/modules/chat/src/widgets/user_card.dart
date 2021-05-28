import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/modules/chat/src/data/models/user.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final Function onTap;

  UserCard({
    @required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      child: CupertinoButton(
        borderRadius: BorderRadius.circular(0),
        padding: EdgeInsets.all(0),
        color: colorScheme.onPrimary,
        onPressed: () {
          if (this.onTap != null) {
            this.onTap(user);
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            top: 10,
            bottom: 0,
          ),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      "${user.picture}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  radius: 20,
                  backgroundColor: colorScheme.primary,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 5,
                    ),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            this.user.name,
                            style: TextStyle(
                              color: colorScheme.onSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${this.user.username}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.secondaryVariant
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: colorScheme.secondaryVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
