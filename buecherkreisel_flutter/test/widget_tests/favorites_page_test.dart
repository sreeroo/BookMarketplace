import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/components/listing_preview.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:buecherkreisel_flutter/models/user.dart';
import 'package:buecherkreisel_flutter/screens/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'listing_preview_test.dart';

void main() {
  
  testWidgets('Test: Nicht eingeloggt Meldung.',
      (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
          ChangeNotifierProvider(create: (_) => ListingState())
        ],
    child: const MaterialApp(
      home: Favorites(),
      ),
    ));

    expect(find.text('Login to see your favorites'), findsOneWidget);

  });

  testWidgets('Test: Nicht eingeloggt Meldung.',
      (WidgetTester tester) async {

    AppState appState = AppState();

    User user = User(
        id: '1',
        profilePicture: 'profilePicture',
        username: 'username',
        token: 'token');

    appState.user = user;

    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: appState),
          ChangeNotifierProvider(create: (_) => ListingState())
        ],
    child: const MaterialApp(
      home: Favorites(),
      ),
    ));

    expect(find.text("You don't have any favorites yet"), findsOneWidget);

  });

  testWidgets('Test: Anzeigen von favorisierten Anzeigen',
      (WidgetTester tester) async {

    AppState appState = AppState();
    ListingState listingState = ListingState();

    User user = User(
        id: '1',
        profilePicture: 'profilePicture',
        username: 'username',
        token: 'token');

    appState.user = user;

    Listing listing = Listing(
        id: 1,
        category: 'Books',
        location: 'Munich',
        imageBase64: getDummyImageBase64String(),
        title: 'Demo Listing',
        price: 20.0,
        offersDelivery: false,
        description: '',
        isReserved: false,
        createdBy: 21,
        contact: "a@b.c");

    listingState.likedListings = {listing};

    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: appState),
          ChangeNotifierProvider.value(value: listingState)
        ],
    child: const MaterialApp(
      home: Favorites(),
      ),
    ));

    expect(find.byType(ListingPreview), findsOneWidget);

  });
}