import 'dart:convert';

import 'package:buecherkreisel_flutter/components/listing_fullscreen.dart';
import 'package:buecherkreisel_flutter/components/listing_preview.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:buecherkreisel_flutter/backend/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Helper Funktion, die ein Dummy-Bild als Base64-String generiert.
String getDummyImageBase64String() {
  return "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAA1JREFUGFdjeBzj9x8ABkACjSiE1WYAAAAASUVORK5CYII="; //one white pixel
}

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
      contact: "a@b.c");
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

//Edit-Aufruf testen
void main() {
  late NavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  Future<void> _buildMainPage(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ListingPreview(listing: createDummyListing()),

      // This mocked observer will now receive all navigation events
      // that happen in our app.
      navigatorObservers: [mockObserver],
    ));

    // The tester.pumpWidget() call above just built our app widget
    // and triggered the pushObserver method on the mockObserver once.
    //verify(mockObserver.didPush(any!, any));
  }

  testWidgets('Test: Listing Preview zeigt Informationen korrekt',
      (tester) async {
    Listing dummyListing = createDummyListing();
    await tester
        .pumpWidget(MaterialApp(home: ListingPreview(listing: dummyListing)));

    expect(find.text(dummyListing.category), findsOneWidget);
    expect(find.text(dummyListing.location), findsOneWidget);
    expect(find.text(dummyListing.title), findsOneWidget);
    expect(find.text('${dummyListing.price}€'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(GestureDetector), findsOneWidget);
  });

  //testWidgets('Test: FullScreen öffnet on Tap', (tester) async {
  //  final mockObserver = MockNavigatorObserver();
  //  await tester.pumpWidget(MaterialApp(
  //    home: ListingPreview(listing: createDummyListing()),
  //    navigatorObservers: [mockObserver],
  //  ));
//
  //  expect(find.byType(GestureDetector), findsOneWidget);
//
  //  await tester.tap(find.byType(GestureDetector));
  //  await tester.pumpAndSettle();
//
  //  verify(mockObserver.didPush(any,any);
//
//
  //  expect(find.byType(ListingFullScreen), findsOneWidget);
  //});
}
