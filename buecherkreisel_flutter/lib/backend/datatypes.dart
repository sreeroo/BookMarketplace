import 'package:buecherkreisel_flutter/backend/ListingAPI.dart';
import 'package:buecherkreisel_flutter/models/chat.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:buecherkreisel_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ChatState extends ChangeNotifier {
  List<Chat> chats = List.empty(growable: true);

  void updateChats() {
    print("updateChats not yet implemented");
    notifyListeners();
  }
}

class ListingState extends ChangeNotifier {
  List<Listing> listings = List.empty(growable: true);
  List<Listing> ownListings = List.empty(growable: true);
  ListingAPI api = ListingAPI();

  ListingState();

  Future<List<Listing>> getAllListingsRemote() async {
    listings = await api.getAllListings();
    notifyListeners();
    return listings;
  }

  Future<List<Listing>> getOwnListings(String id) async {
    ownListings = await api.searchListings({"user_id": id});
    notifyListeners();
    return ownListings;
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
      print(e);
      return null;
    }
  }
}

class AppState extends ChangeNotifier {
  User user = User(id: "", imageURI: "", username: "", token: "");
  ListingState listingState = ListingState();
  ChatState chatState = ChatState();

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
    this.user = User(id: "", imageURI: "", username: "", token: "");
    listingState.setToken("");
    notifyListeners();
  }
}
