import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AnimationUtil {
  static buildCardShimmerEffect(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 8, right: 8, top: 8),
            child: buildRectangleShimmerFull(context, height: 25),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //ilustração do cheque
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: buildRectangleShimmerEffect(
                  width: 120.0,
                  height: 70.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildRectangleShimmerEffect(
                      width: 200.0,
                      height: 25.0,
                    ),
                    Divider(
                      height: 5,
                      color: Colors.white,
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildRectangleShimmerEffect(
                              height: 20.0,
                              width: 80.0,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            buildRectangleShimmerEffect(
                              height: 20.0,
                              width: 80.0,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildRectangleShimmerEffect(
                              height: 20.0,
                              width: 100.0,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            buildRectangleShimmerEffect(
                              height: 20.0,
                              width: 100.0,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5,)
        ],
      ),
    );
  }

  static Widget buildRectangleShimmerEffect(
      {@required double width, @required double height}) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[500],
        //essa é a cor animada
        highlightColor: Colors.grey[800],
        child: Container(
          color: Colors.white.withAlpha(50),
          margin: EdgeInsets.symmetric(vertical: 4),
        ),
      ),
    );
  }

  static Widget buildRectangleShimmerFull(BuildContext context,
      {double width, double height}) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: width == null ? screenSize.width - 10 : width,
      height: height == null ? 20 : height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[500],
        //essa é a cor animada
        highlightColor: Colors.grey[800],
        child: Container(
          color: Colors.white.withAlpha(50),
          margin: EdgeInsets.symmetric(vertical: 4),
        ),
      ),
    );
  }

  static circularProgressIndicator(
      {Color backgroundColor = Colors.blue, BuildContext context}) {
    return CircularProgressIndicator(
      backgroundColor:
          context == null ? backgroundColor : Theme.of(context).primaryColor,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      strokeWidth: 2.0,
    );
  }
}
