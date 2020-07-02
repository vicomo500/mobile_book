import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_book/models/User.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_book/utils/Constants.dart';

class AuthService {
  static const String URL  = "https://my-json-server.typicode.com/vicomo500/FakeJSONServer/users";
  static const Map<String, String> HEADERS = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };
  static const String _FRIENDLY_ERROR_MSG = 'Server was unable to perform authentication! Please try again';

  static final LocalAuthentication _localAuthentication = LocalAuthentication();

  static http.Client _defaultClient = http.Client();
  static set defaultClient(http.Client value) {
    _defaultClient = value;
  }

  static Future<User> authenticateUser(String email, String password, {http.Client client}) async {
    try{
      client = client == null ? _defaultClient : client;
      final http.Response response = await client.get(URL, headers: HEADERS);
      if (response.statusCode == 200) {
        return _validateUser(email, password, json.decode(response.body));
      }else
        throw Exception(_FRIENDLY_ERROR_MSG);
    }catch(error){
      throw Exception(_FRIENDLY_ERROR_MSG);
    }
  }

  static User _validateUser(String email, String password, List<dynamic> list){
    for(dynamic data in list){
      User user = User.fromJson(data);
      if(user.email == email && user.password == password)
        return user;
    }
    return null;
  }

  static Future<bool> authenticateFingerprint() async {
      var hasBiometric = await _localAuthentication.canCheckBiometrics;
      if(!hasBiometric)
        throw Exception("Fingerprint authentication is not supported");
      List<BiometricType> availableBiometrics = await _localAuthentication.getAvailableBiometrics();
      if(!availableBiometrics.contains(BiometricType.fingerprint))
        throw Exception("Fingerprint authentication is not supported");
      return  await _localAuthentication
          .authenticateWithBiometrics(
        localizedReason: "Authenticating to ${Constants.APP_NAME}",
        // message for dialog
        useErrorDialogs: true,
        // show error in dialog
        stickyAuth: true, // native process
      );
  }
}