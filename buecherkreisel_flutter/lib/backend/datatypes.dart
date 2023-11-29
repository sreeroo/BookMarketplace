import 'package:buecherkreisel_flutter/backend/ListingAPI.dart';
import 'package:buecherkreisel_flutter/backend/UserAPI.dart';
import 'package:buecherkreisel_flutter/models/chat.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatState extends ChangeNotifier {
  List<Chat> chats = List.empty(growable: true);

  void updateChats() {
    print("updateChats not yet implemented");
    notifyListeners();
  }
}

class ListingState extends ChangeNotifier {
  List<Listing> listings = List.empty(growable: true);
  ListingAPI api = ListingAPI();

  ListingState();

  void getAllListingsRemote() async {
    listings = await api.getAllListings();
    notifyListeners();
  }
}
