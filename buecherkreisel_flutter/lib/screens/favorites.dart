import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/listing_preview.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ListingState, AppState>(builder: (
        c, listingState, appState, w) {

      if (appState.user.token.isEmpty) {
        return const Center(
              child: Text("Login to see your favorites"));
      }

      return listingState.likedListings.isEmpty
          ? const Center(
              child: Text("You don't have any favorites yet"))
          : ListView.builder(
              itemCount: listingState.likedListings.length,
              itemBuilder: (context, index) {
                return ListingPreview(
                  listing: listingState.likedListings.elementAt(index),
                );
              },
            );
    });
  }}