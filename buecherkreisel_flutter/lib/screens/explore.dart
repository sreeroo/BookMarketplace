import 'package:buecherkreisel_flutter/components/listing_preview.dart';
import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: sampleDataListing.length,
      itemBuilder: (c, index) =>
          ListingPreview(listing: sampleDataListing[index]),
    );
  }
}
