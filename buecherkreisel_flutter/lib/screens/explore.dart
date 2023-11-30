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
  final ListingAPI _listingAPI = ListingAPI();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _getData() async {
    _listingModel = await _listingAPI.getAllListings();
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      if (!_isDisposed) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EXPLORE PAGE'),
      ),
      body: _listingModel == null || _listingModel!.isEmpty
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
            ),
    );
  }
}
