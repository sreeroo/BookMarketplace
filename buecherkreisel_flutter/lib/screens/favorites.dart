import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:provider/provider.dart';

import '../components/listing_preview.dart';

class Favorites extends StatefulWidget{
  @override
  FavoriteState createState() => FavoriteState();

  const Favorites({Key? key}) : super(key: key); 
}

class FavoriteState extends State<Favorites> {

  @override
  void initState() {
    super.initState();
    scheduleLikedListingsFetch();
  }

  @override
  void dispose() {
    super.dispose(); 
  }

  void scheduleLikedListingsFetch() {
    // Schedule a callback for the next event loop iteration
    Future.delayed(Duration.zero, fetchLikedListings);
  }

  Future<void> fetchLikedListings() async {
    if(!mounted) return; 
    
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.listingState.getLikedListings(appState.user.likedListings);
    // Call setState if you need to update the UI after fetching data
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (  
        c, appState, w) {

      if (appState.user.token.isEmpty) {
        return const Center(
              child: Text("Login to see your favorites"));
      }

      return appState.listingState.liked_listings.isEmpty
          ? const Center(
              child: Text("You don't have any favorites yet"))
          : ListView.builder(
              itemCount: appState.listingState.liked_listings.length,
              itemBuilder: (context, index) {
                return ListingPreview(
                  listing: appState.listingState.liked_listings.elementAt(index),
                );
              },
            );
    });
  }}