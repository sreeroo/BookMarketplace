import 'package:buecherkreisel_flutter/backend/ListingAPI.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/components/listing_preview.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late List<Listing>? _listingModel = [];
  late bool _isDisposed = false;

  void _getData(ListingState listingState) async {
    await listingState.getAllListingsRemote();
    setState(() {
      _listingModel = listingState.listings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListingState>(builder: (c, listingState, w) {
      _getData(listingState);
      return _listingModel == null || _listingModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Color.fromARGB(255, 15, 15, 15),
            ))
          : ListView.builder(
              itemCount: _listingModel!.length,
              itemBuilder: (context, index) {
                return ListingPreview(
                  listing: _listingModel![index],
                );
              },
            );
    });
  }
}
