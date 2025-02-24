import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/components/listing_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ListingState>(builder: (c, listingState, w) {
      if (listingState.listings.isEmpty) {
        listingState.getAllListingsRemote();
      }
      return listingState.listings.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Color.fromARGB(255, 15, 15, 15),
            ))
          : ListView.builder(
              itemCount: listingState.listings.length,
              itemBuilder: (context, index) {
                return ListingPreview(
                  listing: listingState.listings[index],
                );
              },
            );
    });
  }
}
