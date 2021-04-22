import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vocal/libraries/stories/Stories_for_Flutter.dart';

class StoriesView extends StatefulWidget {
  @override
  _StoriesViewState createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  var firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Stories(
      circlePadding: 2,
      paddingColor: colorScheme.primary,
      highLightColor: colorScheme.primary,
      fullpageVisitedColor: colorScheme.primary,
      fullpageUnisitedColor: colorScheme.onSecondary,
      storyItemList: [
        StoryItem(
          name: "Your Story",
          thumbnail: NetworkImage(
            firebaseAuth.currentUser != null
                ? "${firebaseAuth.currentUser.photoURL}"
                : "https://www.w3schools.com/howto/img_avatar.png",
          ),
          stories: [
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://wallpaperaccess.com/full/16568.png",
                    ),
                  ),
                ),
              ),
            ),
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://i.pinimg.com/originals/2e/c6/b5/2ec6b5e14fe0cba0cb0aa5d2caeeccc6.jpg",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        StoryItem(
            name: "First Story",
            thumbnail: NetworkImage(
              "https://linustechtips.com/uploads/monthly_2018_10/imported-photo-301761.thumb.jpeg.5eac908d4228fb45bbaf2069d697f52d.jpeg",
            ),
            stories: [
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "https://wallpaperaccess.com/full/16568.png",
                      ),
                    ),
                  ),
                ),
              ),
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "https://i.pinimg.com/originals/2e/c6/b5/2ec6b5e14fe0cba0cb0aa5d2caeeccc6.jpg",
                      ),
                    ),
                  ),
                ),
              ),
            ]),
        StoryItem(
          name: "Second Story",
          thumbnail: NetworkImage(
            "https://rockstart.imgix.net/wp-content/uploads/2014/09/owlin_bas.jpg?auto=compress%2Cformat?auto=compress%2Cformat&h=300&ixlib=php-1.1.0&w=300",
          ),
          stories: [
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://wallpaperaccess.com/full/16568.png",
                    ),
                  ),
                ),
              ),
            ),
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://i.pinimg.com/originals/2e/c6/b5/2ec6b5e14fe0cba0cb0aa5d2caeeccc6.jpg",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        StoryItem(
            name: "First Story",
            thumbnail: NetworkImage(
              "https://linustechtips.com/uploads/monthly_2018_10/imported-photo-301761.thumb.jpeg.5eac908d4228fb45bbaf2069d697f52d.jpeg",
            ),
            stories: [
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "https://wallpaperaccess.com/full/16568.png",
                      ),
                    ),
                  ),
                ),
              ),
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "https://i.pinimg.com/originals/2e/c6/b5/2ec6b5e14fe0cba0cb0aa5d2caeeccc6.jpg",
                      ),
                    ),
                  ),
                ),
              ),
            ]),
        StoryItem(
          name: "Second Story",
          thumbnail: NetworkImage(
            "https://rockstart.imgix.net/wp-content/uploads/2014/09/owlin_bas.jpg?auto=compress%2Cformat?auto=compress%2Cformat&h=300&ixlib=php-1.1.0&w=300",
          ),
          stories: [
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://wallpaperaccess.com/full/16568.png",
                    ),
                  ),
                ),
              ),
            ),
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://i.pinimg.com/originals/2e/c6/b5/2ec6b5e14fe0cba0cb0aa5d2caeeccc6.jpg",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        StoryItem(
            name: "First Story",
            thumbnail: NetworkImage(
              "https://linustechtips.com/uploads/monthly_2018_10/imported-photo-301761.thumb.jpeg.5eac908d4228fb45bbaf2069d697f52d.jpeg",
            ),
            stories: [
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "https://wallpaperaccess.com/full/16568.png",
                      ),
                    ),
                  ),
                ),
              ),
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "https://i.pinimg.com/originals/2e/c6/b5/2ec6b5e14fe0cba0cb0aa5d2caeeccc6.jpg",
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ],
    );
  }
}
