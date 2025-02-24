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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                  backgroundColor: Colors.redAccent,
                  child: Text(state.user.username.characters.first.toUpperCase()),
                ),
                title: Text(state.user.username),
                trailing: IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => state.logout(),
                ),
              ),
            ),
            const Divider(),
            //ownlistings
            // List of own listings
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Deine Listings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Consumer<ListingState>(
              builder: (c, listingState, w) => Expanded(
                child: listingState.ownListings.isEmpty
                    ? const Center(
                        child: Text(
                          "Sie haben noch keine Listings erstellt.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: listingState.ownListings.length,
                        itemBuilder: (context, index) {
                          final listing = listingState.ownListings[index];
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
                                    child: const Text('Bearbeiten'),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      try {
                                        listingState
                                            .deleteListing(
                                                listing, state.user.id)
                                            ?.then((value) {
                                          if (value.statusCode <= 300) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Listing erfolgreich gelöscht."),
                                                  duration: Durations.medium4),
                                            );
                                          }
                                        });
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: const Text('Löschen'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
              ),
            )
          ],
        );
      },
    );
  }
}
