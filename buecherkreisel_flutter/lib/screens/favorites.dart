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

      Widget content; 
      if (appState.user.token.isEmpty) {
        content = const Center(
              child: Text("Log dich ein, um deine Favoriten zu sehen"));
      } else if(appState.listingState.liked_listings.isEmpty){
        content = const Center(
              child: Text("Du hast noch keine Favoriten")); 
      } else {
        content = ListView.builder(
              itemCount: appState.listingState.liked_listings.length,
              itemBuilder: (context, index) {
                return ListingPreview(
                  listing: appState.listingState.liked_listings.elementAt(index),
                );
              },
            );
      }
      
      return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,  // AppBar will hide when scrolling
            snap: true,  // AppBar can reappear mid-scroll if a dragging motion starts 
            title: Center(
              child: Text(
                "Favoriten",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          SliverList(  // Use SliverList for the content if there are list items to display
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = appState.listingState.liked_listings.elementAt(index);
                return ListingPreview(listing: item);
              },
              childCount: appState.listingState.liked_listings.length,
            ),
          ),
          if (appState.user.token.isEmpty || appState.listingState.liked_listings.isEmpty)
            SliverFillRemaining(  // Use SliverFillRemaining to fill the viewport with the message content
              child: content,
            ),
        ],
      );
    });
  }}