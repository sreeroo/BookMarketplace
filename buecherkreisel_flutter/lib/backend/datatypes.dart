import 'package:buecherkreisel_flutter/backend/ListingAPI.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:buecherkreisel_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ListingState extends ChangeNotifier {
  List<Listing> listings = List.empty(growable: true);
  List<String> categories = List.empty(growable: true);
  List<Listing> ownListings = List.empty(growable: true);
  ListingAPI api = ListingAPI();

  ListingState();

  Future<List<Listing>> getAllListingsRemote() async {
    listings = await api.getAllListings();
    getCategoriesRemote();
    notifyListeners();
    return listings;
  }

  Future<List<Listing>> getOwnListings(String id) async {
    ownListings = await api.searchListings({"user_id": id});
    getCategoriesRemote();
    notifyListeners();
    return ownListings;
  }

  Future<List<String>> getCategoriesRemote() async {
    categories = await api.getCategories();
    return categories;
  }

  void setToken(String token) async {
    api.token = token;
    notifyListeners();
  }

  Future<dynamic>? deleteListing(Listing listing, String userId) async {
    try {
      ownListings.removeWhere((l) => l.id == listing.id);
      var response = await api.deleteListing(listing, userId);
      notifyListeners();
      return response;
    } catch (e) {
      return null;
    }
  }
}

class AppState extends ChangeNotifier {
  User user = User(id: "", profilePicture: "", username: "", token: "");
  ListingState listingState = ListingState();

  void setUser(User user) {
    this.user = user;
    setToken(user.token);
    listingState.getOwnListings(user.id);
    notifyListeners();
  }

  void setToken(String token) {
    listingState.setToken(token);
    this.user.token = token;
    notifyListeners();
  }

  void logout() {
    this.user = User(id: "", profilePicture: "", username: "", token: "");
    listingState.setToken("");
    notifyListeners();
  }
}
