import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/backend/ListingAPI.dart';
import 'package:buecherkreisel_flutter/components/listing_preview.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:buecherkreisel_flutter/models/user.dart';
import 'package:buecherkreisel_flutter/screens/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'dart:io'; 
import 'listing_preview_test.dart';
import 'package:mockito/mockito.dart';

class MockListingAPI extends Mock implements ListingAPI {
  @override
  Future<List<Listing>> getAllListings() async{
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

    return [listing]; 
  }
}

void main() {
  
  setUpAll(() {
    // ↓ required to avoid HTTP error 400 mocked returns
    HttpOverrides.global = null;
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

    await tester.runAsync(() async {
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => appState),
            ChangeNotifierProvider(create: (_) => ListingState())
          ],
      child: MaterialApp(
        home: Favorites(),
        ),
      ));
    });
    await tester.pumpAndSettle(); 

    expect(find.text("Du hast noch keine Favoriten"), findsOneWidget);

  });

  testWidgets('Test: Anzeigen von favorisierten Anzeigen',
      (WidgetTester tester) async {

    AppState appState = AppState();
    ListingState listingState = ListingState();
    MockListingAPI api = MockListingAPI();
    listingState.api = api; 

    appState.listingState = listingState; 

    User user = User(
        id: '1',
        profilePicture: 'profilePicture',
        username: 'username',
        token: 'token');

    user.likedListings = [1]; 
    appState.user = user; 


    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppState>(create: (_) => appState),
          ChangeNotifierProvider<ListingState>(create: (_) => listingState),
        ],
        child: MaterialApp(home: Favorites()),
      ),
    );

    await tester.pumpAndSettle(); 
    await tester.pump(); 

    expect(find.byType(ListingPreview), findsOneWidget);

  });
}