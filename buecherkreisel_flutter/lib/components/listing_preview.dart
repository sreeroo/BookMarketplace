import 'dart:convert';

import 'package:buecherkreisel_flutter/backend/utils.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:buecherkreisel_flutter/components/listing_fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../backend/datatypes.dart';

class ListingPreview extends StatelessWidget {
  late Listing listing;

  ListingPreview({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {

    return Consumer2<ListingState, AppState>(builder: (c, listingState, appState, w) {
      return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListenableProvider<AppState>.value(
            value: appState,
            child: ListingFullScreen(listing: listing),),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  listing.category,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Ort: ${listing.location}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Image.memory(imageFromBase64String(listing.imageBase64!)!.bytes),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text("Buchtitel: ${listing.title}",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text("Preis : ${listing.price.toString()}€",
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            )
          ],
        ),
      ),
    );
    });
  }
}
