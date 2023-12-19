import 'package:buecherkreisel_flutter/components/listing_fullscreen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';

import 'listing_preview_test.dart';

void main() {
  Listing createDummyListing() {
    return Listing(
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
    );
  }

  testWidgets('Test: ListingFullScreen zeigt alle Elemente an',
      (WidgetTester tester) async {
    Listing dummyListing = createDummyListing();
    await tester.pumpWidget(MaterialApp(
      home: ListingFullScreen(listing: dummyListing),
    ));

    // Überprüfen Sie, ob alle erwarteten Elemente angezeigt werden
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Text),
        findsNWidgets(7)); // Anzahl der Text-Widgets anpassen
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byType(Divider),
        findsNWidgets(2)); // Anzahl der Divider-Widgets anpassen

    expect(find.text(dummyListing.category), findsOneWidget);
    expect(find.text(dummyListing.location), findsOneWidget);
    expect(find.text(dummyListing.title), findsOneWidget);
    expect(find.text('${dummyListing.price}€'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(GestureDetector), findsOneWidget);
  });

  testWidgets('Test: IconButton reagiert auf Taps',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ListingFullScreen(listing: createDummyListing()),
    ));

    // Überprüfen Sie, ob der IconButton auf Taps reagiert
    await tester.tap(find.byType(IconButton));
    await tester.pump();

    // Überprüfen Sie hier die erwartete Aktion, z.B. ob ein bestimmter Text angezeigt wird
    // In diesem Fall wird nur überprüft, ob der IconButton getappt werden kann, da er momentan nur eine Drucknachricht ausgibt
  });
}
