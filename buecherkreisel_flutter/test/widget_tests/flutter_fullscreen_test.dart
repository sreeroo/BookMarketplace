import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/components/listing_fullscreen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:buecherkreisel_flutter/models/user.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'listing_preview_test.dart';

void main() {
  Listing createDummyListing(bool reserved) {
    return Listing(
        id: 1,
        category: 'Books',
        location: 'Munich',
        imageBase64: getDummyImageBase64String(),
        title: 'Demo Listing',
        price: 20.0,
        offersDelivery: false,
        description: '',
        isReserved: reserved,
        createdBy: 21,
        contact: "a@b.c");
  }



  User createDummyUser() {
    return User(
      id: "",
      profilePicture: "",
      username: "",
      token: "",
    ); 
  }

  setUpAll(() {
    // ↓ required to avoid HTTP error 400 mocked returns
    HttpOverrides.global = null;
  });

  testWidgets('Test: ListingFullScreen zeigt alle Elemente an',
      (WidgetTester tester) async {
    Listing dummyListing = createDummyListing(false);
    await tester.pumpWidget(MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => AppState())
        ],
    child: MaterialApp(
      home: ListingFullScreen(listing: dummyListing, user: createDummyUser()),
      ),
    ));

    // Überprüfen Sie, ob alle erwarteten Elemente angezeigt werden
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Text),
        findsNWidgets(10)); // Anzahl der Text-Widgets anpassen
    expect(find.byType(GestureDetector), findsOneWidget);
    expect(find.byType(Divider),
        findsNWidgets(2)); // Anzahl der Divider-Widgets anpassen

    expect(find.text('Kategorie: ${dummyListing.category}'), findsOneWidget);
    expect(find.text('Ort: ${dummyListing.location}'), findsOneWidget);
    expect(find.text('Beschreibung:'), findsOneWidget);
    expect(find.text(dummyListing.description), findsOneWidget);
    expect(find.text(dummyListing.title), findsAtLeast(1));
    expect(find.text('${dummyListing.price}€'), findsOneWidget);
    expect(find.text('Versand möglich: '), findsOneWidget);
    expect(find.text('Kontakt:'), findsOneWidget);
    expect(find.text(dummyListing.contact), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(GestureDetector), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    final Finder opacityWidget = find.byType(Opacity);
    expect(opacityWidget, findsOneWidget);

    final Opacity opacity = tester.widget(opacityWidget);
    expect(opacity.opacity, equals(1));

    expect(find.text("Reserviert"), findsNothing);
  });

  testWidgets('Test: IconButton reagiert auf Taps',
      (WidgetTester tester) async {
    Listing listing = createDummyListing(false); 
    User user = createDummyUser(); 
    await tester.pumpWidget(MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => AppState())
        ],
    child: MaterialApp(
      home: ListingFullScreen(listing: listing, user: user),
      ),
    ));

    // Überprüfen Sie, ob der IconButton auf Taps reagiert
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();

    // In diesem Fall wird nur überprüft, ob der IconButton getappt werden kann, da er momentan nur eine Drucknachricht ausgibt
    expect(find.text("Bitte logge dich ein"), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget); 
    expect(find.byIcon(Icons.favorite), findsNothing); 
  });

  testWidgets('Test: Opacity and Reserved Text is shown',
      (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => AppState())
        ],
    child: MaterialApp(
      home: ListingFullScreen(listing: createDummyListing(true), user: createDummyUser()),
      ),
    ));

    expect(find.byType(Image), findsOneWidget);

    final Finder opacityWidget = find.byType(Opacity);
    expect(opacityWidget, findsOneWidget);

    final Opacity opacity = tester.widget(opacityWidget);
    expect(opacity.opacity, equals(0.25));

    expect(find.text("Reserviert"), findsOneWidget);
  });

}
