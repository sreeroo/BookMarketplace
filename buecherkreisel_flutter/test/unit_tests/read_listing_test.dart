import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';

import 'read_listing_test.mocks.dart';

const baseUrl = "http://10.0.2.2:8080";

@GenerateMocks([http.Client])
void main() {
  //APIClient apiClient = APIClient();
  ListingState listingAPI = ListingState();
  MockClient mockClient = MockClient();
  //apiClient.client = mockClient;
  listingAPI.api.setClient(mockClient);

  List<String> categories = List.empty(growable: true);

  String jsonString = '''
[
  {
    "id": 1,
    "title": "Listing1",
    "price": 100.0,
    "category": "Category1",
    "offersDelivery": true,
    "description": "Description1",
    "reserved": false,
    "userID": 1,
    "location": "Location1",
    "contact": "Contact1",
    "images": ["Image1"]
  },
  {
    "id": 2,
    "title": "Listing2",
    "price": 200.0,
    "category": "Category2",
    "offersDelivery": false,
    "description": "Description2",
    "reserved": true,
    "userID": 2,
    "location": "Location2",
    "contact": "Contact2",
    "images": ["Image2"]
  }
]
''';

  group('getListings', () {
    test(
        'returns a list of listings and categories if the http call completes successfully',
        () async {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/listings'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonString, 200));

      when(mockClient.get(Uri.parse('$baseUrl/categories'),
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response('["Category1", "Category2"]', 200));

      // act
      List<Listing> listings = await listingAPI.getAllListingsRemote();
      categories = await listingAPI.getCategoriesRemote();

      // assert
      expect(listings, isA<List<Listing>>());
      expect(listings[0].id, 1);
      expect(listings[0].title, "Listing1");
      expect(listings[0].description, "Description1");
      expect(listings[1].id, 2);
      expect(listings[1].description, "Description2");

      expect(categories, isA<List<String>>());
      expect(categories[0], "Category1");
      expect(categories[1], "Category2");
    });

    test('throws an exception if the http call completes with an error', () {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/listings'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final listings = listingAPI.getAllListingsRemote();

      // assert
      expect(listings, throwsException);
    });

    test(
        'returns an empty list if the server returns an empty list and categories',
        () async {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/listings'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('[]', 200));

      when(mockClient.get(Uri.parse('$baseUrl/categories'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('[]', 200));

      // act
      final listings = await listingAPI.getAllListingsRemote();
      categories = await listingAPI.getCategoriesRemote();

      // assert
      expect(listings, isA<List<Listing>>());
      expect(listings, isEmpty);

      expect(categories, isA<List<String>>());
      expect(categories, isEmpty);
    });

    test('returns a listing posted by a user', () async {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/listings/search?user_id=1'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonString, 200));

      when(mockClient.get(Uri.parse('$baseUrl/categories'),
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response('["Category1", "Category2"]', 200));

      // act
      List<Listing> listings = await listingAPI.getOwnListings("1");

      // assert
      expect(listings, isA<List<Listing>>());
      expect(listings[0].id, 1);
      expect(listings[0].title, "Listing1");
      expect(listings[0].description, "Description1");
    });

    test('Set token test', () async {
      // arrange
      listingAPI.setToken("token");

      // act
      String token = listingAPI.api.token;

      // assert
      expect(token, "token");
    });
  });
}
