import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/listing_preview.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ListingState>(builder: (c, listingState, w) {

      AppState appState = Provider.of<AppState>(context);

      if (appState.user.token.isEmpty) {
        return const Center(
              child: Text("Login to see your favorites"));
      }

      if (listingState.likedListings.isEmpty) {
        listingState.getLikedListings(appState.user);
      }

      return appState.user.token.isEmpty
          ? const Center(
              child: Text("You don't have any favorites yet"))
          : ListView.builder(
              itemCount: listingState.likedListings.length,
              itemBuilder: (context, index) {
                return ListingPreview(
                  listing: listingState.likedListings[index],
                );
              },
            );
    });
  }}