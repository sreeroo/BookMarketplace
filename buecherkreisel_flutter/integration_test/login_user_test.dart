import 'dart:ffi';
import 'dart:math';

import 'package:buecherkreisel_flutter/components/account.dart';
import 'package:buecherkreisel_flutter/screens/explore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buecherkreisel_flutter/main.dart';
import 'package:integration_test/common.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Registration and Login Test', () {
    testWidgets('Test: Register and Login', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      // Klicke auf das 'Account'-Symbol in der BottomNavigationBar, um zur Anmeldeseite zu navigieren
      await tester.tap(find.byIcon(Icons.person));
      await tester.pump();

      // Navigation zur Registrierung
      await tester.tap(find.text('Noch keinen Account? Registrieren'));
      await tester.pump();

      // Generiere zufälligen Benutzernamen und Passwort
      String username = "testuser${Random().nextInt(10000)}";
      String password = "testpassword${Random().nextInt(10000)}";

      // Fülle die Registrierungsfelder aus
      await tester.enterText(find.byType(TextFormField).first, username);
      await tester.enterText(find.byType(TextFormField).last, password);

      // Klicke auf den Registrierungsbutton
      await tester.tap(find.widgetWithText(TextButton, 'Registrieren'));
      await tester.pumpAndSettle();

      // Überprüfe, ob die Registrierung erfolgreich war
      expect(find.byType(ProfileScreen), findsOneWidget);

      // Klicke auf den Logout-Button
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // Login-Prozess
      await tester.tap(find.byIcon(Icons.person));
      await tester.pump();

      // Fülle die Login-Felder aus
      await tester.enterText(find.byType(TextFormField).first, username);
      await tester.enterText(find.byType(TextFormField).last, password);

      // Klicke auf den Login-Button
      await tester.tap(find.widgetWithText(TextButton, 'Einloggen'));
      await tester.pumpAndSettle();

      // Überprüfe, ob der Login erfolgreich war
      expect(find.byType(ProfileScreen), findsOneWidget);
    });
  });
}
