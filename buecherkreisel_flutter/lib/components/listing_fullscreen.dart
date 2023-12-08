import 'package:buecherkreisel_flutter/backend/utils.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:flutter/material.dart';

class ListingFullScreen extends StatelessWidget {
  Listing listing;
  ListingFullScreen({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.memory(imageFromBase64String(listing.imageBase64!)!.bytes),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                listing.title,
                overflow: TextOverflow.clip,
              ),
              IconButton(
                onPressed: () => print("Not FaveIcon implmented"),
                icon: const Icon(Icons.favorite),
              )
            ],
          ),
          Row(
            children: [
              Text("${listing.price}€"),
              const Text("Nur Abholung (hardcoded)"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(listing.location),
              Text(listing.category),
            ],
          ),
          const Divider(),
          Text(
            listing.description,
            overflow: TextOverflow.clip,
          ),
          const Divider(),
          const Text("missing contact possibility"),
        ],
      ),
    );
  }
}
