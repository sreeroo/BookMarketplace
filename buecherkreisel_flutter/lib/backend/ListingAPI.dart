import 'dart:io';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'backend.dart';

class ListingAPI {
  final restAPI = APIClient();
  String token = "";

  // CREATE a new Listing on the backend
  Future<void> createListing(Listing listing, File imageFile) async {
    final body = listing.toJson();
    body.addAll({"token": token});
    final response =
        await restAPI.postDataMultipart('listings', body, imageFile);
  }

  // READ list of all Listings from the backend
  Future<List<Listing>> getAllListings() async {
    final response = await restAPI.fetchData('listings');
    return List<Listing>.from(response.map((e) => Listing.fromJson(e)));
  }

  // READ a specific Listing from the backend

  Future<Listing> getListingById(String id) async {
    final response = await restAPI.fetchData('listings/$id', {});
    return Listing.fromJson(response);
  }

  // UPDATE an existing Listing on the backend
  Future<Listing> updateListing(Listing listing) async {
    final response =
        await restAPI.updateData('listings/${listing.id}', listing.toJson());
    return Listing.fromJson(response);
  }

  // DELETE an existing Listing on the backend

  Future<void> deleteListing(Listing listing) async {
    await restAPI.deleteData('listings/${listing.id}');
  }

  // Search for some listing by parameters

  Future<List<Listing>> searchListings(Map<String, dynamic> query) async {
    final response = await restAPI.fetchData('listings/search', query);
    return List<Listing>.from(response.map((e) => Listing.fromJson(e)));
  }
}
