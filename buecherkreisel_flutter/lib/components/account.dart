import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/components/listing_preview.dart';
import 'package:buecherkreisel_flutter/screens/add.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (b, state, w) {
        state.listingState.getOwnListings(state.user.id);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(state.user.imageURI),
                ),
                title: Text(state.user.username),
                trailing: IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () => state.logout(),
                ),
              ),
            ),
            Divider(),
            //ownlistings
            // List of own listings
            const Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Your Listings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: state.listingState.ownListings.isEmpty
                  ? const Center(
                      child: Text(
                        "You don't have any listings yet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: state.listingState.ownListings.length,
                      itemBuilder: (context, index) {
                        final listing = state.listingState.ownListings[index];
                        return Column(
                          children: [
                            ListingPreview(listing: listing),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider.value(
                                          value: state,
                                          child: AddUpdateListing(
                                              listing: listing),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Edit'),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    state.listingState
                                        .deleteListing(listing, state.user.id)
                                        ?.then((value) {
                                      if (value.statusCode <= 300) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Listing deleted successfully"),
                                          ),
                                        );
                                      }
                                    });
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
