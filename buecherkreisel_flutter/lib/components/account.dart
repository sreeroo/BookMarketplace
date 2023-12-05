import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/components/listing_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
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
            ...state.listingState.ownListings
                .map((listing) => ListingPreview(listing: listing))
                .toList()
          ],
        );
      },
    );
  }
}
