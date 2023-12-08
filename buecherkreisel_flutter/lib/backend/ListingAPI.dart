import 'dart:io';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'backend.dart';

class ListingAPI {
  final _restAPI = APIClient();
  String token = "";

  // CREATE a new Listing on the backend
  Future<dynamic> createListing(Listing listing, File imageFile) async {
    final body = listing.toJson();
    body.addAll({"token": token});
    return await _restAPI.postDataMultipart('listings', body, imageFile);
  }

  // READ list of all Listings from the backend
  Future<List<Listing>> getAllListings() async {
    final response = await _restAPI.fetchData('listings');
    return List<Listing>.from(response.map((e) => Listing.fromJson(e)));
  }

  // READ a specific Listing from the backend
  Future<Listing> getListingById(String id) async {
    final response = await _restAPI.fetchData('listings/$id', {});
    return Listing.fromJson(response);
  }

  // UPDATE an existing Listing on the backend
  Future<dynamic> updateListing(Listing listing, File imageFile) async {
    final body = listing.toJson();
    body.addAll({"token": token});
    return await _restAPI.updateDataMultipart(
        'listings/${listing.id}', body, imageFile);
  }

  // DELETE an existing Listing on the backend
  Future<dynamic> deleteListing(Listing listing, String userID) async {
    return await _restAPI
        .deleteData('listings/${listing.id}?user_id=$userID&token=$token');
  }

  // Search for some listing by parameters
  Future<List<Listing>> searchListings(Map<String, dynamic> query) async {
    final response = await _restAPI.fetchData('listings/search', query);
    return List<Listing>.from(response.map((e) => Listing.fromJson(e)));
  }
}
