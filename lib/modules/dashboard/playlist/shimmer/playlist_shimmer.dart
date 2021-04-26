import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlayListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Column(
          children: [
            Row(
              children: [
                Shimmer.fromColors(
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  baseColor: colorScheme.onSurface,
                  highlightColor: colorScheme.secondaryVariant.withOpacity(0.5),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        child: Container(
                          height: 18,
                          margin: EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width*0.4,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        baseColor: colorScheme.onSurface,
                        highlightColor:
                            colorScheme.secondaryVariant.withOpacity(0.5),
                      ),
                      Shimmer.fromColors(
                        child: Container(
                          height: 16,
                          margin: EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width*0.6,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        baseColor: colorScheme.onSurface,
                        highlightColor:
                            colorScheme.secondaryVariant.withOpacity(0.5),
                      ),
                      Shimmer.fromColors(
                        child: Container(
                          height: 22,
                          width: 100,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        baseColor: colorScheme.onSurface,
                        highlightColor:
                            colorScheme.secondaryVariant.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
