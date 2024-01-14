import 'dart:io';

import 'package:buecherkreisel_flutter/backend/ListingAPI.dart';
import 'package:buecherkreisel_flutter/backend/UserAPI.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/components/listing_fullscreen.dart';
import 'package:buecherkreisel_flutter/components/listing_preview.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:buecherkreisel_flutter/models/user.dart';
import 'package:buecherkreisel_flutter/screens/explore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  /**setUpAll(() async {

    // Create user
    UserAPI userAPI = UserAPI();
    User user = await userAPI.createUser('username', 'password');

    // Create Listing
    Listing listing = Listing(id: 1,
        title: 'title',
        price: 9,
        category: 'INFORMATIK',
        offersDelivery: false,
        description: 'description',
        isReserved: false,
        createdBy: int.parse(user.id),
        location: 'location',
        contact: 'contact');

    ListingAPI listingAPI = ListingAPI();
    await listingAPI.createListing(listing, File('lib/assets/test.jpg'));
  });**/


  group("Favorites", () {
    testWidgets('Test: Like Listing',
            (WidgetTester tester) async {

      // Create user
      UserAPI userAPI = UserAPI();
      User user = await userAPI.createUser('username', 'password');

      //Logge Nutzer ein
      AppState appState = AppState();
      appState.user = user;
      appState.setUser(user);
      appState.setToken(user.token);

      // Create Listing
      Listing listing = Listing(id: 1,
          title: 'title',
          price: 9,
          category: 'INFORMATIK',
          offersDelivery: false,
          description: 'description',
          isReserved: false,
          createdBy: int.parse(user.id),
          location: 'location',
          contact: 'contact');

      ListingAPI listingAPI = ListingAPI();
      listingAPI.token = user.token;
      File file = File('./lib/assets/test.jpg');

      if (!file.existsSync()) {
        throw const FileSystemException("Couldn't find file");
      }

      await listingAPI.createListing(listing, file);

      // Create ListingState
      ListingState listingState = ListingState();

      // Setup Listing
      listingState.getAllListingsRemote();

      // Start on the Explore page
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AppState>.value(value: appState),
            ChangeNotifierProvider<ListingState>.value(value: listingState),
          ],
          child: const MaterialApp(home: Explore()),
        ),
      );

      // Wait for backend to create user and listing
      // Increase if CircularProgressIndicator fails
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(Explore), findsOneWidget);
      expect(find.byType(CircularProgressIndicator),
          findsNothing,
          reason: "The backend hasn't created the user and listing yet.\nIncrease waiting time in test code.");
      expect(find.byType(ListingPreview), findsOneWidget);

      // Wechseln auf Fullscreen page
      await tester.tap(find.byType(ListingPreview));
      await tester.pumpAndSettle(Durations.extralong4);

      expect(find.byType(ListingFullScreen), findsOneWidget);
      final iconFinder = find.byIcon(Icons.favorite_border);
      expect(iconFinder, findsOne);

      // Like listing
      await tester.scrollUntilVisible(iconFinder, 300);
      await tester.tap(iconFinder);
      expect(find.byIcon(Icons.favorite), findsOne);
    });
  });
}