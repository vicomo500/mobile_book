import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_book/home/HomeScreen.dart';
import 'package:mobile_book/home/VolumeService.dart';
import 'package:mobile_book/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:image_test_utils/image_test_utils.dart';

import 'utils.dart';

void main() {
  //user variable
  User user = User.name(
      firstName: "John",
      lastName: "Doe",
      email: "jdoe@gmail.com",
      phoneNumber: "08012345678",
      password: "1234"
  );

  testWidgets("principal's full name appears correctly", (WidgetTester tester) async {

    provideMockedNetworkImages(() async {

      VolumeService.defaultClient = _provideMockClient(isEmpty: true);

      await pumpArgumentWidget(tester, child: HomeScreen(), args: {"principal": user.toJson()});

      expect(find.text("John Doe"), findsOneWidget);
    });
  });

  /*testWidgets('list appears correctly', (WidgetTester tester) async {
    provideMockedNetworkImages(() async {

      VolumeService.defaultClient = _provideMockClient();


      await pumpArgumentWidget(tester, child: HomeScreen(), args: {"principal": user.toJson()});
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    });
  });*/
}

MockClient _provideMockClient( {bool isEmpty: false} ) {
  VolumeService.apiKey = "dummy-key";
  var response = isEmpty ? null : '{"items":[{"volumeInfo":{"title":"lost world","description":"lost world desc","publisher":"victor","publishedDate":"2020/12/14","averageRating":5.0,"authors":["shakespare"],"categories":["romance"],"imageLinks":{"smallThumbnail":"http://sample","thumbnail":"http://sample2"}}}]}';
  return MockClient((request) async {
    return http.Response(response, 200);
  });
}
/*await tester.runAsync(() async {
    // test code here
});*/