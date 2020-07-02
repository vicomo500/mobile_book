
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_book/home/DetailsScreen.dart';
import 'package:mobile_book/home/Volume.dart';
import 'utils.dart';

void main(){
  testWidgets('details screen loaded correctly', (WidgetTester tester) async {
    Volume volume = Volume(
      "Hamlet",
      ["William Shakespare"],
      ["fiction"],
      Thumbnail(smallThumbnail: "http://example/smallThumbnail", thumbnail: "http://example/thumbnail"),
      "a very tragic story",
      "Amazon",
      "2020/04/05",
      4.0
    );
    provideMockedNetworkImages(() async {
      await pumpArgumentWidget(tester, child: DetailsScreen(), args: {"volume": volume.toJson()});
      expect(find.text(volume.title), findsOneWidget);
      expect(find.text(volume.description), findsOneWidget);
      expect(find.byType(RatingBar), findsOneWidget);
      expect(find.byType(FadeInImage), findsOneWidget);
    });
  });
}