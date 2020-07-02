import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_book/authentication/AuthService.dart';
import 'package:mobile_book/models/User.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class _MockClient extends Mock implements http.Client {}
final client = _MockClient();
main(){
  group("authenticateUser", () {
    test( 'authenticates a valid user successfully', () async {
      //Act
      User validUser = User.name(
          firstName: "John",
          lastName: "Doe",
          email: "jdoe@gmail.com",
          phoneNumber: "08012345678",
          password: "secret",
      );
      //Arrange
      when(client.get(AuthService.URL, headers: AuthService.HEADERS))
          .thenAnswer((_) async =>
          http.Response(
              '[{"id":1, "firstName":"${validUser.firstName}", "lastName":"${validUser.lastName}", "email":"${validUser.email}", "phoneNumber":"${validUser.phoneNumber}", "password": "${validUser.password}" }]',
              200
          ));
      User actual = await AuthService.authenticateUser(validUser.email, validUser.password, client: client);
      //Assert
      expect(actual, validUser);
    });
    test( 'returns null for an invalid user', () async {
      //Arrange
      when(client.get(AuthService.URL, headers: AuthService.HEADERS))
          .thenAnswer((_) async => http.Response(
              '[{"id":1, "firstName":"Mongo", "lastName":"Park", "email":"mpark@yahoomail.com", "phoneNumber":"09012345678", "password": "123" }]',
              200));
      User actual = await AuthService.authenticateUser("jdoe@gmail.com", "secret", client: client);
      //Assert
      expect(actual, null );
    });
  });

  test( 'throws exception on http request code other than 200', () async {
    //Arrange
    when(client.get(AuthService.URL, headers: AuthService.HEADERS))
        .thenAnswer((_) async => http.Response('Not Found',404));
    //Assert
    expect(AuthService.authenticateUser("jdoe@gmail.com", "secret", client: client), throwsException);
  });

}