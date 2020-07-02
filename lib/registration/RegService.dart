import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_book/models/User.dart';

class RegService {
  static const String URL  = "https://my-json-server.typicode.com/vicomo500/FakeJSONServer/users";
  static const Map<String, String> HEADERS = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };
  static const String _FRIENDLY_ERROR_MSG = 'Server was unable to perform registration! Please try again';

  static final http.Client _defaultClient = http.Client();

  static Future<bool> registerUser(User user, {http.Client client}) async {
    try{
      client = client == null ? _defaultClient : client;
      final http.Response response = await client.post(
          URL,
          headers: HEADERS,
          body: json.encode(user.toJson())
      );
      if (response.statusCode == 201)
        return true;
      else
        throw Exception(_FRIENDLY_ERROR_MSG);
    }catch(error){
      throw Exception(_FRIENDLY_ERROR_MSG);
    }
  }

}