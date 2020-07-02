import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_book/home/Volume.dart';
import 'package:mobile_book/home/VolumeService.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class _MockClient extends Mock implements http.Client {}
final client = _MockClient();

main(){
  group("loadVolumes", () {
    //Act
    var startIndex = 0; var maxResults = 5; var apiKey ="apiKey";
    test('returns a list of volumes if the http call completes successfully', () async {
      //Arrange
      when(client.get(VolumeService.buildUrl(apiKey, startIndex, maxResults), headers: VolumeService.HEADERS))
          .thenAnswer((_) async => http.Response(_response, 200));
      //Assert
      expect(await VolumeService.loadVolumes(startIndex, maxResults, client: client, apiKey: apiKey), isA<List<Volume>>());
    });

    test('throws an exception if the http call completes with an error', () {
      //Arrange
      when(client.get(VolumeService.buildUrl(apiKey, startIndex, maxResults), headers: VolumeService.HEADERS))
          .thenAnswer((_) async => http.Response(null, 400));
      //Assert
      expect(VolumeService.loadVolumes(startIndex, maxResults, client: client, apiKey: apiKey), throwsException);
    });

  });
}

String _response = '{"items":[{"volumeInfo":{"title":"lost world","description":"lost world desc","publisher":"victor","publishedDate":"2020/12/14","averageRating":5.0,"authors":["shakespare"],"categories":["romance"],"imageLinks":{"smallThumbnail":"http://sample","thumbnail":"http://sample2"}}}]}';