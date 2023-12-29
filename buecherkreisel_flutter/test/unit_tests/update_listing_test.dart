import 'dart:io';

import 'package:buecherkreisel_flutter/backend/ListingAPI.dart';
import 'package:buecherkreisel_flutter/backend/backend.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';

import 'update_listing_test.mocks.dart';

const baseUrl = "http://10.0.2.2:8080";

@GenerateMocks([http.Client])
void main() {
  ListingAPI listingAPI = ListingAPI();
  MockClient mockClient = MockClient();
  listingAPI.setClient(mockClient);

  Listing listing = Listing(
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
    imageBase64: "Image1",
  );

  final endpoint = '$baseUrl/listings/${listing.id}';
  final imageFile = File('lib/assets/test.jpg');

  group('patchListing', () {
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
}
