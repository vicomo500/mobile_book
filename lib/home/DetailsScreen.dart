import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobile_book/utils/Constants.dart';
import 'package:mobile_book/utils/widget_util.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'Volume.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map  args = ModalRoute.of(context).settings.arguments;
    Volume volume = Volume.fromJson(args["volume"]);

    return Scaffold(
        appBar: buildAppBar(""),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _getThumbnail(volume),
            ),
            buildColumnSpacing(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: Constants.LAYOUT_PADDING),
              child: Text(
                volume.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.5,
                  wordSpacing: 2.0,
                ),
              ),
            ),
            buildColumnSpacing(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: Constants.LAYOUT_PADDING),
              child: Text(
                volume.authors != null ? volume.authors.join("\n") : "N/A",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17.0,
                    letterSpacing: 1.2,
                    wordSpacing: 1.5,
                ),
              ),
            ),
            _getRatingBar(volume),
            buildColumnSpacing(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: Constants.LAYOUT_PADDING),
              child: Text(
                volume.description,
                softWrap: true,
                style: TextStyle(
                  fontSize: 17.0,
                  letterSpacing: 1.5,
                  wordSpacing: 2.0,
                  height: 1.5,
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget _getThumbnail(Volume volume) =>
      volume.imageLinks == null || volume.imageLinks.thumbnail == null ?
      Image.asset(
          'assets/images/placeholder.png',
          width: 100,//double.infinity,
          height: 240,
          fit: BoxFit.cover,
      ) :
      FadeInImage.assetNetwork(
          placeholder: "assets/images/loading.gif",
          image: volume.imageLinks.thumbnail,
          width: 100,//double.infinity,
          height: 240,
          fit: BoxFit.contain,
      );

  Widget _getRatingBar(Volume volume) =>
      volume.averageRating == null ?
          SizedBox(height: 0.0, width: 0.0,) :
        Column(
          children: <Widget>[
            buildColumnSpacing(height: 4.0),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: Constants.LAYOUT_PADDING),
              alignment: Alignment.center,
              child: RatingBar(
                initialRating: volume.averageRating,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 24,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 24.0,
                ),
                onRatingUpdate: (rating){},
              ),
            ),
          ],
        );

}

