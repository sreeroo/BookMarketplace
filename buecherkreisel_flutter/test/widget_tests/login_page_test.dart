import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:buecherkreisel_flutter/components/login.dart';
import 'package:provider/provider.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';

void main() {
  setUpAll(() {
    // ↓ required to avoid HTTP error 400 mocked returns
    HttpOverrides.global = null;
  });

  testWidgets(
      'Test:  Meldet sich mit einem leeren Benutzernamen und Passwort an',
      (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          home: Scaffold(
            body: LoginRegisterScreen(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Einloggen'));
    await tester.pump();

    expect(find.text('Bitte füllen Sie alle Felder aus'), findsOneWidget);
  });

  testWidgets(
      'Test: Meldet sich mit einem leeren  Username und Passwort länge kleiner 6 an',
      (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          home: Scaffold(
            body: LoginRegisterScreen(),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.enterText(find.byType(TextFormField).at(1), '123');
    await tester.tap(find.text('Einloggen'));
    await tester.pump();

    expect(find.text('Bitte gib einen Nutzernamen ein.'), findsOneWidget);
    expect(find.text('Bitte gib ein Passwort len>=6 ein.'), findsOneWidget);
  });

  testWidgets('Test: ohne Regristrierung anmelden', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          home: Scaffold(
            body: LoginRegisterScreen(),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'test_user');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Einloggen'));
    await tester.pump();
  });

  testWidgets('Test: weschseln zwischen anmelden und registrieren',
      (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          home: Scaffold(
            body: LoginRegisterScreen(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Noch keinen Account? Registrieren'));
    await tester.pump();

    expect(find.text('Registrieren'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('Bereits registriert? Einloggen'));
    await tester.pump();

    expect(find.text('Anmelden'), findsOneWidget);
  });

  testWidgets('Test: Hint für TextFeld Username', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          home: Scaffold(
            body: LoginRegisterScreen(),
          ),
        ),
      ),
    );

    expect(find.text('Username'), findsOneWidget);
  });

  testWidgets('Test: Hint für TextFeld Passwort', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          home: Scaffold(
            body: LoginRegisterScreen(),
          ),
        ),
      ),
    );

    expect(find.text('Passwort'), findsOneWidget);
  });
}
