import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';

import 'delete_listing_test.mocks.dart';

const baseUrl = "http://10.0.2.2:8080";

@GenerateMocks([http.Client])
void main() {
  ListingState listingAPI = ListingState();
  MockClient mockClient = MockClient();
  listingAPI.api.setClient(mockClient);
  listingAPI.setToken("token");

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

  group('deleteListing', () {
    test('delete a listing successfully', () async {
      // arrange

      var uri = Uri.parse(
          '$baseUrl/listings/${listing.id}?user_id=${listing.createdBy}&token=${listingAPI.api.token}');

      when(mockClient.delete(
        uri,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
        encoding: anyNamed('encoding'),
      )).thenAnswer((_) async => http.Response("", 204));

      // act
      var response =
          await listingAPI.deleteListing(listing, listing.createdBy.toString());

      // assert
      expect(response.statusCode, 204);
    });

    test('response is null if an exception is thrown when deleting a listing',
        () async {
      // arrange

      var uri = Uri.parse(
          '$baseUrl/listings/${listing.id}?user_id=${listing.createdBy}&token=${listingAPI.api.token}');

      when(mockClient.delete(
        uri,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
        encoding: anyNamed('encoding'),
      )).thenAnswer((_) async => http.Response("", 404));

      // act
      var response =
          await listingAPI.deleteListing(listing, listing.createdBy.toString());

      // assert
      // throws exception
      expect(response, null);
    });
  });
}
