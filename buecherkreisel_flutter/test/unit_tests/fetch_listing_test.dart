import 'dart:math';

import 'package:buecherkreisel_flutter/backend/ListingAPI.dart';
import 'package:buecherkreisel_flutter/backend/backend.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';

import 'fetch_listing_test.mocks.dart';

const baseUrl = "http://10.0.2.2:8080";

@GenerateMocks([http.Client])
void main() {
  //APIClient apiClient = APIClient();
  ListingAPI listingAPI = ListingAPI();
  MockClient mockClient = MockClient();
  //apiClient.client = mockClient;
  listingAPI.setClient(mockClient);

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

  group('getAllListings', () {
    test('returns a list of listings if the http call completes successfully',
        () async {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/listings'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonString, 200));

      // act
      List<Listing> response = await listingAPI.getAllListings();

      // assert
      expect(response, isA<List<Listing>>());
      expect(response[0].id, 1);
      expect(response[0].title, "Listing1");
      expect(response[0].description, "Description1");
      expect(response[1].id, 2);
      expect(response[1].description, "Description2");
    });

    test('throws an exception if the http call completes with an error', () {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/listings'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final response = listingAPI.getAllListings();

      // assert
      expect(response, throwsException);
    });

    test('returns an empty list if the server returns an empty list', () async {
      // arrange
      when(mockClient.get(Uri.parse('$baseUrl/listings'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('[]', 200));

      // act
      final response = await listingAPI.getAllListings();

      // assert
      expect(response, isA<List<Listing>>());
      expect(response, isEmpty);
    });
  });
}
