import 'dart:io';

import 'package:buecherkreisel_flutter/backend/ListingAPI.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'listing_api_unit_test.mocks.dart';

const baseUrl = "http://10.0.2.2:8080";

@GenerateMocks([http.Client])
void main() {
  ListingState listingState = ListingState();
  final listingAPI = ListingAPI();
  final mockClient = MockClient();
  listingAPI.setClient(mockClient);
  listingState.api.setClient(mockClient);

  List<String> categories = List.empty(growable: true);

  final listing = Listing(
      id: 1,
      title: "Listing1",
      price: 100.0,
      category: "Category1",
      offersDelivery: true,
      description: "Description1",
      isReserved: false,
      createdBy: 1,
      location: "Location1",
      contact: "Contact1",
      imageBase64: "Image1");

  final imageFile = File('lib/assets/test.jpg');

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

  group('CreateListing', () {
    test('createListing sends a POST request', () async {
      // Arrange

      // Stub the behavior of the APIClient's post method
      when(mockClient.send(any))
          .thenAnswer((_) async => http.StreamedResponse(Stream.empty(), 201));

      // Act
      final response = await listingAPI.createListing(listing, imageFile);

      // Assert
      expect(response.statusCode, 201);
    });

    test('create a listing with an error', () async {
      // Arrange

      // Stub the behavior of the APIClient's patchDataMultipart method
      when(mockClient.send(any))
          .thenAnswer((_) async => http.StreamedResponse(Stream.empty(), 400));

      // Act & Assert
      expect(() async => await listingAPI.createListing(listing, imageFile),
          throwsA(isA<Exception>()));
    });
  });

  group('ReadListings', () {
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
      List<Listing> listings = await listingState.getAllListingsRemote();
      categories = await listingState.getCategoriesRemote();

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
      final listings = listingState.getAllListingsRemote();

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
      final listings = await listingState.getAllListingsRemote();
      categories = await listingState.getCategoriesRemote();

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
      List<Listing> listings = await listingState.getOwnListings("1");

      // assert
      expect(listings, isA<List<Listing>>());
      expect(listings[0].id, 1);
      expect(listings[0].title, "Listing1");
      expect(listings[0].description, "Description1");
    });

    test('Set token test', () async {
      // arrange
      listingState.setToken("token");

      // act
      String token = listingState.api.token;

      // assert
      expect(token, "token");
    });
  });

  group('Update/Patch Listings', () {
    test('patch a listing successfully', () async {
      // Arrange

      // Stub the behavior of the APIClient's patchDataMultipart method
      when(mockClient.send(any))
          .thenAnswer((_) async => http.StreamedResponse(Stream.empty(), 200));

      // Act
      final response = await listingAPI.patchListing(listing, imageFile);

      // Assert
      expect(response.statusCode, 200);
    });

    test('patch a listing with an error', () async {
      // Arrange

      // Stub the behavior of the APIClient's patchDataMultipart method
      when(mockClient.send(any))
          .thenAnswer((_) async => http.StreamedResponse(Stream.empty(), 400));

      // Act & Assert
      expect(() async => await listingAPI.patchListing(listing, imageFile),
          throwsA(isA<Exception>()));
    });

    // test without a image file
    test('patch a listing without a image file', () async {
      // Arrange

      // Stub the behavior of the APIClient's patchDataMultipart method
      when(mockClient.send(any))
          .thenAnswer((_) async => http.StreamedResponse(Stream.empty(), 200));

      // Act
      final response = await listingAPI.patchListing(listing);

      // Assert
      expect(response.statusCode, 200);
    });
  });

  group('DeletListings', () {
    test('delete a listing successfully', () async {
      // arrange

      var uri = Uri.parse(
          '$baseUrl/listings/${listing.id}?user_id=${listing.createdBy}&token=${listingState.api.token}');

      when(mockClient.delete(
        uri,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
        encoding: anyNamed('encoding'),
      )).thenAnswer((_) async => http.Response("", 204));

      // act
      var response = await listingState.deleteListing(
          listing, listing.createdBy.toString());
      // assert
      expect(response.statusCode, 204);
    });

    test('response is null if an exception is thrown when deleting a listing',
        () async {
      // arrange

      var uri = Uri.parse(
          '$baseUrl/listings/${listing.id}?user_id=${listing.createdBy}&token=${listingState.api.token}');

      when(mockClient.delete(
        uri,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
        encoding: anyNamed('encoding'),
      )).thenAnswer((_) async => http.Response("", 404));

      // act
      var response = await listingState.deleteListing(
          listing, listing.createdBy.toString());
      // assert
      expect(response, null);
    });
  });
}
