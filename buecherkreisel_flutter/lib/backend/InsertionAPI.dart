import 'package:http/http.dart' as http;
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'backend.dart';

class ListingAPI {
  final restAPI = APIClient();
/** 
  // CREATE a new Listing on the backend
  Future<Listing> createListing(http.Client client, Listing listing) async {
    final response =
        await restAPI.postData(client, 'listings', listing.toJson());
    return Listing.fromJson(response);
  }

  // READ list of all Listings from the backend
  Future<List<Listing>> getAllListings(http.Client client) async {
    final response = await restAPI.fetchData(client, 'listings');
    return List<Listing>.from(response.map((e) => Listing.fromJson(e)));
  }

  // READ a specific Listing from the backend

  Future<Listing> getListingById(http.Client client, String id) async {
    final response = await restAPI.fetchData(client, 'listings/$id');
    return Listing.fromJson(response);
  }

  // UPDATE an existing Listing on the backend
  Future<Listing> updateListing(http.Client client, Listing listing) async {
    final response = await restAPI.updateData(
        client, 'listings/${listing.id}', listing.toJson());
    return Listing.fromJson(response);
  }

  // DELETE an existing Listing on the backend

  Future<void> deleteListing(http.Client client, Listing listing) async {
    await restAPI.deleteData(client, 'listings/${listing.id}');
  }

  // Search for some listing by parameters

  Future<List<Listing>> searchListings(http.Client client, String query) async {
    final response = await restAPI.fetchData(client, 'listings?search=$query');
    return List<Listing>.from(response.map((e) => Listing.fromJson(e)));
  }*/
}
