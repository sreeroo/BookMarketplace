import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:buecherkreisel_flutter/models/user.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/screens/add.dart';
import 'package:buecherkreisel_flutter/backend/ListingAPI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;


class MockListingAPI extends Mock implements ListingAPI {

  Future<http.StreamedResponse> createListing(
      Listing listing, File imageFile) async {
    return http.StreamedResponse(Stream.value([]), 201);
  }
}

void main() {
  setUpAll(() {
    // ↓ required to avoid HTTP error 400 mocked returns
    HttpOverrides.global = null;
  });

  testWidgets('AddUpdateListing controllers test', (WidgetTester tester) async {
    // Mock the necessary data or state if needed
    // Example: AppState mockAppState = MockAppState();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const MaterialApp(
          home: Scaffold(
            body: AddUpdateListing(),
          ),
        ),
      ),
    );

    // Test title controller
    const String titleTestInput = "Test Title";
    await tester.enterText(find.byKey(const Key("title")), titleTestInput);
    await tester.pump();
    // Find the TextFormField and check if the text matches
    expect(find.widgetWithText(TextFormField, titleTestInput), findsOneWidget);

    // Test description controller
    const String descriptionTestInput = "Test Description";
    await tester.enterText(find.byKey(const Key("desc")), descriptionTestInput);
    await tester.pump();
    expect(find.widgetWithText(TextFormField, descriptionTestInput), findsOneWidget);

    // Test price controller
    const String priceTestInput = "100";
    await tester.enterText(find.byKey(const Key("price")), priceTestInput);
    await tester.pump();
    expect(find.widgetWithText(TextFormField, priceTestInput), findsOneWidget);

    // Test location controller
    const String locationTestInput = "Test Location";
    await tester.enterText(find.byKey(const Key("location")), locationTestInput);
    await tester.pump();
    expect(find.widgetWithText(TextFormField, locationTestInput), findsOneWidget);

    // Test contact controller
    const String contactTestInput = "Test Contact";
    await tester.enterText(find.byKey(const Key("contact")), contactTestInput);
    await tester.pump();
    expect(find.widgetWithText(TextFormField, contactTestInput), findsOneWidget);
  });

  testWidgets('Wrong Inputs Controllers Test', (WidgetTester tester) async {

    User user = User(id: "1", profilePicture: "", username: "Bob", token: "1", totalListings: "0"); 
    ListingState listingState = ListingState(); 
    AppState mockAppState = AppState(); 
    mockAppState.user = user; 
    mockAppState.listingState = listingState; 

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => mockAppState,
        child: const MaterialApp(
          home: Scaffold(
            body: AddUpdateListing(),
          ),
        ),
      ),
    );

    // Test title controller
    const String titleTestInput = "";
    await tester.enterText(find.byKey(const Key("title")), titleTestInput);
    await tester.tap(find.byType(ElevatedButton).last); 
    await tester.pump();
    expect(find.text("Bitte gib einen Titel ein."), findsOneWidget);

    // Test description controller
    const String descriptionTestInput = "";
    await tester.enterText(find.byKey(const Key("desc")), descriptionTestInput);
    await tester.tap(find.byType(ElevatedButton).last); 
    await tester.pump();
    expect(find.text("Bitte gib eine Beschreibung ein."), findsOneWidget);

    // Test price controller
    const String priceTestInput = "Falscher Price";
    await tester.enterText(find.byKey(const Key("price")), priceTestInput);
    await tester.tap(find.byType(ElevatedButton).last);
    await tester.pump();
    expect(find.text("Bitte gib eine Zahl ein."), findsOneWidget);

    // Test location controller
    const String locationTestInput = "";
    await tester.enterText(find.byKey(const Key("location")), locationTestInput);
    await tester.tap(find.byType(ElevatedButton).last); 
    await tester.pump();
    expect(find.text("Bitte gib einen Ort ein."), findsOneWidget);
  });

  testWidgets('Test select categories', (WidgetTester tester) async {

    User user = User(id: "1", profilePicture: "", username: "Bob", token: "1", totalListings: "0"); 
    ListingState listingState = ListingState(); 
    listingState.categories = ["DerBär", "Mensch ärgere dich nicht"]; 
    AppState mockAppState = AppState(); 
    mockAppState.user = user; 
    mockAppState.listingState = listingState; 

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => mockAppState,
        child: const MaterialApp(
          home: Scaffold(
            body: AddUpdateListing(),
          ),
        ),
      ),
    );

    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget); 
    await tester.tap(find.byType(DropdownButtonFormField<String>)); 
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton).last); 
    await tester.pump();

    expect(find.text("Bitte wähle eine Kategorie aus."), findsNothing);
    expect(find.text("DerBär"), findsOneWidget);
  });

  testWidgets('Checkbox initializes correctly', (WidgetTester tester) async {
    // Setup the initial state of your checkbox
    bool _checkboxValue = false; // Or true, if it should start checked

    // Define a StatefulWidget to test this functionality
    Widget testWidget = MaterialApp(
      home: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Scaffold(
            body: Row(
              children: <Widget>[
                Checkbox(
                  value: _checkboxValue,
                  onChanged: (bool? value) {
                    setState(() {
                      _checkboxValue = value!;
                    });
                  },
                ),
                const Text('Lieferung möglich'),
              ],
            ),
          );
        },
      ),
    );

    // Attach the testWidget to the test harness
    await tester.pumpWidget(testWidget);

    // Verify Checkbox is rendered and is not checked
    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(checkbox.value, equals(_checkboxValue));
    expect(find.text('Lieferung möglich'), findsOneWidget);
  });

  testWidgets('Checkbox updates when tapped', (WidgetTester tester) async {
    bool _checkboxValue = false;

    Widget testWidget = MaterialApp(
      home: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Scaffold(
            body: Row(
              children: <Widget>[
                Checkbox(
                  value: _checkboxValue,
                  onChanged: (bool? value) {
                    setState(() {
                      _checkboxValue = value!;
                    });
                  },
                ),
                const Text('Lieferung möglich'),
              ],
            ),
          );
        },
      ),
    );

    // Attach the testWidget to the test harness
    await tester.pumpWidget(testWidget);

    // Tap the checkbox to change its value
    await tester.tap(find.byType(Checkbox));
    await tester.pump(); // Rebuild the widget with the new state

    // Verify Checkbox is updated
    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(checkbox.value, isTrue); // If initial was false, now it should be true
  });

  testWidgets('Try save listing when not logged in', (WidgetTester tester) async {

    User user = User(id: "", profilePicture: "", username: "", token: "", totalListings: ""); 
    ListingState listingState = ListingState(); 
    AppState mockAppState = AppState(); 
    mockAppState.user = user; 
    mockAppState.listingState = listingState; 

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => mockAppState,
        child: const MaterialApp(
          home: Scaffold(
            body: AddUpdateListing(),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton).last); 
    await tester.pump();

    expect(find.text("Bitte logge dich ein"), findsOneWidget);
  });

  testWidgets('Create listing', (WidgetTester tester) async {

    User user = User(id: "1", profilePicture: "", username: "Bob", token: "123", totalListings: "0"); 
    ListingState listingState = ListingState(); 
    listingState.categories = ["DerBär", "Mensch ärgere dich nicht"]; 
    AppState mockAppState = AppState(); 
    
    final mockListingAPI = MockListingAPI();

    listingState.api = mockListingAPI; 
    // Setup the mocked response

    mockAppState.user = user; 
    mockAppState.listingState = listingState; 

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => mockAppState,
        child: const MaterialApp(
          home: Scaffold(
            body: AddUpdateListing(),
          ),
        ),
      ),
    );
    const String titleTestInput = "Test Title";
    await tester.enterText(find.byKey(const Key("title")), titleTestInput);

    const String descriptionTestInput = "Test Description";
    await tester.enterText(find.byKey(const Key("desc")), descriptionTestInput);

    const String priceTestInput = "100";
    await tester.enterText(find.byKey(const Key("price")), priceTestInput);

    const String locationTestInput = "Test Location";
    await tester.enterText(find.byKey(const Key("location")), locationTestInput);

    const String contactTestInput = "Test Contact";
    await tester.enterText(find.byKey(const Key("contact")), contactTestInput);

    await tester.pump(); 

    await tester.tap(find.byType(DropdownButtonFormField<String>)); 
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first, warnIfMissed: false);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton).last); 
    await tester.pumpAndSettle();

    expect(find.text("Listing akutalisiert"), findsNothing); 
    expect(find.text("Fehler beim Erstellen des Lisings"), findsNothing); 
  });
}