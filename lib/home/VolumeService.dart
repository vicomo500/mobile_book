import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_book/home/Volume.dart';

class VolumeService {
  static const String _URL  = "https://www.googleapis.com/books/v1/volumes?q=subject:romance";
  static const Map<String, String> HEADERS = {'Content-Type': 'application/json'};
  static const String _FRIENDLY_ERROR_MSG = 'Server was unable to retrieve volumes!!! Please try again';

  static String _apiKey;
  static set apiKey(String value) {
    _apiKey = value;
  }

  static Future<String> _loadApiKey() async {
    return rootBundle.loadStructuredData<String>("secrets.json",
            (value) async {
          Map<String, dynamic> map = json.decode(value);
          return map["api_key"];
        });
  }
  static http.Client _defaultClient = http.Client();
  static set defaultClient(http.Client value) {
    _defaultClient = value;
  }

  static Future<List<Volume>> loadVolumes(startIndex, maxResults, {http.Client client, String apiKey}) async{
    bool hasThrownError = false;
    try{
      client = client == null ? _defaultClient : client;
      apiKey = apiKey != null ? apiKey :  _apiKey == null || _apiKey.isEmpty ? await _loadApiKey() : _apiKey;
      var url = buildUrl(apiKey, startIndex, maxResults);
      final http.Response response = await client.get(url, headers: HEADERS,);
      if (response.statusCode == 200)
        return _parseResponse(json.decode(response.body));
      else{
        hasThrownError = true;
        throw Exception(_FRIENDLY_ERROR_MSG);
      }
    }catch(error){
      throw Exception(
          hasThrownError ?
          "Something went wrong! Tap to try again." :
          _FRIENDLY_ERROR_MSG
      );
    }
  }
  
  static String buildUrl(apiKey, startIndex, maxResults) => "$_URL&key=$apiKey&startIndex=$startIndex&maxResults=$maxResults";

  static List<Volume> _parseResponse(Map<String, dynamic> map) {
      List<Volume> volumes = [];
      for(Map data in map["items"]){
        var volumeInfo = data["volumeInfo"];
        Volume volume = Volume.fromJson(volumeInfo);
        volumes.add(volume);
      }
      return volumes;
  }
}