import 'dart:io';

import 'package:buecherkreisel_flutter/backend/ListingAPI.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_listing_test.mocks.dart';

const baseUrl = "http://10.0.2.2:8080";

@GenerateMocks([http.Client])
void main() {
  final listingAPI = ListingAPI();
  final mockClient = MockClient();
  listingAPI.setClient(mockClient);

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

  group('ListingAPI', () {
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
}
