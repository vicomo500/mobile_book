import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:http/testing.dart';
import 'package:mobile_book/authentication/AuthService.dart';
import 'package:mobile_book/home/VolumeService.dart';
import 'package:http/http.dart' as http;

void main() {
  group('mobile_book', () {

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('check flutter driver health', () async {
      final health = await driver.checkHealth();
      expect(health.status, HealthStatus.ok);
    });

    test('login successfully', () async {
      _httClientsSetup();
      final email = find.byValueKey('email');
      final password = find.byValueKey('password');
      final submit = find.byValueKey('submit');
      final welcome = find.byValueKey('welcome-text');
      //type email
      await driver.tap(email);
      await driver.enterText("mpark@yahoomail.com");
      await driver.waitFor(find.text('mpark@yahoomail.com'));
      //type password
      await driver.tap(password);
      await driver.enterText("123");
      await driver.waitFor(find.text('123'));
      //submit
      await driver.tap(submit);

      expect(await driver.getText(welcome), "Welcome");
    });
  });
}

void _httClientsSetup() {
  AuthService.defaultClient = MockClient((request) async {
    return http.Response(
        '[{"id":1, "firstName":"Mongo", "lastName":"Park", "email":"mpark@yahoomail.com", "phoneNumber":"09012345678", "password": "123" }]',
        200);
  });
  VolumeService.defaultClient = MockClient((request) async {
    return http.Response(
        '{"items":[{"volumeInfo":{"title":"lost world","description":"lost world desc","publisher":"victor","publishedDate":"2020/12/14","averageRating":5.0,"authors":["shakespare"],"categories":["romance"],"imageLinks":{"smallThumbnail":"http://sample","thumbnail":"http://sample2"}}}]}',
        200);
  });
  VolumeService.apiKey = "dummy-key";
}