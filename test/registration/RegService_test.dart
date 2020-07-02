import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_book/models/User.dart';
import 'package:mobile_book/registration/RegService.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class _MockClient extends Mock implements http.Client {}
final client = _MockClient();

final User _testUser = User.name(
  firstName: "John",
  lastName: "Doe",
  email: "jdoe@gmail.com",
  phoneNumber: "08012345678",
  password: "secret",
);

main(){
  group("registerUser", (){
    test("user registers successfully", () async {
      //Arrange
      when(client.post(RegService.URL, headers: RegService.HEADERS, body: json.encode(_testUser.toJson())))
          .thenAnswer((_) async => http.Response("OK", 201));
      //Assert
      expect( await RegService.registerUser(_testUser, client: client), isTrue );
    });
    test("throws on http status code other than 201", () async {
      //Arrange
      when(client.post(RegService.URL, headers: RegService.HEADERS, body: json.encode(_testUser.toJson())))
          .thenAnswer((_) async => http.Response("OK", 500));
      //Assert
      expect( RegService.registerUser(_testUser, client: client), throwsException );
    });
  });
}